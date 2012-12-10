PREFERENCES = [0,1,2,3,4,5]

CATEGORIES = ["Mobiles","Electronics","Laptops","Notebooks","Computers","Music Players"]

module Paperclip
  class Attachment
    alias original_assign assign
    def assign(*args)
      original_assign(*args)
    rescue NotIdentifiedByImageMagickError => e
    end
  end
end
