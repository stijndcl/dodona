require_relative 'settings.rb'

module OmniAuth
  module Strategies
    class LTI
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
                                      lti_message_hint: params[:lti_message_hint]
                                  })
        end

        def failure!
          raise "Invalid provider."
        end

        def params
          @params ||= Rack::Request.new(@env).params.symbolize_keys
        end

        def provider
          # Get the provider from the provider parameter.
          return Provider::Lti.find_by(id: params[:provider]) if params[:provider].present?

          # Get the provider from the issuer parameter.
          Provider::Lti.find_by(issuer: params[:iss]) if params[:iss].present?
        end
      end
    end
  end
end
