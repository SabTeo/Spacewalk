class ProposalsController < ApplicationController
  before_action :set_proposal, only: %i[ show edit update destroy ]

  # GET /proposals or /proposals.json
  def index
    @articles = Article.all
    if(current_user.has_role? :admin)
      @articles = @articles.where(published_at: nil, local: true)
    elsif (current_user.has_role? :user)
      @articles = @articles.where(user: current_user)
      @published_articles = @articles.where.not(published_at: nil)
      @articles = @articles.where(published_at: nil)
    end
  end

  # GET /proposals/1 or /proposals/1.json
  def show
    @article = Article.find(params[:id])
  end

  # GET /proposals/new
  def new
    @proposal = Proposal.new
  end

  # GET /proposals/1/edit
  def edit
  end

  # POST /proposals or /proposals.json
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

  # PATCH/PUT /proposals/1 or /proposals/1.json
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

  # DELETE /proposals/1 or /proposals/1.json
  def destroy
    @proposal.destroy

    respond_to do |format|
      format.html { redirect_to proposals_url, notice: "Proposal was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proposal
      @proposal = Proposal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def proposal_params
      params.fetch(:proposal, {})
    end
end
