#!/usr/bin/env ruby

require 'ox'
require 'set'
require 'stringio'

#################################################################################

def debug(msg); end

#################################################################################

class Ox::Document
  def good?;  true;  end
  def empty?; false; end
end


class Ox::Element

  #
  # Tags to keep...
  #
  GOOD_TAGS = Set.new %w[
    a img
    div span p
    b i em strong
    h1 h2 h3 h4 h5 h6 h7 h8 title
    ul li ol dl dd dt
    audio video source
  ]
  def good?
    GOOD_TAGS.include? name.downcase
  end

  #
  # Tags whose contents can be discarded...
  #
  CODE_TAGS = Set.new %w[script style]  
  def code?
    CODE_TAGS.include? name.downcase
  end

  #
  # Tags that don't need to be closed...
  #
  SELF_CLOSING_TAGS = Set.new %w[br hr]
  def self_closing?
    SELF_CLOSING_TAGS.include? name.downcase
  end

  #
  # Does this tag have any children?
  #
  def empty?
    nodes.empty?
  end

end

#################################################################################

class Parser < Ox::Sax

  ###################################################
  # Init
  ###################################################

  attr_reader :root, :stack

  def initialize
    reset!
  end

  def reset!
    @root = Ox::Document.new(:version => '1.0')
    @stack = [@root]
  end    


  ###################################################
  # Element Handlers
  ###################################################

  def start_element(name)
    tag = Ox::Element.new(name)

    stack.last << tag # unless tag.self_closing?
    stack << tag
  end

  def end_element(name)
    stack.pop
  end

  def attr(name, value)
    stack.last[name] = value
  end

  def text(value)
    stack.last << value.strip
  end


  ###################################################
  # Make it go!
  ###################################################

  def parse_html!(html)
    parse_file! StringIO.new(html)
  end

  def parse_file!(file, scrub=false)
    reset!

    if file.is_a? String
      if file[/\.(gz|xz|bz2)$/]
        require 'epitools/zopen'
        file = zopen(file)
      else
        file = open(file)
      end
    end

    if scrub
      file = StringIO.new(file.read.scrub)
    end

    Ox.sax_parse(self, file)
    self
  end

  def indent
    "  " * (stack.size-1)
  end

  def print(node=nil, depth=0, out=$stdout)
    if node
      dent = "  "*depth

      case node
      when String
        out.puts "#{dent}#{node}" unless node.empty?
      when Ox::Element
        tag = [node.name, *node.attributes.map{|k,v| "#{k}=#{v.inspect}"}].join(" ")
        out.puts "#{dent}<#{tag}>"
        node.nodes.each { |n| print(n, depth+1, out) }
        out.puts "#{dent}</#{node.name}>"
      else
        raise "WTF"
      end
    else
      root.nodes.each { |n| print(n, depth, out) }
    end
  end

  def to_s
    out = StringIO.new
    print(@root, 0, out)
    out.seek(0)
    out.read
  end

end

#################################################################################

class Stripper < Parser

  ###################################################
  # Initializers/accessors
  ###################################################

  def reset!
    super
    @good = @root
  end

  #
  # Find the closest good tag to the top of the stack
  #
  def last_good
    (stack.size-1).downto(0) do |i|
      node = stack[i]
      return node if node.good? #and !node.empty?
    end
    nil
  end

  def show_stack
    debug({good: @good.inspect, stack: stack.map(&:inspect), last_good: last_good}.inspect)
  end
  
  ###################################################
  # Element Handlers
  ###################################################

  def start_element(name)
    tag = Ox::Element.new(name)

    return if tag.self_closing? # ignore BR and HR tags

    stack << tag

    debug "#{indent}/~~ #{name}"
    if tag.good? #and !tag.empty?
      @good << tag
      @good = tag
    end
  end

  def end_element(name)
    debug "#{indent}\\__ #{name}"
    stack.pop if stack.size > 1
    @good = last_good
  end

  #
  # Attributes to keep...
  #
  GOOD_ATTRS = {
    "img"    => Set.new(%i[src alt width height]),
    "a"      => Set.new(%i[href title]),
    "source" => Set.new(%i[src]),
    "video"  => Set.new(%i[src width height]),
    "audio"  => Set.new(%i[src]),
  }
  def attr(name, value)
    debug "#{indent}  #{name} => #{value.inspect}"

    tag = stack.last

    if attrs = GOOD_ATTRS[tag.name.downcase]
      if attrs.include? name.downcase
        tag[name] = value
      end
    end
  end

  def text(value)
    value = value.strip
    debug "#{indent}text #{value.inspect}"
    @good << value unless value.empty? or stack.last.code?
  end

end

HTMLCleaner = Stripper

#################################################################################

def time
  start = Time.now
  result = yield
  debug "elapsed: #{(Time.now-start).round(4)}s"
  result
end


if $0 == __FILE__
  opts, args = ARGV.partition { |arg| arg[/^--?\w/] }

  if opts.delete("--help") or opts.delete("-h")
    puts "Usage: htmlstrip [options] <file(s).html(.gz|.bz2|.xz)...>"
    puts
    puts "Purpose:"
    puts "  Strips extraneous tags from an HTML document, leaving only the bare minimum tags"
    puts "  necessary to read the document."
    puts
    puts "  (Keep tags: #{Ox::Element::GOOD_TAGS.to_a})"
    puts
    puts "Options:"
    puts "   -i      Don't strip tags, just reindent the HTML"
    puts "   -s      Scrub input of broken UTF-8 codes"
    puts "   -d      Debug mode (show parser events)"
    puts
    exit 1
  end

  if opts.delete("-d") # Debug mode
    def debug(msg); $stderr.puts msg; end
  end

  if opts.delete("-i") # No strip mode (reindent HTML)
    parser = Parser.new
  else
    parser = Stripper.new
  end

  scrub = opts.delete("-s")

  args << $stdin if args.empty?

  begin
    args.each do |arg|
      time { parser.parse!(arg, scrub) }
      parser.print
    end
  rescue Interrupt, Errno::EPIPE
  end
end
