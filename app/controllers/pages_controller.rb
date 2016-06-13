class PagesController < ApplicationController
  require 'net/http'
  require 'json'

  def index
    
    if params[:str]
      wow_search_keyword_url = ENV["api_search_by_keyword_url"] + "?str=#{params[:str]}&opt=#{params[:opt]}"
      encoded_url = URI.encode(wow_search_keyword_url)
      uri = URI.parse(encoded_url)
      @places = JSON.parse(Net::HTTP.get(uri))      
      get_api_count
    else  
      get_api_count
    end  
    
  end

  def detail
    wow_detail_url = ENV["api_get_detail_url"] + "?pid=#{params[:pid]}"
    encoded_url = URI.encode(wow_detail_url)
    uri = URI.parse(encoded_url)
    @place = JSON.parse(Net::HTTP.get(uri))      
    get_api_count
  end

  def near_by
    wow_search_pid_url = ENV["api_search_by_pid_url"] + "?pid=#{params[:pid]}&opt=#{params[:opt]}"
    encoded_url = URI.encode(wow_search_pid_url)
    uri = URI.parse(encoded_url)
    @places = JSON.parse(Net::HTTP.get(uri))      
    get_api_count
  end

  private
  def get_api_count
    wow_api_count_url = ENV["api_get_api_count_url"]
    encoded_url = URI.encode(wow_api_count_url)
    uri = URI.parse(encoded_url)
    @api_count = JSON.parse(Net::HTTP.get(uri))    
  end
 
end
