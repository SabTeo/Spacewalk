class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]

  # GET /comments or /comments.json
  def index
    if Article.exists?(id: params[:id])
      @comments = Comment.where(article: params[:id])
      @comments = @comments.order(published_at: :asc)
      @art_id = params[:id]
    else  
      respond_to do |format|
        format.html { render :template => '404', status: 404}
      end
    end
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
      respond_to do |format|
        format.html { redirect_to comments_path(params[:art_id]), notice: "Non può essere vuoto"}
      end
    else
      c = Comment.new({:user => @current_user, :text => params[:text].strip, :published_at => DateTime.now,
          :article => Article.find_by(id: params[:art_id])})
      respond_to do |format|
        if c.save
          format.html { redirect_to comments_path(params[:art_id]) }
        else
          format.html { redirect_to comments_path(params[:art_id]), status: 500, notice: "Errore durante la creazione" }
        end
      end
    end

  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    t = params[:newtext].strip
    c = Comment.find(params[:id])
    respond_to do |format|
      if t == ''
        format.html { redirect_to comments_path(params[:art_id]), notice: "Non può essere vuoto"}
      elsif can? :edit, c
        c.text = t
        if c.save
          format.html { redirect_to comments_path(params[:art_id]), notice: "Commento modificato" }
        else
          format.html { redirect_to comments_path(params[:art_id]), status: 500, notice: "Errore durante la modifica" }
        end
      else
        format.html { redirect_to comments_path(params[:art_id]), status: 401 }
      end
    end

  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    comment = Comment.find(params[:id])
    respond_to do |format|
      if can? :delete, comment
        comment.destroy
        format.html { redirect_to comments_url(params[:art_id]), notice: "Commento eliminato" }
      else
        format.html { redirect_to comments_url(params[:art_id]), status: 401 }
      end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      begin
        @comment = Comment.find(params[:id])
      rescue
        respond_to do |format|
          format.html { render :template => '404', status: 404}
        end
      end
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.fetch(:comment, {})
    end
end
