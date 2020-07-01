require 'openid_connect'

# This strategy augments the existing oidc strategy for Dodona.
module OmniAuth
  module Strategies
    class LTI < OmniAuth::Strategies::OpenIDConnect
      option :name, 'lti'

      def key_or_secret
        # Download the jwks keyset from the provider.
        @jwks ||= JSON.parse(
            HTTPClient.new.get_content(options.client_options.jwks_uri)
        ).with_indifferent_access

        # Parse the keys
        JSON::JWK::Set.new @jwks[:keys]
      end
    end
  end
end

OmniAuth.config.add_camelization 'lti', 'LTI'
