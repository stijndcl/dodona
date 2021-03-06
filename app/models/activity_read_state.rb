# == Schema Information
#
# Table name: activity_read_states
#
#  id          :bigint           not null, primary key
#  activity_id :integer          not null
#  course_id   :integer
#  user_id     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ActivityReadState < ApplicationRecord
  belongs_to :activity
  belongs_to :course, optional: true
  belongs_to :user

  validates :activity, uniqueness: { scope: %i[user course], message: 'already read' }
  validate :activity_accessible_for_user?, on: :create

  after_save :invalidate_caches

  scope :in_course, ->(course) { where course_id: course.id }
  scope :in_series, ->(series) { where(course_id: series.course.id).where(activity: series.content_pages) }
  scope :of_user, ->(user) { where user_id: user.id }
  scope :before_deadline, ->(deadline) { where('created_at < ?', deadline) }

  def invalidate_caches
    activity.invalidate_delayed_users_read
    activity.activity_statuses_for(user, course).each(&:update_values)
    user.invalidate_attempted_exercises
    user.invalidate_correct_exercises

    return if course.blank?

    # Invalidate the completion status of this activity, for every series in
    # the current course that contains this activity, for the current user.
    # Afterwards, invalidate the completion status of the series itself as well.
    activity.series.where(course_id: course_id).find_each do |act_series|
      act_series.invalidate_completed?(user: user)
      act_series.invalidate_completed?(deadline: act_series.deadline, user: user)
      act_series.invalidate_started?(user: user)
      act_series.invalidate_wrong?(user: user)
    end

    # Invalidate other statistics.
    activity.invalidate_delayed_users_read(course: course)
    course.invalidate_delayed_correct_solutions
    user.invalidate_attempted_exercises(course: course)
    user.invalidate_correct_exercises(course: course)
  end

  def activity_accessible_for_user?
    errors.add(:activity, 'not accessible') unless activity.accessible?(user, course)
  end
end
