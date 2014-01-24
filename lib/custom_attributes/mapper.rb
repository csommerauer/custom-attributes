module CustomAttributes
	module Mapper
    class Configuration
      Map = {
        "textfield" => "CustomAttributes::Textfield",
        "textarea" => "CustomAttributes::Textarea",
        "datefield" => "CustomAttributes::Datefield"
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
        case form_type
        when "textfield" then form.text_field :value, {:"data-custom-attribute-type"=>"string"}.merge(options[:input_options] || nil)
        when "datefield" then form.text_field :value, {:"data-custom-attribute-type"=>"date"}.merge(options[:input_options] || nil)
        when "textarea"  then form.text_area :value,  {:"data-custom-attribute-type"=>"text"}.merge(options[:input_options] || nil)
        end
      end
    end 
	end
end