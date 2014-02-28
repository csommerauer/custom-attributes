module CustomAttributes 
  class Filefield < ActiveRecord::Base
    include Paperclip::Glue
    self.table_name="custom_attribute_filefields"

    enable_custom_attribute_custom_value_base
    
    attr_accessible :attachment
    has_attached_file :attachment

  end
end