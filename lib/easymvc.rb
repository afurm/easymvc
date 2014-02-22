require "easymvc/version"

module Easymvc
  class Application
    def call(env)
      return [302, { "Location" => "/pages/about"}, []] if env["PATH_INFO"] == "/"
      return [500, { "Location" => "/pages/about"}, []] if env["PATH_INFO"] == "/favicon.ico"
      controller_class, action = get_controller_and_action(env)
      response = controller_class.new.send(action)

      [200, { "Content-Type" => "Text/html" }, [response]]
    end

    def get_controller_and_action(env)
      _, controller_name, action = env["PATH_INFO"].split("/")
      controller_name = controller_name.capitalize + "Controller"
      [Object.const_get(controller_name), action]
    end
  end
end
