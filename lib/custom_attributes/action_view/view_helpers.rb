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

    def custom_attribute_html(custom_attribute)
      case custom_attribute.custom_attribute_field.field_type
      when "textfield" then custom_attribute.value
      when "textarea"  then h(custom_attribute.value).gsub("\n", "<br/>" ).html_safe
      when "datefield" 
        custom_attribute.value.strftime("%d/%m/%Y") unless custom_attribute.value.nil?
      when "filefield"
        link_to("Link to Document", custom_attribute.value.url, :target=>:_blank) if custom_attribute.custom_value.attachment.exists?
      end || ""
    end    
  end
end