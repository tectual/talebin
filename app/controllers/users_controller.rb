class UsersController < ApplicationController

  before_filter :authenticate_user!

  def home
    @suggestions = current_user.matches(9)
  end

  def show
    @user = User.find_by_hid params[:hid]
  end

  def update
    @user = current_user
    @user.name = params[:user][:name] || @user.name
    @user.goal = params[:user][:goal] || @user.goal
    @user.interests = params[:user][:interests] || @user.interests
    @user.subscribed = params[:user][:subscribed] || @user.subscribed
    @user.gender = case params[:user][:gender]
                   when 'true'
                     true
                   when 'false'
                     false
                   else
                     @user.gender
                   end
    @user.birthdate = JalaliDate.to_gregorian params[:user][:birthdate] unless params[:user][:birthdate].blank?
    @user.save
    render :json => true
  end

  def suggest
    render :json => current_user.matches(9) , :methods => [:avatar_medium]
  end

  def respond
    if(params[:value].to_i==1)
      current_user.approve User.find(params[:id])
      render :json => :accept
    elsif(params[:value].to_i==-1)
      current_user.block User.find(params[:id])
      render :json => :reject
    else
      render :json => false
    end
  end

  def invite
    current_user.invite User.find(params[:id])
    render :json => true
  end

  def point
    render :json => true
  end

  def list
    @users = User.order('updated_at DESC').paginate :page => params[:page]
  end

  def actas
    sign_in User.find params[:id]
    redirect_to home_path
  end

  def avatar
    current_user.avatar = params[:avatar]
    current_user.save
    render :json => { :avatar => current_user.avatar(:medium) }
  end

end
