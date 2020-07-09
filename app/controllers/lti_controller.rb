class LtiController < ApplicationController
  before_action :set_claims

  def content
    p @lti_claims
  end

  private

  def set_claims
    @lti_claims = request.session['lti.claims'].to_h
  end
end
