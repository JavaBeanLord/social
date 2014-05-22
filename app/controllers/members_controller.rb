class MembersController < ApplicationController
  
  def request_to_join
    # adds to a list of requests to be voted on
  end
  
  def create
    @group = Group.find(params[:id])
    @group.members.create(user_id: current_user.id)
    redirect_to :back
  end
  
  def destroy
    @group = Group.find(params[:id])
    @membership = Member.find(@group.membership(current_user))
    @membership.destroy!
    redirect_to :back
  end
end
