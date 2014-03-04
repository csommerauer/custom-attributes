require 'custom_attributes/action_view/view_helpers'
require 'country_select'

module CustomAttributes
  class Railtie < Rails::Railtie	
    #initializer "custom_attributes.view_helpers" do |app|
    config.to_prepare do
      ActionView::Base.send :include, ViewHelpers
#      ActionView::Base.send :include, Mapper::ViewHelpers
    end
  end
end