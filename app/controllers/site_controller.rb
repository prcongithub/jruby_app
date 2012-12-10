class SiteController < ApplicationController
	def index
		@top_products = Product.top_products(10)
	end
	
	def product_details
		@product = Product.find(params[:id])
		if current_user
			@user_preference = current_user.user_preferences.where(:item_id => @product.id).first
			@user_preference = UserPreference.new(:item_id => @product.id, :user_id => current_user.id) if not @user_preference
		end
	end
	
	def products
		scope = Product
		if params[:category].present?
			scope = scope.where(:category => params[:category])
		end
		if params[:search].present?
			scope = scope.metasearch(params[:search])
		end
		@products = scope.page(params[:page]).per(10)
	end
end
