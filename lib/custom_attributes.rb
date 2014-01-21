require "custom_attributes/version"
require 'active_record'

require "custom_attributes/active_record/core"
require "custom_attributes/active_record/field"
require "custom_attributes/active_record/entry"
require "custom_attributes/active_record/textfield"

require 'custom_attributes/railtie' if defined?(Rails)