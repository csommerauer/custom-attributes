module CustomAttributes
	module ViewHelpers

    def fields_for_custom_attributes(form, options={})
      form.fields_for :custom_attributes, form.object.custom_attributes_populate do |inner_form|
          %Q{ <div class="#{options[:div_class] || nil}">
                #{inner_form.hidden_field :custom_attribute_field_id}
                #{fields_for_custom_value(inner_form, options)}
              </div>
          }.html_safe
      end
    end

    def fields_for_custom_value(form, options={})
      form.fields_for :custom_value, form.object.custom_value do |iform|
        %Q{ #{iform.label :value, form.object.custom_attribute_field.name, :class=> (options[:label_class] || nil)}
            #{form_element_custom_value(iform,form.object.custom_attribute_field.field_type, options)}
        }.html_safe
      end
    end
    
	end
end