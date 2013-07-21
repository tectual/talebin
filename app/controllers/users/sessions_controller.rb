class Users::SessionsController < Devise::SessionsController

  def new
    @inviter = User.find params[:uniq].split("l")[1] unless params[:uniq].blank?
    super
  end

  def create
    @inviter = User.find params[:uniq].split("l")[1] unless params[:uniq].blank?
    super
    unless @inviter.blank? || current_user.blank?
      @inviter.invite current_user
      current_user.approve @inviter
    end
  end

end
