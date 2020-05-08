module ReviewHelper
  def review_action_button(text, other_review)
    if other_review
      link_to(review_path(other_review)) do
        button(text, false)
      end
    else
      button(text, true)
    end
  end

  private

  def button(text, disabled)
    button_tag(text, class: 'btn btn-default btn-text', disabled: disabled)
  end
end
