class Answer < ActiveRecord::Base
  belongs_to :event
  before_create :disable_existing_answers

  def disable_existing_answers
    logger.info "In disable_existing_answers"
    trainee = self.trainee
    event_id = self.event_id

    Answer.where(trainee: trainee, event_id: event_id, is_active: true).each do |answer|
      logger.info "Inactivate answer: #{answer.id}"
      answer.is_active = false
      answer.save
    end

    self.is_active = true
  end

end
