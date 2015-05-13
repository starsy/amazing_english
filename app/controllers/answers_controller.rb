require 'gsl'
require 'tf-idf-similarity'

class AnswersController < ApplicationController
  before_action :set_answer, only: [:update, :destroy]

  # GET /answers
  # GET /answers.json
  def index
    @answers = Answer.all
  end

  # GET /answers/1
  # GET /answers/1.json
  def show
    @answer = Answer.find(params[:answer_id])
    @event = Event.find(params[:id])

  end

  def show_event_answers
    @answers = Answer.where(event_id: params[:id]) || []
    logger.info "--------> #{@answers.inspect}"

    respond_to do |format|
      format.html { render :index }
      format.json { render :show, status: :created, location: @answer }
    end
  end

  # GET /answers/new
  def new
    @answer = Answer.new
  end

  # GET /answers/1/edit
  def edit
    @answer = Answer.find(params[:id])
  end

  # GET /answers/1/edit
  def edit_event_answer
    params[:event_id] = params[:id]
    params[:id] = params[:answer_id] || params[:id]
    @event = Event.find(params[:event_id])
    @answer = Answer.find(params[:id])

    respond_to do |format|
      format.html { render :edit }
      format.json { render :edit, status: :created, location: @answer }
    end
  end

  # POST /answers
  # POST /answers.json
  def create
    @answer = Answer.new(answer_params)
    event_id = params[:event_id]




    @answer[:event_id] = event_id
    logger.info "Event_ID: #{event_id}"

    solution = Solution.find_by event_id: event_id

    if solution.nil?
      respond_to do |format|
          format.html { redirect_to "/events/#{event_id}/answers", error: 'Cannot find solution in this event' }
          format.json { render :show, status: :created, location: @answer }
      end
    end

    similarity = AnswersHelper::get_similarity(solution.text, @answer.text)
    @answer.score = similarity
    logger.info "-----> Similarity Score: #{similarity}"

    respond_to do |format|
      if @answer.save
        format.html { redirect_to "/events/#{event_id}/answers", notice: 'Answer was successfully created.' }
        format.json { render :show, status: :created, location: @answer }
      else
        format.html { render :new }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /answers/1
  # PATCH/PUT /answers/1.json
  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.html { redirect_to @answer, notice: 'Answer was successfully updated.' }
        format.json { render :show, status: :ok, location: @answer }
      else
        format.html { render :edit }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /answers/1
  # PATCH/PUT /answers/1.json
  def update_event_answer
    event_id = params[:id]
    @answer = Answer.find(params[:answer_id])

    solution = Solution.find_by_event_id event_id

    if solution.nil?
      respond_to do |format|
        format.html { redirect_to @answer, error: 'Cannot find solution in this event' }
        format.json { render :show, status: :created, location: @answer }
      end
    end

    similarity = AnswersHelper::get_similarity(solution.text, @answer.text)
    @answer.score = similarity
    logger.info "-----> Similarity Score: #{similarity}"

    respond_to do |format|
      ap = answer_params
      ap[:score] = similarity
      if @answer.update!(ap)
        format.html { redirect_to event_answers_path(event_id), notice: 'Answer was successfully updated.' }
        format.json { render :show, status: :ok, location: @answer }
      else
        format.html { render :edit }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to answers_url, notice: 'Answer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:text, :trainee, :score)
    end
end
