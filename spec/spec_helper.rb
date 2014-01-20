require 'custom_attributes'
require 'database_cleaner'
require 'pry'

RSpec.configure do |config|

	ActiveRecord::Base.establish_connection(
		:adapter => "sqlite3", 
	  :database => File.dirname(__FILE__) + "/custom_attributes.sqlite3")

	load File.dirname(__FILE__) + '/support/schema.rb'
	load File.dirname(__FILE__) + '/support/models.rb'
	load File.dirname(__FILE__) + '/support/data.rb'
  #your other config

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean

  end

end