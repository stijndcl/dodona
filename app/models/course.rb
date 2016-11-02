# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  year        :string(255)
#  secret      :string(255)
#  open        :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text(65535)
#

require 'securerandom'
require 'csv'

class Course < ApplicationRecord
  has_many :course_memberships
  has_many :series
  has_many :users, through: :course_memberships

  validates :name, presence: true
  validates :year, presence: true

  default_scope { order(year: :desc, name: :asc) }

  before_create :generate_secret

  def formatted_year
    year.sub(/ ?- ?/, '–')
  end

  def generate_secret
    self.secret = SecureRandom.urlsafe_base64(5)
  end

  def scoresheet(options = {})
    sorted_series = series.reverse
    CSV.generate(options) do |csv|
      csv << [I18n.t('courses.scoresheet.explanation')]
      csv << [User.human_attribute_name('first_name'), User.human_attribute_name('last_name'), User.human_attribute_name('username'), User.human_attribute_name('email')].concat(sorted_series.map(&:name))
      csv << ['Maximum', '', '', ''].concat(sorted_series.map { |s| s.exercises.count })
      users.each do |user|
        row = [user.first_name, user.last_name, user.username, user.email]
        sorted_series.each do |s|
          row << s.exercises.map { |ex| ex.status_for(user, s.deadline) }.count(:correct)
        end
        csv << row
      end
    end
  end
end
