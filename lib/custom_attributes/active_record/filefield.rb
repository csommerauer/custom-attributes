module CustomAttributes	
	class Filefield < ActiveRecord::Base
    include Paperclip::Glue
	  self.table_name="custom_attribute_filefields"

		has_one :entry, :class_name=>CustomAttributes::Entry, :as => :custom_value

    attr_accessible :attachment
    has_attached_file :attachment

	end
end