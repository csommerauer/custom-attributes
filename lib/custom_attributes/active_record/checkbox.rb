module CustomAttributes
  class Checkbox < ActiveRecord::Base
    self.table_name="custom_attribute_checkboxes"

    enable_custom_attribute_custom_value
  end
end
