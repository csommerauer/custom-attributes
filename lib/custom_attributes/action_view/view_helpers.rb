module CustomAttributes
	module ViewHelpers

    def fields_for_custom_attributes(form, options={})
      form.fields_for :custom_attributes, form.object.custom_attributes_populate do |inner_form|
        if inner_form.object.field_type == "filefield"
          field_for_custom_file_field_attributes(inner_form, options)
        else          
          field_for_custom_attribute(inner_form, options)
        end
      end
    end

    def field_for_custom_attribute(form, options={})
      %Q{ <div class="#{options[:div_class] || nil}">
            #{form.hidden_field :custom_attribute_field_id}
            #{fields_for_custom_value(form, options)}
          </div>
        }.html_safe
    end

    def field_for_custom_file_field_attributes(form, options={})
      %Q{ <div class="#{options[:div_class] || nil}">
            #{form.hidden_field :custom_attribute_field_id}
            #{fields_for_custom_value(form, options)}
            #{file_field_delete_checkbox(form,options)}
          </div>
        }.html_safe
    end

    def file_field_delete_checkbox(form,options={})
      %Q{#{form.check_box(:_destroy, options[:input_options] || {}) unless form.object.custom_value.new_record?}}.html_safe
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