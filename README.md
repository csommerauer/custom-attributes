# CustomAttributes
[![Code Climate](https://codeclimate.com/github/csommerauer/custom-attributes.png)](https://codeclimate.com/github/csommerauer/custom-attributes)

CustomAttributes allows a model to have different attributes depending on the instance of a belongs_to association. I.e.

    #QuestionType.rb
    class QuestionType < ActiveRecord::Base
      has_many :answers
      enable_custom_attribute_fields
    end

    #Answer.rb
    class Answer < ActiveRecord::Base
      belongs_to :question_type
      enable_custom_attributes :config_holder => :question_type
    end

Let's say there are 2 types of questions

1. Questions regarding cooking
2. Questions regarding cars 

and in the Answers you can allow addititonal attributes

1. Cooking: you can add a textfield for a "main ingredient"
2. Cars: you can add textfield for "Make", a textarea for "Customizations" and a file upload for "Image"

The gem currently supports 4 field_ypes and stores them in the appropriate column

| field_type      |  column_types  | html input         |
|-----------------|----------------|--------------------|
| textfield       |  string        | input[type="text"] |	
| textarea        |  text          | textarea           |
| datefield       |  date          | input[type="text"] |
| filefield       |  see paperclip | input[type="file"] |

## Dependecies

1. Rails >= 3.1 < 4
2. Paperclip >= 2.8

## Installation

Add this line to your application's Gemfile:

    #Gemfile
    gem 'custom_attributes'

And then execute:

    $ bundle install
    $ bundle exec rails generate custom_attributes:install
    $ bundle exec rake db:migrate

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
