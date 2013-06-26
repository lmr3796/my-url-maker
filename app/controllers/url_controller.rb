require 'uri'
require 'selenium-webdriver'
class UrlController < ApplicationController
  def gen
    if params[:url] =~ URI::regexp
      # Generate a unique ID
      begin
        @url_id = SecureRandom.urlsafe_base64(4)
      end while(UrlMapping.exists?(:url_id => @url_id))

      # Generate screenshot
      begin
        driver = Selenium::WebDriver.for :firefox
        driver.get params[:url]
        driver.save_screenshot "./public/screenshots/#{@url_id}.png"
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect
      ensure
        driver.quit
      end

      # Write to DB
      p = UrlMapping.new
      p.url = params[:url]
      p.url_id = @url_id
      p.save
      @url = "http://#{request.host_with_port}/#{@url_id}"

    else
      respond_to do |format|
        format.html { redirect_to root_url, alert: "Bad URI submitted" }
        format.xml  { head :forbidden }
        format.json { head :forbidden }
      end
    end
  end
  def my_redirect
    p = UrlMapping.where(:url_id => "#{params[:url]}")[0]
    @url = p.url
    redirect_to @url
  end
end
