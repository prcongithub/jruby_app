class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied, :with => :access_denied
  
  helper_method :get_recommended_products
  helper_method :get_top_products
  
  def access_denied
  	if current_user
			flash[:notice] = "You are not authorized to access this page!"
			redirect_to "/"
  	else
  		flash[:notice] = "You must login to access this page!"
			redirect_to new_user_session_path
  	end
  end
  
  def get_top_products(limit)
  	Product.top_products(limit)
  end
  
  def get_recommended_products(limit=4)
  	@recommended_products = Product.recommended(current_user,limit)
  end
end
