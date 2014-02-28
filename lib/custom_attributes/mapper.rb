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

  end
end
