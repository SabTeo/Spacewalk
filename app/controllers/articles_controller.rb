class ArticlesController < ApplicationController
  include Pagy::Backend
  before_action :set_article, only: %i[ show edit update destroy ]

  def proposal
    @articles = Article.all
    if(current_user.has_role? :admin)
      @articles = @articles.where(published_at: nil, local: true)
    elsif (current_user.has_role? :user)
      @articles = @articles.where(user: current_user)
      @published_articles = @articles.where.not(published_at: nil)
      @articles = @articles.where(published_at: nil)
    end
  end


  # GET /articles or /articles.json
  def index

    begin
      #Article.update_articles()
    rescue
    end

    @articles = Article.all.where.not(published_at: :nil).order(published_at: :desc)

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

    begin
      uri = URI('https://api.nasa.gov/planetary/apod?api_key=jIV8fNZEkWtb2OXx8TkN9pVpnljdIpLZMpgbcqOn')
      response_string = Net::HTTP.get(uri)
      response = JSON.parse response_string
      @apod_url = response['url']
    rescue
    end

  end

  # GET /articles/1 or /articles/1.json
  def show
    @article = Article.find(params[:id])
  #  available_langs = config.host = DeepL.languages(type: :target)
  #  languages, @options = {}, []
  #  available_langs.each do |lang|
  #    languages[lang.name] = lang.code
  #  end
    languages = Article.get_supported_languages()
    @options = languages.keys
    @notice = "avvertenza: gli articoli sono tradotti automaticamente dall'italiano, potrebbero esserci errori"

    if params.key?(:lang)
      session[:lang] = params[:lang]
      @lang = params[:lang]
    else
      if session[:lang].nil? 
        @lang = 'Italiano'
      else
        @lang = session[:lang]
      end
    end

    if @lang!='Italiano'
      I18n.locale = :en
      begin
        translations = DeepL.translate [@notice, @article.title, @article.body], 'IT', languages[@lang]
        @notice, @title, @body = translations
      rescue
        flash[:notice] = 'Service not available'
      end
    else
      I18n.locale = :it
      @title = @article.title
      @body = @article.body
    end
    
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
    #@article = Article.new(params[:post])
    @article = Article.new(params.require(:article).permit(:title, :img_url, :body))
    @article.updated_at = DateTime.new
    @article.created_at = DateTime.new
    @article.local = true
    @article.user = current_user
    if @article.save
      redirect_to proposal_path(user: :normal), notice: "Article was successfully created."
    else
      flash.now[:error] = "Article creation failed"
      redirect_to new_article_path
    end
=begin
    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
=end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    @article = Article.find(params[:id])
    @article.update(published_at: DateTime.now)
    redirect_to proposal_path
=begin
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
=end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to proposal_path(user: :normal), notice: "Article was successfully destroyed." }
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
