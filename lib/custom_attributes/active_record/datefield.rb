module CustomAttributes  
  class Datefield < ActiveRecord::Base
    self.table_name="custom_attribute_datefields"

    enable_custom_attribute_custom_value
    validate :is_valid_date

    private 

    def is_valid_date
      return true if value.nil?
      if !value.instance_of?(Date) && ((Date.parse(value) rescue ArgumentError) == ArgumentError)
        errors.add(:value, 'must be a valid date')
      end
    end

  end
end