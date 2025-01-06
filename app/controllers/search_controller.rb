class SearchController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def index
    @query = Post.ransack(params[:q])
    @posts = @query.result.page(params[:page])
  end
end
