module LTI
  module Messages
    module Types
      class DeepLinkingRequest
        include LTI::Messages::Message

        require_parameter :accept_presentation_document_targets
        require_parameter :accept_types
        require_parameter :deep_link_return_url

        def initialize(token_body)
          p required_parameters
        end
      end
    end
  end
end
