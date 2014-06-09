require 'simplecov'

module SimpleCov::Configuration
  def clean_filters
    @filters = []
  end
end

SimpleCov.configure do
  clean_filters
  load_adapter 'test_frameworks'
end

ENV["COVERAGE"] && SimpleCov.start do
  add_filter "/.rvm/"
end
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require "genspec"
require 'byebug'
require 'makeloc'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  # config.raise_errors_for_deprecations!
  config.treat_symbols_as_metadata_keys_with_true_values = true
end

TMP_FOLDER = Pathname.new(File.expand_path File.join(File.dirname(__FILE__),'generators','tmp'))
TARGET_LANG = 'en'
REF_LANG = 'it'

REF_LANG_FP = Pathname.new(File.join(TMP_FOLDER,"test.#{REF_LANG}.yml"))
TARGET_LANG_FP = Pathname.new(File.join(TMP_FOLDER,"test.#{TARGET_LANG}.yml"))

TARGET_LANG_BK_FP = Pathname.new(File.join(TMP_FOLDER,"test.#{TARGET_LANG}.yml.bk"))
TARGET_INCOMPLETE_BK_FP = Pathname.new(File.join(TMP_FOLDER,"test_incomplete.#{TARGET_LANG}.yml.bk"))