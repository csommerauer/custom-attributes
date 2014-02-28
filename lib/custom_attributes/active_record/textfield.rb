module CustomAttributes
  class Textfield < ActiveRecord::Base
    self.table_name="custom_attribute_textfields"

    enable_custom_attribute_custom_value
  end
end
