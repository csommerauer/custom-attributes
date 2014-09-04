module ActionView
  module Helpers
    class FormBuilder


      def fields_for_custom_attributes(&block)
        self.fields_for :custom_attributes, self.object.custom_attributes_populate do |f|
          yield(f)
        end
      end

      def custom_attribute_field_tag(options={})
        @template.content_tag :div, :"data-custom-attribute-id"=>self.object.id do
          self.hidden_field(:id) +
          self.hidden_field(:custom_attribute_field_id) + 
          self.custom_attribute_custom_value_tag(options)
        end.try(:html_safe)
      end

      def custom_attribute_label_tag(options={})
        self.fields_for(:custom_value, self.object.custom_value) do |iform|
          iform.label(self.custom_attribute_is_a?("filefield") ? :attachment : :value, self.object.custom_attribute_field.name.humanize, options)
        end
      end

      def field_for_custom_attribute(field,options={}, &block)
        self.fields_for :custom_attributes, self.object.custom_attribute_or_build(field), {:include_id => false, :child_index=>(Time.now.to_f * 1000).to_i} do |f|
          yield(f)
        end
      end

      def custom_attribute_custom_value_tag(options={})
        self.fields_for :custom_value, self.object.custom_value do |iform|
          if self.custom_attribute_is_a?("filefield")
            iform.form_element_custom_value_filefield(options)
          else
            iform.form_element_custom_value(self.object.custom_attribute_field.field_type, options)
          end
        end.try(:html_safe)
      end

      def custom_attribute_is_a?(field_type)
        field_type == self.object.field_type
      end

      def form_element_custom_value(form_type,options={})
        if @template.public_methods.include?(:"custom_attribute_#{form_type}")
          @template.send(:"custom_attribute_#{form_type}", self, options)
        else
          case form_type
          when "textfield"      then self.text_field :value, {:"data-custom-attribute-type"=>"string"}.merge(options)
          when "datefield"      then self.text_field :value, {:"data-custom-attribute-type"=>"date"}.merge(options)
          when "textarea"       then self.text_area :value,  {:"data-custom-attribute-type"=>"text"}.merge(options)
          when "checkbox"       then self.check_box :value,  {:"data-custom-attribute-type"=>"boolean"}.merge(options)  
          when "country_select" then self.country_select :value, ["Select your country"], {:"data-custom-attribute-type"=>"text"}.merge(options)
          end
        end
      end

      def form_element_custom_value_filefield(options={})
        if self.object.new_record?
          if @template.public_methods.include?(:custom_attribute_filefield)
            @template.custom_attribute_filefield(self, options)
          else
            self.file_field :attachment, {:"data-custom-attribute-type"=>"file"}.merge(options)
          end
        else
          if @template.public_methods.include?(:"custom_attribute_filefield_link")
            @template.custom_attribute_filefield_link(self.object, options)
          else
            @template.link_to self.object.attachment_file_name, self.object.attachment.try(:url), :class=> :custom_attribute_file_download, :target => :blank
          end
        end
      end

      def custom_attribute_filefield_delete_checkbox(options={})
        if @template.public_methods.include?(:custom_attribute_filefield_delete)
          @template.send(:custom_attribute_filefield_delete, self, options)
        else
          self.check_box(:_destroy, options)
        end unless self.object.custom_value.new_record?
      end

    end
  end
end