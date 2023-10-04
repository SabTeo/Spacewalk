class ArticlesController < ApplicationController
  include Pagy::Backend
  before_action :set_article, only: %i[ show edit update destroy ]

  # GET /articles or /articles.json
  def index
    @articles = Article.all.order(published_at: :desc)

    #update session if submitting form
    if params.key?(:commit)
      if params.key?(:find)
        session[:find]=params['find']
      end
      if params.key?(:local)
        session[:local]=params[:local]
      else
        session[:local]='0'
      end
      if params.key?(:ext)
        session[:ext]=params[:ext]
      else
        session[:ext]='0'
      end
    end

    #update results based on session
    if !session[:find].nil?
      @articles = @articles.where("title LIKE ?", '%' + session[:find] + '%')
    end
    if(session[:local]=='1' and session[:ext]!='1')
      @articles = @articles.where(local: true)
    elsif(session[:local]!='1' and session[:ext]=='1')
      @articles = @articles.where(local: false)
    end

    @pagy, @articles = pagy(@articles)

  end

  # GET /articles/1 or /articles/1.json
  def show
    @article = Article.find(params[:id])
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.fetch(:article, {})
    end
end
