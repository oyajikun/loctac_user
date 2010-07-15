class UsersController < ApplicationController
#  before_filter :limit_of_number_of_members, :only => [:new, :create]
  before_filter :require_logout, :only => [:new, :create]
  before_filter :require_login, :except => [:new, :create]

  # GET /users/1
  def show
    @user = @current_user

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /users/new
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /users/1/edit
  def edit
    @user = @current_user
  end

  # POST /users
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = I18n.t("flash.user.create.success", :default => 'User was successfully created.')
        format.html { redirect_back_or_default user_url }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /users/1
  def update
    @user = @current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = I18n.t("flash.user.update.success", :default => 'User was successfully updated.')
        format.html { redirect_back_or_default user_url }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /users/1
  def destroy
    @user = @current_user
    @user.destroy


    respond_to do |format|
      format.html { redirect_to(new_user_url) }
    end
  end
end
