module ApplicationHelper
	def items_show_page?
		controller_name == 'items' && action_name == 'show'
	end

	def coderay(text)
		text.gsub(/\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m) do
      CodeRay.scan($3, $2).div(:css => :class)
    end
	end
		
end
