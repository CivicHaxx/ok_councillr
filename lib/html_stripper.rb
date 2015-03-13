
if $DEBUG
  def debug(msg)
    puts msg 
  end
else
  def debug(msg); end
end

#################################################################################

class Ox::Element

  GOOD_TAGS = Set.new %w[b i p span div] # Whitelisted tags...
  def good?
    GOOD_TAGS.include? name.downcase
  end

  CODE_TAGS = Set.new %w[script style]  
  def code?
    CODE_TAGS.include? name.downcase
  end

  SELF_CLOSING_TAGS = Set.new %w[br hr]
  def self_closing?
    SELF_CLOSING_TAGS.include? name.downcase
  end

  def empty?
    nodes.empty?
  end

  def inspect
    "<#{name} #{attributes}>"
  end

end


class Ox::Document
  def good?; true; end
  def empty?; false; end
end

#################################################################################

class Parser < Ox::Sax

  ###################################################
  # Init
  ###################################################

  attr_accessor :root, :stack

  def initialize
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
    stack.last << value
  end


  ###################################################
  # Make it go!
  ###################################################

  def parse!(file)
    if file.is_a? String
      if file[/\.gz/]
        require 'epitools/zopen'
        file = zopen(file)
      else
        file = open(file)
      end
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
    require 'stringio'
    out = StringIO.new
    print(@root, 0, out)
    out.seek(0)
    out.read
  end

end

#################################################################################

class Stripper < Parser

  def initialize
    super
    @good = @root
    show_stack
  end

  def last_good
    (stack.size-1).downto(0) do |i|
      node = stack[i]
      return node if node.good? #and !node.empty?
    end
    nil
  end

  def show_stack
    debug({root_good: @root.good?, good: @good.inspect, stack: stack.map(&:inspect), last_good: last_good}.inspect)
  end
  
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

  def attr(name, value)
    debug "#{indent}  #{name} => #{value.inspect}"
    stack.last[name] = value
  end

  def text(value)
    debug "#{indent}text #{value.inspect}"
    @good << value unless value.blank? or stack.last.code?
  end

end

#################################################################################

if $0 == __FILE__
  opts, args = ARGV.partition { |arg| arg[/^-\w/] }

  if args.empty?
    puts "Usage: strip.rb [options] <file.html>"
    puts
    puts "Options:"
    puts "      -s      Strip non-good tags (anything but #{Ox::Element::GOOD_TAGS.to_a})"
    puts "      -p      Print out the resulting HTML"
    exit 1
  end

  if opts.delete("-s")
    parser_class = Stripper
  else
    parser_class = Parser
  end

  args.each do |arg|
    puts "Parsing #{arg}..."
    parser = parser_class.new
    time { parser.parse!(arg) }
    parser.print if opts.delete("-p")
    p parser.to_s if opts.delete("-to_s")
  end
end
