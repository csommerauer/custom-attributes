require 'custom_attributes/action_view/view_helpers'

module CustomAttributes
  class Railtie < Rails::Railtie	
    initializer "custom_attributes.view_helpers" do |app|
      ActionView::Base.send :include, ViewHelpers
    end
  end

end