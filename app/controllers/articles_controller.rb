class ArticlesController < ApplicationController
  include Pagy::Backend
  before_action :set_article, only: %i[ show edit update destroy ]

  # GET /articles or /articles.json
  def index

    begin
      #Article.update_articles()
    rescue
    end
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
      @articles = @articles.where("title LIKE ?", '%' + session[:find].strip + '%')
    end
    if(session[:local]=='1' and session[:ext]!='1')
      @articles = @articles.where(ext_id: nil)
    elsif(session[:local]!='1' and session[:ext]=='1')
      @articles = @articles.where.not(ext_id: nil)
    end

    begin
      @pagy, @articles = pagy(@articles)
    rescue
      respond_to do |format|
        format.html { render :template => '404', status: 404}
      end
    end

  end

  # GET /articles/1 or /articles/1.json
  def show
    @article = Article.find(params[:id])
    if !@article.ext_id.nil?
      redirect_to @article.url
    end
  #  available_langs = config.host = DeepL.languages(type: :target)
  #  languages, @options = {}, []
  #  available_langs.each do |lang|
  #    languages[lang.name] = lang.code
  #  end
    languages = Article.get_supported_languages()
    @options = languages.keys
    @notice = "avvertenza: gli articoli sono tradotti automaticamente dall'italiano, potrebbero esserci errori"

    if params.key?(:lang)
      if !@options.include?params[:lang]
        redirect_to articles_path
        return
      end
      session[:lang] = params[:lang]
      @lang = params[:lang]
    else
      if session[:lang].nil? 
        @lang = 'Italiano'
      else
        @lang = session[:lang]
      end
    end

    @title = @article.title
    @body = @article.body
    if @lang!='Italiano'
      I18n.locale = :en
      begin
        @notice, @title, @body = translate_alt [@notice, @article.title, @article.body], languages[@lang]
      rescue
        @notice = 'We are sorry, the translation service for this language is not available right now'
      end
    end
    
  end

  # GET /articles/new
  def new
    @article = Article.new
    if !can?(:create, Article)
      redirect_to articles_path
    end
  end

  # GET /articles/1/edit
  def edit
  end
  
  # POST /articles or /articles.json
  def create
    @article = Article.new(params.require(:article).permit(:title, :img_url, :body, :updated_at, :created_at, :published_at, :author_id))
    respond_to do |format|
      if !can?(:create, Article)
        format.html { redirect_to articles_url, status: 401 }
      elsif @article.save
        format.html { redirect_to article_url(@article), notice: "Articolo pubblicato con successo" }
      else
        flash[:notice]="Pubblicazione fallita, titolo o contenuto non validi"
        format.html { render :new, status: 422 }
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
    art = Article.find(params[:id])
    respond_to do |format|
      if can? :delete, art
        @article.destroy
        format.html { redirect_to articles_path, notice: "Articolo eliminato" }
      else
        format.html { redirect_to articles_path, status: 401 }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      begin
        @article = Article.find(params[:id])
      rescue
        respond_to do |format|
          format.html { render :template => '404', status: 404}
        end
      end
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.fetch(:article, {})
    end

    def translate(array, lang) #[@notice, @article.title, @article.body]
      res = []
      t_notice = Rails.cache.read('notice_'+lang)
      if t_notice.nil?
        res.append(DeepL.translate array[0], 'IT', lang)
        Rails.cache.write('notice_'+lang, res[0], expires_in: 1.day)
      else
        res.append(t_notice)
      end
      t_art = Rails.cache.read(array[1]+'_'+lang)
      if t_art.nil?
        res[1], res[2] = DeepL.translate array[1,2], 'IT', lang
        Rails.cache.write(array[1]+'_'+lang, JSON.dump(res[1,2]), expires_in: 1.day)
      else
        res[1], res[2] = JSON.load(t_art)
      end
      return res
    end

    def translate_alt(array, lang)
      url = URI("https://nlp-translation.p.rapidapi.com/v1/translate")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      res = []
      t_notice = Rails.cache.read('notice_'+lang)
      if t_notice.nil?
        res[0] = send_request http, url, array[0], lang
        Rails.cache.write('notice_'+lang, res[0], expires_in: 1.day)
      else
        res[0] = t_notice
      end
      t_art = Rails.cache.read(array[1]+'_'+lang)
      if t_art.nil?
        res[1] = send_request http, url, array[1], lang
        res[2] = send_request http, url, array[2], lang
        Rails.cache.write(array[1]+'_'+lang, JSON.dump(res[1,2]), expires_in: 1.day)
      else
        res[1], res[2] = JSON.load(t_art)
      end
      return res

    end

    def send_request(http, url, text, lang)
      request = Net::HTTP::Post.new(url)
      request["content-type"] = 'application/x-www-form-urlencoded'
      request["X-RapidAPI-Key"] = 'c1577ddec7mshce99693e3a421f4p1ec607jsnada0eead59e3'
      request["X-RapidAPI-Host"] = 'nlp-translation.p.rapidapi.com'
      request.body = {text: text, to: lang, from: 'it'}.to_query   #"text=Hello%20World&to=es&from=EN"
      response = http.request(request)
      return JSON.parse(response.read_body)["translated_text"][lang]
    end

end
