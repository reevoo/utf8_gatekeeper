module UTF8Gatekeeper
  class Middleware

    CHECK_ENV_KEYS = %w(HTTP_REFERER PATH_INFO QUERY_STRING REQUEST_PATH REQUEST_URI HTTP_COOKIE)

    def initialize(app)
      @app = app
    end

    def call(env)
      if check?(env)
        @app.call(env)
      else
        [400, { 'Content-Type' => 'text/plain' }, ['Sorry, you need to use valid UTF8 if you want this to work']]
      end
    end

    private

    def check?(env)
      check_env_keys?(env) &&
        check_env_rack_input?(env)
    end

    def check_env_keys?(env)
      CHECK_ENV_KEYS.map do |key|
        next unless value = env[key]
        value.valid_encoding?
      end.compact.all?
    end

    def check_env_rack_input?(env)
      case env['CONTENT_TYPE']
      when 'application/x-www-form-urlencoded'
        valid = env['rack.input'].read.valid_encoding?
        env['rack.input'].rewind if valid
        valid
      when 'multipart/form-data'
        # Don't check the data since it may contain binary content
        true
      else
        # Unknown content type. Leave it alone
        true
      end
    end
  end
end
