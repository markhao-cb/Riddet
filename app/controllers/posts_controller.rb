class PostsController < ApplicationController
  before_action :check_logged_in, except: :show

  def show
    @post = Post.find(params[:id])
    render :show
  end

  def new
    @post = Post.new
    render :new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    render :edit
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def destroy
  end

  private

  def check_author
    unless logged_in?
      redirect_to new_session_url
      return
    end
    @post = Post.find(params[:id])
    redirect_to subs_url unless current_user.id == @post.author_id
  end

  def post_params
    params.require(:post).permit(:title, :content, :url, sub_ids:[])
  end
end
