class Api::DocsController < ApiController
	
	def index
		@text = '<code lang="ruby"> puts "Hello, world!" </code>'
	end

	def coderay(text)
		text.gsub(/\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m) do
      CodeRay.scan($3, $2).div(:css => :class)
    end
	end

end
