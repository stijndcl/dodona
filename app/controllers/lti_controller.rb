class LtiController < ApplicationController
  before_action :set_lti_request

  # Allow the content endpoint to be embedded in modals.
  content_security_policy only: %i[content_selection] do |policy|
    policy.frame_ancestors '*'
  end

  def content_selection
    @courses = Course.all
    render :content
  end

  private

  # TODO this token should be parsed into a message object of some sort.
  def set_lti_request
    @lti_request = params[:id_token]
  end
end
