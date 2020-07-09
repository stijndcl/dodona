require 'openid_connect'

# This strategy augments the existing oidc strategy for Dodona.
module OmniAuth
  module Strategies
    class LTI < OmniAuth::Strategies::OpenIDConnect
      include LtiHelper

      option :name, 'lti'

      def key_or_secret
        # Download the jwks keyset from the provider.
        @jwks ||= JSON.parse(
            HTTPClient.new.get_content(options.client_options.jwks_uri)
        ).with_indifferent_access

        # Parse the keys
        JSON::JWK::Set.new @jwks[:keys]
      end

      def callback_phase
        begin
          super
        rescue
          # Error handling.
          fail!(:invalid_response, $!)
        end
      end

      def id_token_callback_phase
        # Parse the JWT to obtain the raw response.
        raw_info = decode_id_token(params['id_token']).raw_attributes

        # Parse the claims.
        claims = raw_info
                     .select { |k, _| k.match(/claim/) }
                     .map { |k, v| [k.delete_prefix(CLAIM_PREFIX).to_sym, v] }
                     .to_h

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
                target: claims[:target_link_uri]
            }
        )

        # Store the claims in the session.
        session['lti.claims'] = claims

        call_app!
      end
    end
  end
end

OmniAuth.config.add_camelization 'lti', 'LTI'
