require 'httparty'
require 'json'

class HomeController < ApplicationController
  """
  Fetches a random story from my favourite superhero Iron Man using the Marvel API and displays it on the home page.
  """
  @@MARVEL_PRIVATE_KEY = ENV['MARVEL_PRIVATE_KEY']
  @@MARVEL_PUBLIC_KEY = ENV['MARVEL_PUBLIC_KEY']
  @@SUPERHERO = "iron%20man"
  @@BASE_ENDPOINT = "https://gateway.marvel.com"

  @@ts = Time.now.to_i.to_s
  @@url_hash = Digest::MD5.hexdigest("#{@@ts}#{@@MARVEL_PRIVATE_KEY}#{@@MARVEL_PUBLIC_KEY}")

  def index
    puts "Fetching random story from Marvel API..."
    @url_character = @@BASE_ENDPOINT+"/v1/public/characters?name=#{@@SUPERHERO}&ts=#{@@ts}&apikey=#{@@MARVEL_PUBLIC_KEY}&hash=#{@@url_hash}"
    @response = HTTParty.get(@url_character)

    case @response.code
    when 404
      @message = {"error" => "Character #{@@SUPERHERO} not found!"}
      render @message
    when 500...600
      @message = {"error" => "ERROR #{@response.code}"}
      render @message
    end

    @attribution_text = @response["attributionText"]
    @character_id = @response["data"]["results"][0]["id"]

    @url_stories = @@BASE_ENDPOINT+"/v1/public/characters/#{@character_id}/stories?limit=100&ts=#{@@ts}&apikey=#{@@MARVEL_PUBLIC_KEY}&hash=#{@@url_hash}"
    @response = HTTParty.get(@url_stories)

    case @response.code
    when 404
      @message = {"error" => "Stories not found for character #{@@SUPERHERO}!"}
      render @message
    when 500...600
      @message = {"error" => "ERROR #{@response.code}"}
      render @message
    end

    @random_number = rand(0..@response["data"]["results"].length-1)
    @random_story = @response["data"]["results"][@random_number]

    @story_title = @random_story["title"]
    @story_description = @random_story["description"]

    @story_characters = []
    for  @character in  @random_story["characters"]["items"]
      puts @character["name"]
      @story_characters << @character["name"]
    end

    @character_images = []
    for @character in @story_characters
      @character_detail = @@BASE_ENDPOINT+"/v1/public/characters?name=#{@character}&ts=#{@@ts}&apikey=#{@@MARVEL_PUBLIC_KEY}&hash=#{@@url_hash}"
      @response = HTTParty.get(@character_detail)

      case @response.code
      when 404
        @message = {"error" => "Character #{@character} not found!"}
        render @message
      when 500...600
        @message = {"error" => "ERROR #{@response.code}"}
        render @message
      end

      @character_images << @response["data"]["results"][0]["thumbnail"]["path"] + "/portrait_xlarge." + @response["data"]["results"][0]["thumbnail"]["extension"]
      puts @character_images
    end

    @story = {
      "title" => @story_title,
      "description" => @story_description,
      "characters" => @story_characters,
      "characterImages" => @character_images,
      "attributionText" => @attribution_text
    }

    render @story
  end
end
