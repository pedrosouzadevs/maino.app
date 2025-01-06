class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_query
  before_action :set_locale

  def set_query
    @query = Post.ransack(params[:q])
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

end
