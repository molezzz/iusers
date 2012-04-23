class ApplicationController < ActionController::Base
  respond_to :html, :xml, :json
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to login_url,:alert => exception.message}
      format.xml { render :xml => "...", :status => :forbidden }
    end
  end
  
  #for cancan
  def current_user
    if session.key?(:iuser) && (!session[:iuser].nil? && session[:iuser].key?(:uuid))
      @account = Account.where(:uuid => session[:iuser][:uuid]).first
    else
      @account = Account.new
    end
  end
end
