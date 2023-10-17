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
    notification = Notification.where(proposal_id: @proposal.id,admin_id: current_user.id).first
    if !notification.nil? 
      notification.destroy 
    end
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
      admin_list = User.with_role :admin
      admin_list.each do |admin|
        note = Notification.new(admin_id: admin.id, proposal_id: @proposal.id)
        note.save
      end
      redirect_to proposals_path, notice: "La proposta è stata creata con successo"
    else
      flash.now[:error] = "La creazione della proposta è fallita."
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
    data = params.require(:proposal).permit(:publish,:message)
    if data[:publish]=="true"
      article = [{:title => @proposal.title, 
              :img_url => @proposal.img_url,
              :body => @proposal.body,
              :author_id => @proposal.user_id,
              :published_at => DateTime.now,
              :created_at => @proposal.created_at,
              :updated_at =>@proposal.updated_at}]

      Article.create(article)
      delete_notifications
      @proposal.destroy
      redirect_to proposals_path, notice: "L'articolo è stato pubblicato"
    else
      if @proposal.update(message: data[:message])
        @proposal.update(status: 1)
        delete_notifications
        redirect_to proposals_path, notice: "Articolo rifiutato con successo"
      else
        flash.now[:error] = "Non è stato possbile rifiutare l'articolo"
      end
    end
  end


  # DELETE /proposals/1 or /proposals/1.json
  def destroy
    @proposal = Proposal.find(params[:id])
    if can? :delete, @proposal
      
      delete_notifications

      @proposal.destroy
      respond_to do |format|
        format.html { redirect_to proposals_path, notice: "Proposta eliminata" }
        format.json { head :no_content }
      end
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

    # Delete all the notification of the proposal
    def delete_notifications
      notifications_list = Notification.where(proposal_id: @proposal.id)
      notifications_list.each do |note|
        note.destroy
      end
    end

end
