module UTF8Gatekeeper
  class Railtie < Rails::Railtie
    initializer 'utf8-gatekeeper.insert_middleware' do |app|
      app.config.middleware.insert_before 0, 'UTF8Gatekeeper::Middleware'
    end
  end
end
