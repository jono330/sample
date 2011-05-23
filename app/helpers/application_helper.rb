module ApplicationHelper
	def logo
		return image_tag("/images/new_logo.png", :alt => "sample app", :class => "round")
	end

	def title
		base_title = "Sample Application"
		if !@title.nil?
			base_title = "#{base_title} | #{@title}"
		end
		return base_title
	end
end
