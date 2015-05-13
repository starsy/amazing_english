class Event < ActiveRecord::Base
  has_one :solution
  has_many :answers
end
