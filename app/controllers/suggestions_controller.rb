class SuggestionsController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_action :authenticate_user!
  before_action :set_pitch_card, only: [:index, :new, :create, :update, :destroy]
  before_action :set_suggestion, only: [:update, :destroy]

  # GET /pitch_cards/1/suggestions
  # GET /pitch_cards/1/suggestions.json
  def index
    # Retrieve the comments (suggestions included) that the current user is permitted to see
    permitted_comments = @pitch_card.comments.select{|comment| can? :read_content, comment}
    # Sort most recent first
    sorted_permitted_comments = permitted_comments.sort_by {|obj| -obj.created_at.to_f}
    # Paginate the permitted_comments according to the params[:page] paramated (if set)
    @discourses = Kaminari.paginate_array(sorted_permitted_comments).page(params[:page]).per(10)
    # TODO for each discourse get it's children comments (if any)

    respond_to do |format|
      format.js
    end
  end

  # GET /pitch_cards/1/suggestions/new
  def new
    @suggestion = Suggestion.new
    @suggestion.content = params[:content]
    @pitch_point_id = params[:pitch_point_id]
    @pitch_point_name = params[:pitch_point_name]

    respond_to do |format|
      format.js
    end
  end

  # POST /pitch_cards/1/suggestions
  # POST /pitch_cards/1/suggestions.json
  def create
    # Create the suggestion in the pitch card's comments relation
    @suggestion = @pitch_card.comments.build(suggestion_params, Suggestion)
    # Inject the scope objects
    @scopes = ApplicationController.helpers.scopes(current_user)
    @suggestion.inject_scopes(@scopes)
    # Set the current user as the Suggestion's initiator
    @suggestion.author = current_user
    @suggestion.message_type = :root
    @suggestion.author_name = current_user.first_name + " " + current_user.last_name

    respond_to do |format|
      if @suggestion.save
        current_user.collab_pitch_cards << @pitch_card
        flash.now[:notice] = 'Suggestion was successfully created.'
        format.html { redirect_to :back, notice: 'Suggestion was successfully created.' }
      else
        flash.now[:alert] = pluralize(@suggestion.errors.count, "error") + ' found, please try again'
        format.html { redirect_to :back }
        format.json { render json: @suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pitch_cards/1/suggestions/1
  # PATCH/PUT /pitch_cards/1/suggestions/1.json
  def update
    # Inject the scope objects
    @scopes = ApplicationController.helpers.scopes(current_user)
    @suggestion.i_scope = params[:suggestion][:i_scope]
    @suggestion.c_scope = params[:suggestion][:c_scope]
    @suggestion.inject_scopes(@scopes)

    respond_to do |format|
      if @suggestion.update(suggestion_params)
        format.html { redirect_to :back, notice: 'Suggestion was successfully updated.' }
      else
        flash.now[:alert] = pluralize(@suggestion.errors.count, "error") + ' found, please fix before submitting'
        format.html { redirect_to :back }
        format.json { render json: @suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pitch_cards/1/suggestions/1
  # DELETE /pitch_cards/1/suggestions/1.json
  def destroy
    authorize! :manage, @suggestion
    @suggestion.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Suggestion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_suggestion
    @suggestion = Suggestion.find(params[:id])
  end

  def set_pitch_card
    @pitch_card = PitchCard.find(params[:pitch_card_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def suggestion_params
    # Screen the baddies
    params.require(:suggestion).permit(:pitch_point_id, :pitch_point_name, :content, :comment, :i_scope, :c_scope, :ic_scope, :type, :first_name, :last_name)
  end

end
