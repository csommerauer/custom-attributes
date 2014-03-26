require 'custom_attributes/action_view/view_helpers'
require 'country_select'

module CustomAttributes
  class Railtie < Rails::Railtie	
   
    config.to_prepare do
      ActionView::Base.send :include, ViewHelpers

      if Pathname("#{Rails.root}/config/custom_attributes_paperclip.yml").exist?
        Filefield.class_eval do 
          has_attached_file :attachment, 
            YAML.load_file("#{Rails.root}/config/custom_attributes_paperclip.yml")[Rails.env].try(:symbolize_keys) || {}
        end
      end

    end
  end
end