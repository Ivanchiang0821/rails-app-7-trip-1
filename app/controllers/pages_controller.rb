class PagesController < ApplicationController

  def index
    
    if params[:search_string]
      # 1. match the autocomplete location
      @place = auto_complete_by_keyword(params[:search_string])

      if @place["types"].include?("geocode")
        # 2. Get geocoding
        @coordinate = get_geocode_by_place_id(@place["place_id"])
        # 3. Use the coordinate to for google place nearbysearch api
        @response = nearby_search_by_coordinate(@coordinate["lat"], @coordinate["lng"], params[:search_option]).sort_by {|r| r["rating"].to_s}.reverse
      else
        redirect_to detail_path(place_id: @place["place_id"], 
                                search_string: params[:search_string] ? params[:search_string] : "",
                                search_option: params[:search_option] ? params[:search_option] : "", 
                                redirect: false)
      end

    end    
    
  end

  def detail
    @place = get_place_detail(params[:place_id])
  end

  def near_by
    # 2. Get geocoding
    @coordinate =  get_geocode_by_place_id(params["place_id"])

    # 3. Use the coordinate to for google place nearbysearch api
    google_nearbysearch_url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?language=zh-TW&"
    keyword = params[:search_option] == "景點" ? "景點" : params[:search_option] == "餐廳" ? "餐廳|美食|小吃" : "便利商店|超市|百貨公司"
    query_string = "location=#{@coordinate["lat"]},#{@coordinate["lng"]}&rankby=distance&keyword=#{keyword}"   

    api_key = "&key=#{ENV["google_api_key"]}"
    url = google_nearbysearch_url + query_string + api_key
    encoded_url = URI.encode(url)
    uri = URI.parse(encoded_url)
    @response = JSON.parse(Net::HTTP.get(uri))["results"]

  end

  def near_by_detail
    @place = get_place_detail(params[:place_id])
  end

  def search_by_keyword_json
    require 'net/http'
    require 'json'

    @place = auto_complete_by_keyword(params[:search_string])
    @coordinate = get_geocode_by_place_id(@place["place_id"])
    @response = nearby_search_by_coordinate(@coordinate["lat"], @coordinate["lng"], params[:search_option])
    @response_json = Array.new

    @response.each_with_index do |r, i|
      tmp = Hash.new
      tmp["name"] = r["name"]
      tmp["address"] = r["vicinity"]
      tmp["lat"] = r["geometry"]["location"]["lat"]
      tmp["lng"] = r["geometry"]["location"]["lng"]
      if r["photos"]
        tmp["photo_url"] =  "https://maps.googleapis.com/maps/api/place/photo?maxwidth=#{r["photos"][0]["width"]}&photoreference=" + r["photos"][0]["photo_reference"] + "&key=#{ENV["google_api_key"]}"
        tmp["photo_width"] = r["photos"][0]["width"]
        tmp["photo_height"] = r["photos"][0]["height"]       
      end
      tmp["place_id"] = r["place_id"]
      tmp["rating"] = r["rating"]
      tmp["types"] = r["types"]
      @response_json << tmp
    end

    render json: @response_json
  end

  def search_by_place_id_json
    require 'net/http'
    require 'json'

    @coordinate = get_geocode_by_place_id(params["place_id"])
    @response = nearby_search_by_coordinate(@coordinate["lat"], @coordinate["lng"], params[:search_option])
    @response_json = Array.new

    @response.each_with_index do |r, i|
      tmp = Hash.new
      tmp["name"] = r["name"]
      tmp["address"] = r["vicinity"]
      tmp["lat"] = r["geometry"]["location"]["lat"]
      tmp["lng"] = r["geometry"]["location"]["lng"]
      if r["photos"]
        tmp["photo_url"] =  "https://maps.googleapis.com/maps/api/place/photo?maxwidth=#{r["photos"][0]["width"]}&photoreference=" + r["photos"][0]["photo_reference"] + "&key=#{ENV["google_api_key"]}"
        tmp["photo_width"] = r["photos"][0]["width"]
        tmp["photo_height"] = r["photos"][0]["height"]       
      end
      tmp["place_id"] = r["place_id"]
      tmp["rating"] = r["rating"]
      tmp["types"] = r["types"]
      @response_json << tmp
    end

    render json: @response_json        
  end

  def get_place_id_json
    require 'net/http'
    require 'json'

    @place = auto_complete_by_keyword(params[:search_string])    
    @place_json = Hash.new
    @place_json["place_id"] = @place["place_id"]
    render json: @place_json    
  end

  def get_detail_json
    require 'net/http'
    require 'json'

    @place = get_place_detail(params[:place_id])    
    @place_json = Hash.new

    @place_json["name"] = @place["name"]
    @place_json["address"] = @place["formatted_address"] if @place["formatted_address"]
    @place_json["phone"] = @place["formatted_phone_number"] if @place["formatted_phone_number"]
    @place_json["website"] = @place["website"] if @place["website"]        
    @place_json["rating"] = @place["rating"] if @place["rating"]
    @place_json["types"] = @place["types"]    
    @place_json["place_id"] = @place["place_id"]
    @place_json["lat"] = @place["geometry"]["location"]["lat"]
    @place_json["lng"] = @place["geometry"]["location"]["lng"]
    @place_json["open_now"] = @place["opening_hours"]["open_now"]
    @place_json["opening_hours"] = @place["opening_hours"]["weekday_text"]
    @place_json["user_ratings_total"] = @place["user_ratings_total"]
    @place_json["google_map_url"] = @place["url"]

    @place_json["photos"] = Array.new
    @place["photos"].each_with_index do |p, i|
      tmp = Hash.new
      tmp["width"]  = p["width"]      
      tmp["height"] = p["height"]      
      tmp["url"] = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=#{p["width"]}&photoreference=" + p["photo_reference"] + "&key=#{ENV["google_api_key"]}"
      @place_json["photos"] << tmp
    end

    @place_json["reviews"] = Array.new
    @place["reviews"].each_with_index do |r, i|
      tmp = Hash.new
      tmp["profile_photo_url"]  = r["profile_photo_url"] ? "https:" + r["profile_photo_url"].to_s : nil
      tmp["rating"] = r["rating"]      
      tmp["text"] = r["text"]      
      @place_json["reviews"] << tmp
    end

    render json: @place_json    
  end

  private
  def auto_complete_by_keyword(keyword)
    google_autocomplete_url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?language=zh-TW&"
    query_string = "input=#{keyword}"
    api_key = "&key=#{ENV["google_api_key"]}"
    url = google_autocomplete_url + query_string + api_key
    encoded_url = URI.encode(url)
    uri = URI.parse(encoded_url)
    JSON.parse(Net::HTTP.get(uri))["predictions"].first    
  end

  def get_geocode_by_place_id(place_id)
    google_geocode_url = "https://maps.googleapis.com/maps/api/geocode/json?"
    query_string = "place_id=#{place_id}"
    api_key = "&key=#{ENV["google_api_key"]}"
    url = google_geocode_url + query_string + api_key
    encoded_url = URI.encode(url)
    uri = URI.parse(encoded_url)
    JSON.parse(Net::HTTP.get(uri))["results"].first["geometry"]["location"]    
  end

  def nearby_search_by_coordinate(lat, lng, option)
    google_nearbysearch_url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?language=zh-TW&"
    keyword = option == "景點" ? "景點" : option == "餐廳" ? "餐廳|美食|小吃" : "便利商店|超市|百貨公司"
    query_string = "location=#{lat},#{lng}&rankby=distance&keyword=#{keyword}"      
    api_key = "&key=#{ENV["google_api_key"]}"
    url = google_nearbysearch_url + query_string + api_key
    encoded_url = URI.encode(url)
    uri = URI.parse(encoded_url)
    JSON.parse(Net::HTTP.get(uri))["results"]
  end

  def get_place_detail(place_id)
    google_detail_url = "https://maps.googleapis.com/maps/api/place/details/json?language=zh-TW&"
    query_string = "placeid=#{place_id}"
    api_key = "&key=#{ENV["google_api_key"]}"
    url = google_detail_url + query_string + api_key
    encoded_url = URI.encode(url)
    uri = URI.parse(encoded_url)
    @place = JSON.parse(Net::HTTP.get(uri))["result"]    
  end
end
