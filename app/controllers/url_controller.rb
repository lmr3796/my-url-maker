require 'uri'
class UrlController < ApplicationController
  def gen
    if params[:url] =~ URI::regexp
      # Generate a unique ID
      begin
        url_id = SecureRandom.urlsafe_base64(4)
      end while(UrlMapping.exists?(:url_id => url_id))
      # Write to DB
      p = UrlMapping.new
      p.url = params[:url]
      p.url_id = url_id
      p.save

      #@url = gen_url(params[:url])
      @url = url_id
      render :text => "Jizz: #{@url}"
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
