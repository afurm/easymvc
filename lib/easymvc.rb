require "easymvc/version"
require "easymvc/controller"
require "easymvc/dependencies"
require "easymvc/utils"

module Easymvc
  class Application
    def call(env)
      return [302, { "Location" => "/pages/about"}, []] if env["PATH_INFO"] == "/"
      return [500, { "Location" => "/pages/about"}, []] if env["PATH_INFO"] == "/favicon.ico"

      controller_class, action = get_controller_and_action(env)
      controller = controller_class.new(env)
      response = controller.send(action)

      if controller.get_response
        controller.get_response
      else
        controller.render(action)
        controller.get_response
      end
    end

    def get_controller_and_action(env)
      _, controller_name, action = env["PATH_INFO"].split("/")
      controller_name = controller_name.capitalize + "Controller"
      [Object.const_get(controller_name), action]
    end
  end
end
