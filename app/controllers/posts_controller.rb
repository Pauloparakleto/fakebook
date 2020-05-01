# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :find_post, only: %i[edit update destroy]

  def index
    @posts = Post.includes(:user, :likes).all.order('created_at DESC')
  end

  def new
    @post = Post.new
  end

  def user_posts
    @user = User.friendly.find(params[:id])
    @posts = @user.posts.order('created_at DESC')
    render 'index'
  end

  def show
    @post = Post.includes(:comments).friendly.find(params[:id])
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = 'Your post has created successfully'
      redirect_to @post
    else
      flash[:danger] = 'Invalid post, Please try again!'
      render 'new'
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      flash[:success] = 'post was successfully updated.'
      redirect_to @post
    else
      flash[:danger] = 'Something went wrong, Please try again!'
      render :edit
    end
  end

  def destroy
    if @post.destroy
      flash[:success] = 'post was successfully deleted'
      redirect_to @post
    else
      flash[:danger] = 'Something went wrong, Please try again!'
      redirect_to :back
    end
  end

  private

  def find_post
    @post = current_user.posts.friendly.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:description, :image)
  end
end
