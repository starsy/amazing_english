class Answer < ActiveRecord::Base
  belongs_to :event
  before_create :disable_existing_answers
  before_update :disable_existing_answers
  validates :text, :trainee, presence: true

  def disable_existing_answers
    logger.info "In disable_existing_answers"
    trainee = self.trainee
    event_id = self.event_id

    Answer.where(trainee: trainee, event_id: event_id, is_active: true).each do |answer|
      logger.info "Inactivate answer id: #{answer.id}"
      if answer.id.equal? self.id
        logger.info "Skip updating active status to false for answer id: #{answer.id}"
      else
        logger.info "Updating active status to false for answer id: #{answer.id}"
        answer.update_column(:is_active, false)
      end
    end

    self.is_active= true
  end

end
