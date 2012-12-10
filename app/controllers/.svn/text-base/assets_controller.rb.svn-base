class AssetsController < ApplicationController
 	layout 'dashboard'

	def upload_assets
		@for_class = params[:entity_type]	
		@entity = eval(@for_class).find(params[:entity_id])
  	render :layout => "application"
		respond_to do |format|
				format.html # upload_assets.html.erb
				format.js # upload_assets.js.erb
		end
  end
  
  def download_asset
		@asset = Asset.find(params[:id])
		send_file("#{@asset.path}")
  end
      
  def show
  	@asset = Asset.find(params[:id])
		@update_div = params[:update_div]
		@multiple = params[:multiple]
		respond_to do |format|
				format.html # show.html.erb
				format.js # show.js.erb
		end
  end
  
  def destroy
    asset = Asset.find(params[:id])
    @asset_id = asset.id.to_s
    @asset_group_id = asset.group_id.to_s
    # TODO delete similar assets for other variants
    if asset.attachable_type == "Variant"
    	variants = asset.attachable.product.variants.select{|x| x.option_values.select{|x| x.option_type.name.downcase == "color"}.count > 0 and x != asset.attachable}
    	variants.each do |variant|
    		variant.images.where(:asset_order => asset.asset_order).each{|x| x.destroy}
    	end
    end
    asset.destroy
		respond_to do |format|
				format.html # destroy.html.erb
				format.js # destroy.js.erb
		end
  end
  
  def reorder
  	order = params[:order_string]
  	@group_id = params[:group_id]
  	entity_id = params[:entity_id]
  	@class_name = params[:class_name]
  	@entity = eval("#{@class_name}.find(#{entity_id})")
  	order_arr = order.split(",")
  	order_arr.each_with_index do |asset_id, index|
			a = Asset.find(asset_id)
			a.update_attributes(:asset_order => index)
		end
		respond_to do |format|
				format.html # reorder.html.erb
				format.js # reorder.js.erb
		end
  end
	
	def reorder_all
  	order = params[:order_string]
  	@group_id = params[:group_id]
  	entity_ids = params[:attachable_ids].split("|")
  	@class_name = params[:attachable_type]
  	@entities = eval(@class_name).where(:id => entity_ids)
		order_arr = order.split(",")
		order_arr.each_with_index do |asset_id, index|
			a = Asset.find(asset_id)	
			@entities.each do |e|
				a1 =  e.images.where(:asset_order => a.asset_order).last
    		a1.update_attributes(:asset_order => index)
			end		
		end
  	respond_to do |format|
				format.html # reorder.html.erb
				format.js # reorder.js.erb
		end
  end
  
  def show_update_asset
	  @asset = Asset.find(params[:asset_id])
		respond_to do |format|
				format.html # show_update_asset.html.erb
				format.js # show_update_asset.js.erb
		end
  end
  
  def update
  	@asset = Asset.find(params[:id])
		@success = false
		respond_to do |format|
			if @asset.update_attributes(params[:asset])
				@success = true
				format.html # update.html.erb
				format.js # update.js.erb
			else
				format.html # update.html.erb
				format.js # update.js.erb
			end
		end
  end
  
  def add
	  @entity = eval(params[:attachable_type]).find(params[:attachable_id])
		if @entity.is_a? User
			params[:attachable_type] = "User"
		end
	  newparams = coerce(params)
	  if params[:asset_type].present?
	  	@asset = eval(params[:asset_type]).new(newparams[:upload])
	  else
	  	@asset = Image.new(newparams[:upload])
	  end
		@update_div = params[:update_div]
		type = params[:group_id]
		object = eval("@entity.#{type}")
		logger.info "#{object}::#{object.class}"
		@multiple = true
		if object and not object.is_a? Array
			@multiple = false
			object.delete
		elsif not object
			@multiple = false
		end
		if @asset.save
      flash[:notice] = "Successfully created asset."
      respond_to do |format|
				format.json {render :json => { :result => 'success', :asset => "/assets/#{@asset.id}?update_div=#{@update_div}&multiple=#{@multiple}&asset_type=#{params[:asset_type]}" } }
	   	end
    else
      respond_to do |format|
				format.json {render :json => { :result => 'failure', :asset => "#{@asset.errors.full_messages.join(',')}" } }
	   	end
    end
  end

  def add_lookbook
	  newparams = coerce(params)
	  if params[:asset_type].present?
	  	@asset = eval(params[:asset_type]).new(newparams[:upload])
	  else
	  	@asset = Pdf.new(newparams[:upload])
	  end
    @asset.user = current_user
		@update_div = params[:update_div]
		@entity = eval(params[:attachable_type]).find(params[:attachable_id])
		type = params[:group_id]
		object = eval("@entity.#{type}")
		logger.info "#{object}::#{object.class}"
		@multiple = true
		if object and not object.is_a? Array
			@multiple = false
			object.delete
		elsif not object
			@multiple = false
		end
		if @asset.save
      flash[:notice] = "Successfully created asset."
      respond_to do |format|
				format.json {render :json => { :result => 'success', :asset => "/assets/#{@asset.id}?update_div=#{@update_div}&multiple=#{@multiple}&asset_type=#{params[:asset_type]}", :id => @asset.id, :entity_id => @entity.id } }
	   	end
	    logger.info "Lookbook uploaded..."
    else
      logger.info "Errors : #{@asset.errors}"
      render :action => 'new'
    end
  end

	def crop
		@asset = Asset.find params["id"]
		render :layout => false
	end
	
	def crop_image
		@asset = Asset.find(params[:id])	
		@success = false	
		att = params[@asset.class.to_s.underscore.gsub("spree/","")]	
		require 'RMagick'
	
	 orig_img = Magick::ImageList.new(@asset.path(:original))
	 scale = att[:scale].to_f
	 
	 args = [ att[:x1], att[:y1], att[:width], att[:height] ]
	 args = args.collect { |a| a.to_i * scale }

	 orig_img.crop!(*args)
	 orig_img.write(@asset.path(:original))

	 @asset.attachment.reprocess!
	 respond_to do |format|
			if @asset.save
				flash[:notice] = "Image cropped successfully"
				@success = true
				format.js
			else
				format.js
			end
		end
	end
  
  private
  def coerce(params)
    if params[:upload].nil?
      h = Hash.new
      h[:upload] = Hash.new
      h[:upload][:attachment] = params[:Filedata]
      h[:upload][:attachment].content_type = MIME::Types.type_for(h[:upload][:attachment].original_filename).to_s
      h[:upload][:group_id] = params[:group_id]
      h[:upload][:user_id] = params[:user_id]
      h[:upload][:attachable_type] = params[:attachable_type]
      h[:upload][:attachable_id] = params[:attachable_id]
      if params[:asset_order].present?
        h[:upload][:asset_order] = params[:asset_order]
      end
      h
    else
      params
    end
  end
end
