module ApplicationHelper

	def on_page?(controller: nil, action: nil)
		current_page?(url_for(controller: controller, action: action))
	end
end
