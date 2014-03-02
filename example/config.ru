require './config/application.rb'
app = Blog::Application.new

app.route do
  match "/", "posts#index"
  match "/:controller/:action"
end

run app
