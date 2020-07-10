module LTI
  module Messages
    class DeepLinkingRequest < LTI::Message
      def initialize(token_body)
        settings = token_body[::LTI::Messages::Claims::DEEP_LINKING_SETTINGS]
        p settings
      end
    end
  end
end
