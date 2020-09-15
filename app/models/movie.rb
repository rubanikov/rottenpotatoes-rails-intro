class Movie < ActiveRecord::Base
  @@all_ratings
  def self.all_ratings
      @@all_ratings = ["G", "PG", "PG-13", "R"]
  end    
end
