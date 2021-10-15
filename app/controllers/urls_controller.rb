# frozen_string_literal: true

class UrlsController < ApplicationController
  def index
    # recent 10 short urls
    @url = Url.new
    @urls = Url.order(updated_at: :desc).limit(10)
  end

  def create
    @url = Url.new(url_params)
    if @url.save
      flash[:success] = 'Url was successfully created.'
      redirect_to url_path(@url.short_url)
    else
      flash[:error] = 'Url cant be created.'
      redirect_to root_path
    end
  end

  def show
    @url = Url.find_by_short_url(params[:url])
    raise 'invalid URL' if @url.nil?
    @daily_clicks = @url.daily_clicks
    @browsers_clicks = @url.browsers_clicks
    @platform_clicks = @url.platform_clicks
  rescue
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end

  def visit
    @url = Url.find_by_short_url(params[:short_url])
    @url.generate_click_info(request)

    return redirect_to @url.original_url, status: 301
  rescue
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end

  private
    def url_params
      params.require(:url).permit(:original_url)
    end
end
