module CustomAttributes
  class Textarea < ActiveRecord::Base
    self.table_name="custom_attribute_textareas"

    enable_custom_attribute_custom_value
  end
end