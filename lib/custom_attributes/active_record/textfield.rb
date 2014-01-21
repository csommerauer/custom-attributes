module CustomAttributes
	
	class Textfield < ActiveRecord::Base
	  self.table_name="custom_attribute_textfields"

		has_one :entry, :class_name=>CustomAttributes::Entry, :as => :custom_value
	end
end