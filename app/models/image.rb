class Image < Asset
  validate :no_attachement_errors
  has_attached_file :attachment, 
  									:whiny => false,
                    :styles => { :logo => "200x100!", :mini => '48x48>', :small => '100x100>', :large => '600x400!' },
                    :url => "/system/data/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/data/:id/:style/:basename.:extension"

  # save the w,h of the original image (from which others can be calculated)
  # we need to look at the write-queue for images which have not been saved yet
  after_post_process :find_dimensions

  #used by admin products autocomplete
  def mini_url
    attachment.url(:logo, false)
  end
	
	def data
		return self.attachment
	end
	
	def self.aspect_ratio_hash
		return {:x => 48, :y => 48}
	end		
	
	def self.preview_aspect_ratio_hash
		return aspect_ratio_hash
	end
	
	def self.aspect_ratio
		return aspect_ratio_hash[:x]/aspect_ratio_hash[:y].to_f
	end		
	
	def path(style=:logo)
    attachment.path(style.to_sym)
  end
	
	def url style=:original
    attachment.url(style.to_sym, false)
  end
	
	before_save :check_size
	def check_size
		if not self.new_record? and self.attachment_width and self.attachment_height and not (self.attachment_width >= self.class.aspect_ratio_hash[:x]) && (self.attachment_height >= self.class.aspect_ratio_hash[:y])
			self.errors.add "Size", "Please upload an image with size #{self.class.aspect_ratio_hash[:x]}x#{self.class.aspect_ratio_hash[:y]} or greater"
			return false
		end
		return true
	end

  def find_dimensions
    temporary = attachment.queued_for_write[:original]
    filename = temporary.path unless temporary.nil?
    filename = attachment.path if filename.blank?
    geometry = Paperclip::Geometry.from_file(filename)
    self.attachment_width  = geometry.width
    self.attachment_height = geometry.height
  end

  # if there are errors from the plugin, then add a more meaningful message
  def no_attachement_errors
    unless attachment.errors.empty?
      # uncomment this to get rid of the less-than-useful interrim messages
      # errors.clear
      errors.add :attachment, "Paperclip returned errors for file '#{attachment_file_name}' - check ImageMagick installation or image source file."
      false
    end
  end
end