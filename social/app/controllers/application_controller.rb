class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user, :all_chats_for

  private
  
  # returns all chats created by user
  # and chats user is a member of
  def all_chats_for(the_user)
    chats = Array.new
    User.all.each do |user|
      if user.chat_with(the_user) and !chats.include?(user.chat_with(the_user))
        chats << user.chat_with(the_user)
      end
    end
    chats.sort_by(&:updated_at).reverse!
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
