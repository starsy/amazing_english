class SolutionsController < ApplicationController
  before_action :set_solution, only: [:edit, :update, :destroy]

  # GET /solutions
  # GET /solutions.json
  def index
    @solutions = Solution.all
  end

  # GET /solutions/1
  # GET /solutions/1.json
  def show
    @solution = Solution.find(params[:solution_id])
    @event = Event.find(params[:id])
  end

  def show_event_solutions
    @event = Event.find params[:id]
    @solutions = [Solution.find_by(event_id: params[:id])]
    #logger.info "--------> #{@solutions.inspect}"

    respond_to do |format|
      format.html { render :index }
      format.json { render :show, status: :created, location: @solution }
    end
  end

  # GET /solutions/new
  def new
    @event = Event.find params[:id]

    if Solution.where(event_id: @event.id).count > 0
      respond_to do |format|
        flash[:error] = "Solution already exist for this event"
        format.html { render :index }
        format.json { render :edit, status: :created, location: @solution }
      end
    end

    @solution = Solution.new

  end

  # GET /solutions/1/edit
  def edit
  end

  # GET /answers/1/edit
  def edit_event_solution
    @event = Event.find(params[:id])
    @solution = Solution.find(params[:solution_id])

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

    respond_to do |format|
      if @solution.save
        format.html { redirect_to "/events/#{event_id}/solutions", notice: 'Solution was successfully created.' }
        format.json { render :show, status: :created, location: @solution }
      else
        format.html { render :new }
        format.json { render json: @solution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /solution/1
  # PATCH/PUT /solution/1.json
  def update_event_solution
    event_id = params[:id]
    solution_id = params[:solution_id]

    @solution = Solution.find_by id: solution_id
    @event = Event.find(event_id)

    if @solution.nil?
      respond_to do |format|
        format.html { redirect_to event_solutions_path(event_id), error: 'Cannot find solution in this event' }
        format.json { render :show, status: :created, location: @answer }
      end
    end

    @answers = Answer.where event_id: event_id || []

    failed_answer = []
    sp = solution_params
    @answers.each do |answer|
      new_similarity = AnswersHelper::get_similarity(sp[:text], answer.text)
      success = answer.update score: new_similarity

      if !success
        logger.warn "Unable to update score for answer: #{answer.id}"
        failed_answer << answer
      else
        logger.info "New score for answer: #{answer.id} is #{new_similarity}"
      end
    end


    respond_to do |format|
      @solution.update! sp
      if failed_answer.empty?
        format.html { redirect_to event_solutions_path(event_id), notice: 'Solution was successfully updated.' }
        format.json { render :show, status: :ok, location: @answer }
      else
        format.html { render :edit }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /solutions/1
  # PATCH/PUT /solutions/1.json
  def update
    respond_to do |format|
      if @solution.update(solution_params)
        format.html { redirect_to @solution, notice: 'Solution was successfully updated.' }
        format.json { render :show, status: :ok, location: @solution }
      else
        format.html { render :edit }
        format.json { render json: @solution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /solutions/1
  # DELETE /solutions/1.json
  def destroy
    @solution.destroy
    respond_to do |format|
      format.html { redirect_to solutions_url, notice: 'Solution was successfully destroyed.' }
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
