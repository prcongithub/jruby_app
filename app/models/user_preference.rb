class UserPreference < ActiveRecord::Base
  attr_accessible :item_id, :preference, :user_id
  
  belongs_to :user
  belongs_to :item, :class_name => "Product", :foreign_key => :item_id
  
  validates :item_id, :user_id, :preference, :presence => :true
  validates :item_id, :uniqueness => { :scope => [:user_id] }
end
