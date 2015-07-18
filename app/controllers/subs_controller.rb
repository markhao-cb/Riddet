class SubsController < ApplicationController
  before_action :check_logged_in
  before_action :check_moderator, only: [:edit, :update]

  def index
    @subs = Sub.all
    render :index
  end

  def show
    @sub = Sub.find(params[:id])
    render :show
  end

  def new
    @sub = Sub.new
    render :new
  end

  def create
    @sub = current_user.subs.new(sub_params)
    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def edit
    @sub = Sub.find(params[:id])
    render :edit
  end

  def update
    @sub = Sub.find(params[:id])
    if @sub.update(sub_params)
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
  end

  private
  def check_moderator
    unless logged_in?
      redirect_to new_session_url
      return
    end
    @sub = Sub.find(params[:id])
    redirect_to subs_url unless current_user.id == @sub.moderator_id
  end

  def sub_params
    params.require(:sub).permit(:title, :description)
  end

end
