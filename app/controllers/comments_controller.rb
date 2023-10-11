class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]

  # GET /comments or /comments.json
  def index
    @comments = Comment.where(article: params[:id])
    @comments = @comments.order(published_at: :asc)
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
      redirect_to new_user_session_path, notice: 'devi essere loggato'
      return 
    end
    if params[:text].strip == ''
      redirect_to comments_path(params[:art_id])
    else
      c = Comment.new({:user => @current_user, :text => params[:text].strip, :published_at => DateTime.now,
          :article => Article.find_by(id: params[:art_id])})
      if c.save
        respond_to do |format|
          format.html { redirect_to comments_path(params[:art_id]), notice: "" }
          format.json { redirect_to comments_path(params[:art_id]), status: :created, location: c }
        end
        return
      else
        #redirect_to comments_path(params[:art_id]), notice: ""
        respond_to do |format|
          format.html { redirect_to comments_path(params[:art_id]), status: :unprocessable_entity }
          format.json { redirect_to comments_path(params[:art_id]), status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    t = params[:newtext].strip
    if t == ''
      redirect_to comments_path(params[:art_id])
      return
    end
    c = Comment.find(params[:id])
    if c!=nil and can?(:edit, c)==true
      c.text = t
      if c.save
        respond_to do |format|
          format.html { redirect_to comments_path(params[:art_id]), notice: "Commento modificato" }
          format.json { redirect_to comments_path(params[:art_id]), status: :ok, location: comments_path(params[:art_id]) }
        end
        return
      end
    end
    #redirect_to comments_path(params[:art_id]), notice: "" 
    respond_to do |format|
      format.html { redirect_to comments_path(params[:art_id]), status: :unprocessable_entity }
      format.json { redirect_to comments_path(params[:art_id]), status: :unprocessable_entity }
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    comment = Comment.find(params[:id])
    if can? :delete, comment
      comment.destroy
    #  redirect_to comments_path(params[:art_id]), notice: ""
    end
    respond_to do |format|
      format.html { redirect_to comments_url(params[:art_id]), notice: "" }
      format.json { head :no_content }
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
