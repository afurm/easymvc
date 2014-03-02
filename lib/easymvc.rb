require "easymvc/version"
require "easymvc/controller"
require "easymvc/dependencies"
require "easymvc/utils"
require "easymvc/routing"
require "easymvc/mapper"

module Easymvc
  class Application
    def call(env)
      return [500, {}, []] if env["PATH_INFO"] == "/favicon.ico"
      get_rack_app(env).call(env)
    end

    def route(&block)
      @router ||= Easymvc::Routes.new
      @router.instance_eval(&block)
    end

    def get_rack_app(env)
      @router.check_url(env["PATH_INFO"])
    end
  end
end
