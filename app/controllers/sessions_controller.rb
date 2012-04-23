# coding: utf-8
class SessionsController < ApplicationController 
  
  #登录表单
  def new
    @account = Account.new
  end
  
  def create
    name = params[:account][:username]
    name = name.strip if name
    
    @account = Account.search(name)
    
    if @account.nil? || !@account.login?(params[:account][:password])      
      render :new
    else
      callback = params[:account][:callback] || account_url
      session[:iuser] = {
        :username => @account.username,
        :uuid => @account.uuid
      }
      redirect_to callback  
    end     
  end  
  
  def destroy
    session[:iuser] = nil
    callback = params[:callback] || :login
    redirect_to callback
  end
  
end
