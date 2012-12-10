class Asset < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  #acts_as_list :scope => :attachable
	attr_accessor :x1,:y1,:height,:width, :scale
	belongs_to :user
	default_scope :order => "asset_order ASC"
	
	attr_accessible :attachable_id, :attachable_type, :attachment, :group_id, :type, :user_id, :x1, :y1, :height, :width, :scale, :asset_order

end

