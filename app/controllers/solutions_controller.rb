class SolutionsController < ApplicationController
  before_action :set_solution, only: [:edit, :update, :destroy]
  skip_before_filter :require_login, only: [:index]

  def index
    @event = Event.find params[:id]
    @solutions = [Solution.find_by(event_id: params[:id])]

    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :created, location: @solution }
    end
  end

  def show
    @event = Event.find(params[:id])
    @solution = Solution.find params[:solution_id]

    respond_to do |format|
      format.html { render :show }
      format.json { render :show, status: :created, location: @solution }
    end
  end

  # GET /solutions/new
  def new
    @event = Event.find params[:id]
    authorize Solution.new

    if Solution.where(event_id: @event.id).count > 0
      respond_to do |format|
        flash[:warning] = "Solution already exist for this event"
        format.html { redirect_to "/events/#{@event.id}/solutions" }
        format.json { render :edit, status: :created, location: @solution }
      end
    end

    @solution = Solution.new

  end

  # GET /answers/1/edit
  def edit
    @event = Event.find(params[:id])
    @solution = Solution.find(params[:solution_id])
    authorize @solution

    respond_to do |format|
      format.html { render :edit }
      format.json { render :edit, status: :created, location: @solution }
    end
  end

  # POST /solutions
  # POST /solutions.json
  def create
    @solution = Solution.new(solution_params)
    event_id = params[:event_id]
    @solution[:event_id] = event_id
    logger.info "Event_ID: #{event_id}"

    authorize @solution

    if Solution.where(event_id: event_id).count > 0
      respond_to do |format|
        flash[:warning] = "Solution already exist for this event"
        format.html { redirect_to "/events/#{@event.id}/solutions" }
        format.json { render :edit, status: :created, location: @solution }
      end
    else
      respond_to do |format|
        if @solution.save
          flash[:success] = 'Solution was successfully created.'
          failed_answers = score(event_id, @solution.text)

          format.html { redirect_to "/events/#{event_id}/solutions" }
          format.json { render :show, status: :created, location: @solution }
        else
          format.html { render :new }
          format.json { render json: @solution.errors, status: :unprocessable_entity }
        end
      end
    end
  end


  def score (event_id, solution_text)
    @answers = Answer.where event_id: event_id || []

    failed_answers = []
    @answers.each do |answer|
      new_similarity = AnswersHelper::get_similarity(solution_text, answer.text)
      success = answer.update score: new_similarity

      if !success
        logger.warn "Unable to update score for answer: #{answer.id}"
        failed_answers << answer
      else
        logger.info "New score for answer: #{answer.id} is #{new_similarity}"
      end
    end

    return failed_answers
  end

  # PATCH/PUT /solution/1
  # PATCH/PUT /solution/1.json
  def update
    event_id = params[:id]
    solution_id = params[:solution_id]

    @solution = Solution.find_by id: solution_id
    @event = Event.find(event_id)

    authorize @solution

    if @solution.nil?
      respond_to do |format|
        format.html { redirect_to event_solutions_path(event_id), error: 'Cannot find solution in this event' }
        format.json { render :show, status: :created, location: @answer }
      end
    end

    sp = solution_params
    failed_answers = score(event_id, sp[:text])

    respond_to do |format|
      @solution.update! sp
      if failed_answers.empty?
        flash[:success] = 'Solution was successfully updated.'
        format.html { redirect_to event_solutions_path(event_id) }
        format.json { render :show, status: :ok, location: @answer }
      else
        flash[:warning] = "Solution was successfully updated, but failed to score #{failed_answers.size} answers"
        format.html { render :edit }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /solutions/1
  # DELETE /solutions/1.json
  def destroy
    event_id = params[:id]
    authorize @solution

    @solution.destroy
    respond_to do |format|
      flash[:success] = 'Solution was successfully destroyed.'
      format.html { redirect_to event_solutions_path(event_id) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_solution
      @solution = Solution.find(params[:solution_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def solution_params
      params.require(:solution).permit(:text, :provider, :event_id)
    end
end
