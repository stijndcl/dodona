module LTI
  module Messages
    class Message
      extend ::LTI::JWK

      def self.parse_id_token(token, issuer)
        # Get the JWKS uri for the given issuer.
        jwks_uri = Provider::Lti.find_by(issuer: issuer)&.jwks_uri
        raise 'Invalid issuer' if jwks_uri.blank?

        # Parse the id token.
        parsed_token = JSON::JWT.decode(token, parse_jwks_uri(jwks_uri))

        # Get the message type.
        message_type = parsed_token[::LTI::Messages::Claims::MESSAGE_TYPE]

        # Parse deep linking requests.
        return DeepLinkingRequest.new(parsed_token) if message_type == ::LTI::Messages::Types::DEEP_LINKING_REQUEST

        # Not implemented / invalid.
        raise format('Unsupported message type: %<type>s', type: message_type)
      end
    end
  end
end
