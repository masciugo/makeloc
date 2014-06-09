require 'rails/railtie'

module Makeloc
  class Railtie < Rails::Railtie
    generators do
      require "makeloc/generators/do/do_generator"
    end
  end
end
