require 'sidekiq'
class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[ new create update destroy]
  before_action :verify_user, only: [:show]
  include Sidekiq::Job

  def index
    @posts = Post.order(updated_at: :desc).page(params[:page])
  end

  def show
    if @delete_notification
      Notification.where(post_id: @post.id, user_id: current_user.id).destroy_all
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post), notice: t('flash.notice.post_create')
    else
      redirect_to posts_path, status: :unprocessable_entity
    end
  end

  def create_txt
    if params[:txt_files].nil?
      redirect_to posts_path, status: :unprocessable_entity
    else
      params[:txt_files].each do |file|
        file_content = file.read
        lines = file_content.split("\n")
        title = lines.first.strip
        content = lines[1..].join("\n").strip
        UploadJob.perform_async(title, content, current_user.id)
      end
      @times = params[:txt_files].size
      if @times == 1
        redirect_to posts_path, notice: (t('Completed_job'))
      else
        redirect_to posts_path, notice: (t('Completed_jobs', times: @times))
      end
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: t('flash.notice.post_update')
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: t('flash.notice.post_destroy')
  end

  private

  def set_post
    @post = Post.find(params[:id])
    @comments = @post.comments
  end

  def verify_user
    if current_user && current_user.id == Post.find(params[:id]).user_id
      @delete_notification = true
    else
      @delete_notification = false
    end
  end

  def post_params
    params.require(:post).permit(:content, :title)
  end
end
