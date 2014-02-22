require "easymvc/version"

module Easymvc
  class Application
    def call(env)
      [200, { "Content-Type" => "Text/html" }, ["Hello"]]
    end
  end
end
