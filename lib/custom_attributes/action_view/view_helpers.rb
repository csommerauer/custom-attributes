module CustomAttributes
  module ViewHelpers

    def field_for_custom_attribute(object, field, &block)
      fields_for custom_attribute_field_name_prefix(object), object.build_new_custom_attribute(field.id) do |f|
        yield(f)
      end
    end

    def single_custom_attribute_field_tag(object, field_id,options={})
      fields_for custom_attribute_field_name_prefix(object), object.build_new_custom_attribute(field_id) do |f|
        f.custom_attribute_field_tag(options)
      end
    end

    def custom_attribute_field_name_prefix(object)
      :"#{object.class.to_s.underscore.gsub('/','_')}[custom_attributes_attributes][#{(Time.now.to_f * 1000).to_i}]"
    end
    
  end
end