module CustomAttributes
	module Mapper
    class Configuration
      Map = {
        "textfield" => "CustomAttributes::Textfield",
        "textarea" => "CustomAttributes::Textarea",
        "datefield" => "CustomAttributes::Datefield",
        "filefield" => "CustomAttributes::Filefield"
      }

      def self.available_fields
        Map.keys
      end

      def self.custom_value_type(field_type)
        Map[field_type]
      end
    end

    module ViewHelpers
      def form_element_custom_value(form,form_type,options)
        if self.public_methods.include?(:"custom_attribute_#{form_type}")
          self.send(:"custom_attribute_#{form_type}", form, options)
        else
          case form_type
          when "textfield" then form.text_field :value, {:"data-custom-attribute-type"=>"string"}.merge(options[:input_options] || {})
          when "datefield" then form.text_field :value, {:"data-custom-attribute-type"=>"date"}.merge(options[:input_options] || {})
          when "textarea"  then form.text_area :value,  {:"data-custom-attribute-type"=>"text"}.merge(options[:input_options] || {})
          when "filefield" 
            if form.object.new_record?
              form.file_field :attachment, {:"data-custom-attribute-type"=>"file"}.merge(options[:input_options] || {})
            else
              link_to form.object.attachment_file_name, form.object.attachment.try(:url), :target => :blank
            end
          end
        end
      end
    end 
	end
end