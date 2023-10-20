class ProposalsController < ApplicationController
  before_action :set_proposal, only: %i[ show edit update destroy ]

  # GET /proposals or /proposals.json
  def index
    if !user_signed_in?
      redirect_to articles_path
      return
    end
    if(current_user.has_role? :admin)
      @proposals = Proposal.where(status: 0)
    else #current_user.has_role? :user
      @rejected_proposals = Proposal.where(user: current_user, status: 1)
      @proposals = Proposal.where(user: current_user, status: 0)
    end
  end

  # GET /proposals/1 or /proposals/1.json
  def show
    @proposal = Proposal.find(params[:id])
    if can? :read, @proposal
      notification = Notification.where(proposal: @proposal, admin: current_user).first
      if !notification.nil? 
        notification.destroy 
      end
    else
      redirect_to articles_path
    end
  end

  # GET /proposals/new
  def new
    @proposal = Proposal.new
    if !can?(:create, Proposal)
      redirect_to articles_path
    end
  end

  # GET /proposals/1/edit
  def edit
  end

  # POST /proposals or /proposals.json
  def create
    if !can?(:create, Proposal)
      respond_to do |format|
        format.html { redirect_to articles_path, status: 401 }
      end
      return
    end
    @proposal = Proposal.new(params.require(:proposal).permit(:title, :img_url, :body))
    @proposal.updated_at = DateTime.new
    @proposal.created_at = DateTime.new
    @proposal.submittes_at = DateTime.new
    @proposal.status = 0
    @proposal.user = current_user
    if @proposal.save
      begin
        admin_list = User.with_role :admin
        admin_list.each do |user|
          note = Notification.new(proposal: @proposal, admin: user)
          note.save!
        end
      rescue
        respond_to do |format|
          format.html { render :template => '500', status: 500 }
        end
      else
        redirect_to proposals_path, notice: "La proposta è stata creata con successo"
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proposals/1 or /proposals/1.json
  def update
    if !can?(:update, Proposal)
      respond_to do |format|
        format.html { redirect_to articles_path, status: 401 }
      end
      return
    end
    @proposal = Proposal.find(params[:id])
    data = params.require(:proposal).permit(:publish,:message)
    if data[:publish]=="true"
      article = Article.new({:title => @proposal.title, 
              :img_url => @proposal.img_url,
              :body => @proposal.body,
              :author_id => @proposal.user_id,
              :published_at => DateTime.now,
              :created_at => @proposal.created_at,
              :updated_at =>@proposal.updated_at})

      if article.save
        @proposal.destroy
        redirect_to proposals_path, notice: "L'articolo è stato pubblicato"
      else
        redirect_to proposals_path, notice: "Impossibile pubblicare, forse esiste già un articolo con questo titolo"
      end
    else
      if @proposal.update(message: data[:message])
        @proposal.update(status: 1)
        delete_notifications
        redirect_to proposals_path, notice: "Articolo rifiutato"
      else
        flash.now[:error] = "Non è stato possbile rifiutare l'articolo"
      end
    end
  end


  # DELETE /proposals/1 or /proposals/1.json
  def destroy
    @proposal = Proposal.find(params[:id])
    respond_to do |format|
      if can? :delete, @proposal
        @proposal.destroy
        format.html { redirect_to proposals_path, notice: "Proposta eliminata" }
      else
        format.html { redirect_to articles_path, status: 401 }
      end
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proposal
      begin
        @proposal = Proposal.find(params[:id])
      rescue
        respond_to do |format|
          format.html { render :template => '404', status: 404}
        end
      end
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
