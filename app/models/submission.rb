# == Schema Information
#
# Table name: submissions
#
#  id          :integer          not null, primary key
#  exercise_id :integer
#  user_id     :integer
#  code        :text(65535)
#  summary     :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  status      :integer
#  result      :binary(16777215)
#  accepted    :boolean          default(FALSE)
#

class Submission < ApplicationRecord
  enum status: [:unknown, :correct, :wrong, :timeout, :running, :queued, :'runtime error', :'compilation error']

  belongs_to :exercise
  belongs_to :user

  after_create :evaluate

  default_scope { order(created_at: :desc) }
  scope :of_user, ->(user) { where user_id: user.id }
  scope :of_exercise, ->(exercise) { where exercise_id: exercise.id }

  def evaluate
    self.status = 'queued'
    self.save

    runner = PythiaSubmissionRunner.new(self)

    # TODO; make delayed
    runner.run
  end

  def self.normalize_status(s)
    if s == 'correct answer'
      return 'correct'
    elsif s == 'wrong answer'
      return 'wrong'
    elsif s.in?(statuses)
      return s
    else
      return 'unknown'
    end
  end
end
