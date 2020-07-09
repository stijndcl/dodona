require_relative 'settings.rb'

module LTI
  module Auth
    module OmniAuth
      class Setup
        def self.call(env)
          new(env).setup
        end

        def initialize(env)
          @env = env
        end

        def setup
          @env['omniauth.params'] ||= {}
          @env['omniauth.strategy'].options.merge!(OmniAuth::Strategies::LTI::Settings.base)
          @env['omniauth.strategy'].options.merge!(configure)
        end

        private

        def configure
          # Obtain the openid parameters for the provider.
          _provider = provider
          return failure! if _provider.blank?

          provider_settings = OmniAuth::Strategies::LTI::Settings.for_provider(_provider)
          provider_settings.merge({
                                      extra_authorize_params: {
                                          lti_message_hint: params[:lti_message_hint]
                                      }
                                  })
        end

        def failure!
          raise "Invalid or unknown LTI provider."
        end

        def params
          @params ||= Rack::Request.new(@env).params.symbolize_keys
        end

        def provider
          # Get the provider from the provider parameter.
          return Provider::Lti.find_by(id: params[:provider]) if params[:provider].present?

          # Get the provider from the issuer parameter.
          return Provider::Lti.find_by(issuer: params[:iss]) if params[:iss].present?

          # If there is a JWT available, we can parse that to find the issuer.
          return nil if params[:id_token].blank?

          # Parse the JWT token.
          jwt_token = JSON::JWT.decode params[:id_token], :skip_verification
          Provider::Lti.find_by(issuer: jwt_token[:iss])
        end
      end
    end
  end
end
