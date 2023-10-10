class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]

  # GET /comments or /comments.json
  def index
    @comments = Comment.where(article: params[:id])
    @comments = @comments.order(published_at: :desc)
    @art_id = params[:id]
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
  def create
    if !user_signed_in?
      redirect_to(new_user_session_path, notice: 'devi essere loggato') 
      return 
    end
    if params[:text] != ''
    Comment.create!({:user => @current_user, :text => params[:text].strip, :published_at => DateTime.now,
      :article => Article.find_by(id: params[:art_id])})
    end
    redirect_to comments_path(params[:art_id]), notice: ""
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to comment_url(@comment), notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    comment = Comment.find(params[:id])
    if can? :delete, comment
      comment.destroy
      redirect_to comments_path(params[:art_id]), notice: ""
    #respond_to do |format|
    #  format.html { redirect_to comments_url, notice: "Comment was successfully destroyed." }
    #  format.json { head :no_content }
    #end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.fetch(:comment, {})
    end
end
