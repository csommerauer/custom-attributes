module CustomAttributes
  
  class Textarea < ActiveRecord::Base
    self.table_name="custom_attribute_textareas"

    has_one :entry, :class_name=>CustomAttributes::Entry, :as => :custom_value
  end
end