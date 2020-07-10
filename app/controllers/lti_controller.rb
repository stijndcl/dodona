require_relative '../../lib/LTI/messages.rb'

class LtiController < ApplicationController
  before_action :set_lti_message

  # Allow the content endpoint to be embedded in modals.
  content_security_policy only: %i[content_selection] do |policy|
    policy.frame_ancestors '*'
  end

  def content_selection
    # Parse the DeepLinking settings from the request.
    @courses = Course.all
    render :content
  end

  private

  def set_lti_message
    @lti_request = ::LTI::Messages.parse_id_token(params[:id_token], params[:issuer])
  end
end
