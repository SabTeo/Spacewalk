class ProposalsController < ApplicationController
  before_action :set_proposal, only: %i[ show edit update destroy ]

  # GET /proposals or /proposals.json
  def index
    @proposals = Proposal.all
    if(current_user.has_role? :admin)
      @proposals = @proposals.where(status: 0)
    elsif (current_user.has_role? :user)
      @rejected_proposals = @proposals.where(user: current_user, status: 1)
      @proposals = @proposals.where(user: current_user, status: 0)
      
    end
  end

  # GET /proposals/1 or /proposals/1.json
  def show
    @proposal = Proposal.find(params[:id])
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
    @proposal = Proposal.new(params.require(:proposal).permit(:title, :img_url, :body))
    @proposal.updated_at = DateTime.new
    @proposal.created_at = DateTime.new
    @proposal.submittes_at = DateTime.new
    @proposal.status = 0
    @proposal.user = current_user
    if @proposal.save
      redirect_to proposals_path, notice: "Article was successfully created."
    else
      flash.now[:error] = "Article creation failed"
      redirect_to new_proposal_path
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
    @proposal = Proposal.find(params[:id])
    if @proposal.update(params.require(:proposal).permit(:message))
      @proposal.update(status: 1)
      flash[:success] = "Articolo rifiutato con successo"
      redirect_to proposals_path
    else
      flash.now[:error] = "Non è stato possbile rifiutare l'articolo"
    end

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
    article = [{:title => @proposal.title, 
            :img_url => @proposal.img_url,
            :body => @proposal.body,
            :author_id => @proposal.user_id,
            :published_at => DateTime.now,
            :created_at => @proposal.created_at,
            :updated_at =>@proposal.updated_at}]

    Article.create(article)
    @proposal.destroy
    redirect_to proposals_url, notice: "L'articolo è stato pubblicato" 
=begin
    respond_to do |format|
      format.html { redirect_to proposals_url, notice: "Proposal was successfully destroyed." }
      format.json { head :no_content }
    end
=end
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
