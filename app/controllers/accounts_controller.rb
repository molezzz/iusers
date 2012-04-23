class AccountsController < ApplicationController
  #load_and_authorize_resource
  
  def show
    @account = current_user
    authorize! :read, @account
    
    respond_with(@account)
  end
    
end
