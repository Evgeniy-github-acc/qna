require 'rails_helper'

RSpec.configure do |config|
  config.before(:each, sphinx: true) do |example|
    #DatabaseCleaner.strategy = :truncation
    ThinkingSphinx::Test.init
    ThinkingSphinx::Test.start index: false
    ThinkingSphinx::Configuration.instance.settings['real_time_callbacks'] = true
  end

  config.after(:each, sphinx: true) do |example|
    ThinkingSphinx::Test.stop
    ThinkingSphinx::Test.clear
    #DatabaseCleaner.clean
  end
end
