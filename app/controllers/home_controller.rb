class HomeController < ApplicationController
  """
  Fetches a random story from my favourite superhero Iron Man using the Marvel API and displays it on the home page.
  """
  @@MARVEL_PRIVATE_KEY = ENV['MARVEL_PRIVATE_KEY']
  @@MARVEL_PUBLIC_KEY = ENV['MARVEL_PUBLIC_KEY']
  @@SUPERHERO = "iron%20man"
  @@BASE_ENDPOINT = "https://gateway.marvel.com"

  @@ts = Time.now.to_i.to_s
  @@url_hash = Digest::MD5.hexdigest("#{ts}#{MARVEL_PRIVATE_KEY}#{MARVEL_PUBLIC_KEY}"

  def get_marvel_character_story
    @url_character = BASE_ENDPOINT+"/v1/public/characters?name=#{SUPERHERO}&ts=#{ts}&apikey=#{MARVEL_PUBLIC_KEY}&hash=#{url_hash}"
    @response = HTTParty.get(url_character)
    @character_id = response["data"]["results"][0]["id"]

    @url_stories = BASE_ENDPOINT+"/v1/public/characters/#{character_id}/stories?limit=100&ts=#{ts}&apikey=#{MARVEL_PUBLIC_KEY}&hash=#{url_hash}"
    @response = HTTParty.get(url_stories)

    @random_number = rand(0..response["data"]["results"].length-1)
    @random_story = response["data"]["results"][random_number]

    @story_title = random_story["title"]
    @story_description = random_story["description"]
    @story_thumbnail = random_story["thumbnail"]["path"] + "." + random_story["thumbnail"]["extension"]

    @story_characters = []
    for character in random_story["characters"]["items"]
      @story_characters << character["name"]
    end

    @character_images = []
    for character in story_characters
      @character_image = BASE_ENDPOINT+"/v1/public/characters?name=#{character}&ts=#{ts}&apikey=#{MARVEL_PUBLIC_KEY}&hash=#{url_hash}"
      @character_images << character_image["thumbnail"]["path"] + "." + character_image["thumbnail"]["extension"]
    end

    @attribution_text = random_story["attributionText"]

    @story = {
      "title" => @story_title,
      "description" => @story_description,
      "thumbnail" => @story_thumbnail,
      "characters" => @story_characters,
      "character_images" => @character_images,
      "attributionText" => @attribution_text
    }

    return story
  end

  def index
    @story = get_marvel_character_story()
  end

  end
end
