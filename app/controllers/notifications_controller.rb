# may need to add integer for post id's or user id's as well as a string for action type
# a clear all button to delete all notifications

class NotificationsController < ApplicationController
  def index
    if current_user then
      @notes = current_user.notifications.reverse
      @notes.each do |note|
        note.checked = true
        note.save
      end
    end
  end
  
  def clear
    @notes = current_user.notifications
    @notes.each do |note|
      note.destroy!
    end
    redirect_to user_notifications_path(current_user)
  end
end
