require 'action_view'
require 'active_support'
require 'custom_attributes/action_view/view_helpers'
require 'spec_helper'




describe 'CustomAttributes::ViewHelpers' do
	include ActionView::Helpers
  include CustomAttributes::ViewHelpers

  let(:config_holder) { ConfigHolder.first}
	let(:attr_holder) {AttributeHolder.first}

end

