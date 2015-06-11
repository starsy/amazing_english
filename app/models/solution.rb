class Solution < ActiveRecord::Base
  belongs_to :event
  validates :text, :provider, presence: true
end
