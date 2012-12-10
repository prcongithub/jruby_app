class AdminController < ApplicationController
	before_filter :authenticate_user!
	layout :layout_for_js

	private
	
	def layout_for_js
  	Rails.logger.info "************ #{request.format} *****************"
		if request.format == "text/javascript"
			return "ajax"	
		end
		return "dashboard"
	end
end
