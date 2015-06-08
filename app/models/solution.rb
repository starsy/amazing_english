class Solution < ActiveRecord::Base
  belongs_to :event
  validates :text, :trainee, presence: true
end
