module ApplicationHelper
	def title
		base_title = "Sample Application"
		if !@title.nil?
			base_title = "#{base_title} | #{@title}"
		end
		return base_title
	end
end
