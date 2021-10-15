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
      redirect_to url_path(@url.short_url)
    end
  end

  def show
    @url = Url.find_by_short_url(params[:url])
    raise 'invalid URL' if @url.nil?
    # implement queries
    @daily_clicks = [
      ['1', 13],
      ['2', 2],
      ['3', 1],
      ['4', 7],
      ['5', 20],
      ['6', 18],
      ['7', 10],
      ['8', 20],
      ['9', 15],
      ['10', 5]
    ]
    @browsers_clicks = [
      ['IE', 13],
      ['Firefox', 22],
      ['Chrome', 17],
      ['Safari', 7]
    ]
    @platform_clicks = [
      ['Windows', 13],
      ['macOS', 22],
      ['Ubuntu', 17],
      ['Other', 7]
    ]
  rescue
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end

  def visit
    # params[:short_url]
    render plain: 'redirecting to url...'
  end

  private
    def url_params
      params.require(:url).permit(:original_url)
    end
end
