module LTI
  module Messages
    class DeepLinkingRequest < LTI::Messages::Message
      def initialize(token_body)
        settings = token_body[::LTI::Messages::Claims::DEEP_LINKING_SETTINGS]
        
      end
    end
  end
end
