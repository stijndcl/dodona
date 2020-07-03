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

      def id_token_callback_phase
        # Parse the JWT to obtain the raw response.
        raw_info = decode_id_token(params['id_token']).raw_attributes

        # Configure the info hashes.
        env['omniauth.auth'] = AuthHash.new(
            provider: name,
            uid: raw_info[:sub],
            info: {
                username: raw_info[:sub],
                first_name: raw_info[:given_name],
                last_name: raw_info[:family_name],
                email: raw_info[:email]
            },
            extra: {
                provider: Provider::Lti.find_by(issuer: raw_info[:iss]),
                target: raw_info['https://purl.imsglobal.org/spec/lti/claim/target_link_uri']
            }
        )
        call_app!
      end
    end
  end
end

OmniAuth.config.add_camelization 'lti', 'LTI'
