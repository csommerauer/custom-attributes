module CustomAttributes
  module ViewHelpers

    def fields_for_custom_attributes(outer_form, &block)
      @outer_form = outer_form
      @outer_form.fields_for :custom_attributes, @outer_form.object.custom_attributes_populate do |inner_form|
        @inner_form = inner_form
        yield
      end
    end

    def field_for_custom_attribute(object, field, &block)
      fields_for :"#{object.class.to_s.underscore.gsub('/','_')}[custom_attributes_attributes][#{(Time.now.to_f * 1000).to_i}]", object.build_new_custom_attribute(field.id) do |inner_form|
          @inner_form = inner_form
          yield
      end
    end

    def custom_attribute_is_a?(field_type)
      field_type == @inner_form.object.field_type
    end

    def single_custom_attribute_field_tag(object, field_id,options={})
      fields_for :"#{object.class.to_s.underscore}[custom_attributes_attributes][#{(Time.now.to_f * 1000).to_i}]", object.build_new_custom_attribute(field_id) do |inner_form|
          @inner_form = inner_form
          custom_attribute_field_tag(options)
      end
    end

    def custom_attribute_field_tag(options={})
      content_tag :div, :"data-custom-attribute-id"=>@inner_form.object.id do
        @inner_form.hidden_field(:custom_attribute_field_id) + 
        custom_attribute_custom_value_tag(@inner_form, options)
      end.html_safe
    end

    def custom_attribute_label_tag(options={})
      @inner_form.fields_for(:custom_value, @inner_form.object.custom_value, :include_id => false) do |iform|
        iform.label(custom_attribute_is_a?("filefield") ? :attachment : :value, @inner_form.object.custom_attribute_field.name, options)
      end
    end

    def custom_attribute_custom_value_tag(form, options={})
      form.fields_for :custom_value, form.object.custom_value do |iform|
        @core_form = iform
        if custom_attribute_is_a?("filefield")
          form_element_custom_value_filefield(iform, options)
        else
          form_element_custom_value(iform,form.object.custom_attribute_field.field_type, options)
        end
      end.html_safe
    end

    def filefield_delete_checkbox(options={})
      if self.public_methods.include?(:custom_attribute_filefield_delete)
        self.send(:custom_attribute_filefield_delete, @inner_form, options)
      else
        @inner_form.check_box(:_destroy, options)
      end unless @core_form.object.new_record?
    end
    
  end
end