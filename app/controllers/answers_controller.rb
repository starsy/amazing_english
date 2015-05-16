class AnswersController < ApplicationController
  before_action :set_answer, only: [:update]
  skip_before_filter :require_login, only: [:new, :create, :show, :index]

  def index
    @event = Event.find(params[:id])
    @answers = Answer.where(event_id: params[:id]).order!(score: :desc) || []

    if @event.is_solution_published
      skip_authorization
    else
      authorize Answer.new
    end

    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :created, location: event_answers_path(@event) }
    end
  end

  def show
    @answer = Answer.find(params[:answer_id])
    @event = Event.find(params[:id])

    if @event.is_solution_published
      skip_authorization
    else
      authorize Answer.new
    end

    solution = @answer.event.solution
    @solution_text = (solution.text if solution) || ''
    @solution_text = @solution_text.delete("\n").delete("\r")

    @answer_text = @answer.text || ''
    @answer_text = @answer_text.delete("\n").delete("\r")

    respond_to do |format|
      format.html { render :show }
      format.json { render :show, status: :created, location: event_answers_path(@event) }
    end
  end

  # GET /answers/new
  def new
    @answer = Answer.new
    authorize @answer
  end

  # GET /answers/1/edit
  def edit
    @event = Event.find(params[:id])
    @answer = Answer.find(params[:answer_id])
    authorize @answer

    respond_to do |format|
      format.html { render :edit }
      format.json { render :edit, status: :created, location: @answer }
    end
  end

  # POST /answers
  # POST /answers.json
  def create
    event_id = params[:event_id]
    @answer = Answer.new(answer_params)
    authorize @answer

    @answer[:event_id] = event_id

    trainee = @answer[:trainee]

    solution = Solution.find_by event_id: event_id
    solution_text = solution ? solution.text : 'zzzz'
    logger.info "------> solution: #{solution_text.inspect}"
    logger.info "------> answer: #{@answer.text.inspect}"

    similarity = AnswersHelper::get_similarity(solution_text, @answer.text)

    @answer.score = similarity
    logger.info "-----> Similarity Score: #{similarity}"

    respond_to do |format|
      if @answer.save
        flash[:success] = 'Answer was successfully created.'
        if !logged_in?
          format.html { redirect_to root_path }
        end

        format.html { redirect_to "/events" }
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
    event_id = params[:id]
    @answer = Answer.find(params[:answer_id])
    authorize @answer

    solution = Solution.find_by event_id: event_id
    solution_text = solution ? solution.text : nil

    ap = answer_params
    similarity = AnswersHelper::get_similarity(solution_text, ap[:text])
    ap[:score] = similarity
    @answer.score = similarity

    logger.info "-----> Similarity Score: #{similarity}"

    respond_to do |format|
      if @answer.update!(ap)
        flash[:success] = 'Answer was successfully updated.'
        format.html { redirect_to event_answers_path(event_id) }
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
    event_id = params[:id]
    @answer = Answer.find(params[:answer_id])
    authorize @answer

    @answer.destroy
    respond_to do |format|
      flash[:success] = 'Answer was successfully destroyed.'
      format.html { redirect_to event_answers_path(event_id) }
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
      params.require(:answer).permit(:text, :trainee)
    end
end
