class PagesController < ApplicationController
  require 'net/http'
  require 'json'

  def index
    
    if params[:token]
      wow_get_next_page_url = ENV["api_get_next_page_url"] + "?token=#{params[:token]}"
      encoded_url = URI.encode(wow_get_next_page_url)
      uri = URI.parse(encoded_url)
      @places = JSON.parse(Net::HTTP.get(uri))      
      @auto_complete_str = params[:auto_complete_str]
      @auto_complete_lat = params[:auto_complete_lat]
      @auto_complete_lng = params[:auto_complete_lng]  
      get_api_count      
    elsif params[:str]
      wow_search_keyword_url = ENV["api_search_by_keyword_url"] + "?str=#{params[:str]}&opt=#{params[:opt]}"
      encoded_url = URI.encode(wow_search_keyword_url)
      uri = URI.parse(encoded_url)
      @places = JSON.parse(Net::HTTP.get(uri))      
      @auto_complete_str = @places["auto_complete_str"]
      @auto_complete_lat = @places["auto_complete_lat"] 
      @auto_complete_lng = @places["auto_complete_lng"] 
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
    if params[:token]
      wow_get_next_page_url = ENV["api_get_next_page_url"] + "?token=#{params[:token]}"
      encoded_url = URI.encode(wow_get_next_page_url)
      uri = URI.parse(encoded_url)
      @places = JSON.parse(Net::HTTP.get(uri))      
      @auto_complete_str = params[:auto_complete_str]
      @auto_complete_lat = params[:auto_complete_lat]
      @auto_complete_lng = params[:auto_complete_lng]  
      @pid = params[:pid]
      @str = params[:str]
      @opt = params[:opt]
      @redirect = params[:redirect]       
      get_api_count   
    else
      wow_search_pid_url = ENV["api_search_by_pid_url"] + "?pid=#{params[:pid]}&opt=#{params[:opt]}"
      encoded_url = URI.encode(wow_search_pid_url)
      uri = URI.parse(encoded_url)
      @places = JSON.parse(Net::HTTP.get(uri))      
      @auto_complete_str = params[:str]
      @auto_complete_lat = @places["auto_complete_lat"] 
      @auto_complete_lng = @places["auto_complete_lng"]       
      @pid = params[:pid]
      @str = params[:ori_str]
      @opt = params[:ori_opt]
      @redirect = params[:redirect]    
      get_api_count
    end
  end

  private
  def get_api_count
    wow_api_count_url = ENV["api_get_api_count_url"]
    encoded_url = URI.encode(wow_api_count_url)
    uri = URI.parse(encoded_url)
    @api_count = JSON.parse(Net::HTTP.get(uri))    
  end
 
end
