class PagesController < ApplicationController

  def index
    #search_tripadvisor("Taipei")
    if params[:search_string]
      # @location = Location.new
      # @location.address = params[:search_string]
      # coordinates = Geocoder.coordinates(params[:search_string])
      # @location.latitude = coordinates[0]
      # @location.longitude = coordinates[1]

      #https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&types=food&name=cruise&key=YOUR_API_KEY
      #https://maps.googleapis.com/maps/api/place/textsearch/json?query=restaurants+in+Sydney&key=YOUR_API_KEY
      #https://maps.googleapis.com/maps/api/place/radarsearch/json?location=51.503186,-0.126446&radius=5000&types=museum&key=YOUR_API_KEY
      
      require 'net/http'
      require 'json'

      # Use Text Search
        google_place_url = "https://maps.googleapis.com/maps/api/place/"
        search_method = "textsearch/json?language=zh-TW&"
        query_string = "query=景點+in+#{params[:search_string]}"
        api_key = "&key=#{ENV["google_api_key"]}"
        url = google_place_url + search_method + query_string + api_key
        encoded_url = URI.encode(url)
        uri = URI.parse(encoded_url)
        @response = JSON.parse(Net::HTTP.get(uri))["results"]


    end    
    
  end

  def gen_json
      require 'net/http'
      require 'json'

      # Use Text Search
        google_place_url = "https://maps.googleapis.com/maps/api/place/"
        search_method = "textsearch/json?language=zh-TW&"
        query_string = "query=景點+in+#{params[:search_string]}"
        api_key = "&key=#{ENV["google_api_key"]}"
        url = google_place_url + search_method + query_string + api_key
        encoded_url = URI.encode(url)
        uri = URI.parse(encoded_url)
        @response = JSON.parse(Net::HTTP.get(uri))["results"]    
        @response_json = Array.new

        @response.each_with_index do |r, i|
          if r["photos"]
            tmp = Hash.new
            tmp["name"] = r["name"]
            tmp["address"] = r["address"]
            tmp["lat"] = r["geometry"]["location"]["lat"]
            tmp["lng"] = r["geometry"]["location"]["lng"]
            tmp["photo_url"] =  "https://maps.googleapis.com/maps/api/place/photo?maxwidth=#{r["photos"][0]["width"]}&photoreference=" + r["photos"][0]["photo_reference"] + "&key=#{ENV["google_api_key"]}"
            tmp["photo_width"] = r["photos"][0]["width"]
            tmp["photo_height"] = r["photos"][0]["height"]       
            tmp["place_id"] = r["place_id"]
            tmp["rating"] = r["rating"]
            @response_json << tmp
          end
        end

        render json: @response_json
  end


  private
  def search_tripadvisor(query_string)
    require 'open-uri'
    binding.pry
    link = "https://www.tripadvisor.com.tw/Attractions-g293913-Activities-Taipei.html"
    doc = Nokogiri::HTML(open(link))  

  end


end
