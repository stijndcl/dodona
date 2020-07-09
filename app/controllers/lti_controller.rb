class LtiController < ApplicationController
  before_action :set_claims

  # Allow the content endpoint to be embedded in modals.
  content_security_policy only: %i[content] do |policy|
    policy.frame_ancestors '*'
  end

  def content_selection
    @courses = Course.all
    p @lti_claims
    render :content
  end

  private

  def set_claims
    @lti_claims = request.session['lti.claims'].deep_symbolize_keys
  end
end
