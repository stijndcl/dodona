module LTI
  module Messages
    module Message
      module ClassMethods
        def parameters
          required_parameters
        end

        # ==> Required parameters.

        def required_parameters
          @required_parameters ||= {}
        end

        def require_parameter(name, value = nil)
          required_parameters[name] = value
        end
      end
    end
  end
end
