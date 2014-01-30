require "custom_attributes/version"
require 'active_record'
require 'paperclip'

require "custom_attributes/mapper"
require "custom_attributes/active_record/core"
require "custom_attributes/active_record/field"
require "custom_attributes/active_record/entry"
require "custom_attributes/active_record/textfield"
require "custom_attributes/active_record/textarea"
require "custom_attributes/active_record/datefield"
require "custom_attributes/active_record/filefield"

require 'custom_attributes/railtie' if defined?(Rails)