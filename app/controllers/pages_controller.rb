class PagesController < ApplicationController
  require 'net/http'
  require 'json'

  def index
  end

  def keyword
    if params[:token]
      wow_get_next_page_url = ENV["api_get_next_page_keyword_url"] + "?token=#{params[:token]}"
      encoded_url = URI.encode(wow_get_next_page_url)
      uri = URI.parse(encoded_url)
      @places = JSON.parse(Net::HTTP.get(uri))            
    else
      wow_search_keyword_url = ENV["api_search_by_keyword_url"] + "?str=#{params[:str]}&opt=#{params[:opt]}"
      encoded_url = URI.encode(wow_search_keyword_url)
      uri = URI.parse(encoded_url)
      @places = JSON.parse(Net::HTTP.get(uri))      
    end      
  end

  def nearby
    if params[:token]
      wow_get_next_page_url = ENV["api_get_next_page_pid_url"] + "?token=#{params[:token]}"
      encoded_url = URI.encode(wow_get_next_page_url)
      uri = URI.parse(encoded_url)
      @places = JSON.parse(Net::HTTP.get(uri)) 
    else
      if params[:new_str].nil?
        wow_detail_url = ENV["api_get_detail_url"] + "?pid=#{params[:pid]}"
        encoded_url = URI.encode(wow_detail_url)
        uri = URI.parse(encoded_url)
        @place = JSON.parse(Net::HTTP.get(uri))   
        params[:new_str] = @place["name"]
      end      
      wow_search_pid_url = ENV["api_search_by_pid_url"] + "?pid=#{params[:pid]}&opt=#{params[:new_opt]}"
      encoded_url = URI.encode(wow_search_pid_url)
      uri = URI.parse(encoded_url)
      @places = JSON.parse(Net::HTTP.get(uri))      
    end
  end

  def detail
    wow_detail_url = ENV["api_get_detail_url"] + "?pid=#{params[:pid]}"
    encoded_url = URI.encode(wow_detail_url)
    uri = URI.parse(encoded_url)
    @place = JSON.parse(Net::HTTP.get(uri))      
  end

  def statistics
    get_statistics
  end

  private
  def get_statistics
    wow_api_statistics_url = ENV["api_get_statistics_url"]
    encoded_url = URI.encode(wow_api_statistics_url)
    uri = URI.parse(encoded_url)
    @statistics = JSON.parse(Net::HTTP.get(uri))    

    @statistics["keyword_count"].sort_by! { |k| -k["count"] }    
    @statistics["pid_count"].sort_by! { |k| -k["count"] }    
    @statistics["detail_count"].sort_by! { |k| -k["count"] }    
  end

end
