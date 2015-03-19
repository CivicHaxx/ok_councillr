module ApplicationHelper
	def items_show_page?
		controller_name == 'items' && action_name == 'show'
	end
end
