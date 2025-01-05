class SearchController < ApplicationController
  def index
    @query = Post.ransack(params[:q])
    @posts = @query.result.page(params[:page])
  end
end
