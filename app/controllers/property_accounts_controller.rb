class PropertyAccountsController < ApplicationController

  layout 'property'
  before_filter :has_permission, :only=>[:destroy]
  # GET /property_accounts
  # GET /property_accounts.xml
  def index
    if user_is_admin?
      @property_accounts = PropertyAccount.find(:all)
    else
      @property_accounts = PropertyAccount.find_all_by_user_id(session[:current_user_id])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @property_accounts }
    end
  end

  # GET /property_accounts/1
  # GET /property_accounts/1.xml
  def show
    @property_account = PropertyAccount.find(params[:id])
    session[:current_property_id] = @property_account.id
    unless user_is_admin? || user_is_owner?(@property_account.user_id)
      session[:current_property_id] = nil
      flash[:error] = "The page you requested is for administrator only. Please sign in as administrator to continue."
      redirect_to :controller=>"users",:action=>"sign_in"
      return false
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @property_account }
    end
  end

  # GET /property_accounts/new
  # GET /property_accounts/new.xml
  def new
    @property_account = PropertyAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @property_account }
    end
  end

  # GET /property_accounts/1/edit
  def edit
    @property_account = PropertyAccount.find(params[:id])
    unless user_is_admin? || user_is_owner?(@property_account.user_id)
      flash[:error] = "The page you requested is for administrator only. Please sign in as administrator to continue."
      redirect_to :controller=>"users",:action=>"sign_in"
      return false
    end
  end

  # POST /property_accounts
  # POST /property_accounts.xml
  def create
    @property_account = PropertyAccount.new(params[:property_account])
    
    respond_to do |format|
      @property_account.user_id = session[:current_user_id]
      if @property_account.save
        flash[:notice] = "Property Account created!"
        format.html { redirect_to(@property_account, :notice => 'Property account was successfully created.') }
        format.xml  { render :xml => @property_account, :status => :created, :location => @property_account }
      else
        flash[:error] = "Create property account failed!"
        format.html { render :action => "new" }
        format.xml  { render :xml => @property_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /property_accounts/1
  # PUT /property_accounts/1.xml
  def update
    
    @property_account = PropertyAccount.find(params[:id])
    unless user_is_admin? || user_is_owner?(@property_account.user_id)
      flash[:error] = "The page you requested is for administrator only. Please sign in as administrator to continue."
      redirect_to :controller=>"users",:action=>"sign_in"
      return false
    end
    respond_to do |format|
      if @property_account.update_attributes(params[:property_account])
        format.html { redirect_to(@property_account, :notice => 'PropertyAccount was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @property_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /property_accounts/1
  # DELETE /property_accounts/1.xml
  def destroy
    @property_account = PropertyAccount.find(params[:id])
    @property_account.destroy

    respond_to do |format|
      format.html { redirect_to(property_accounts_url) }
      format.xml  { head :ok }
    end
  end
  
end