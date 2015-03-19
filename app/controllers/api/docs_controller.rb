class Api::DocsController < ApiController
	
	def index
		@text = '<p>Some text</p><code lang="ruby"> puts "Hello, world!" </code>'
	end
end
