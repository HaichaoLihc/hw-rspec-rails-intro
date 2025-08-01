class Movie < ActiveRecord::Base
  def self.all_ratings
    %w[G PG PG-13 R]
  end

  def self.with_ratings(ratings, sort_by)
    if ratings.nil?
      all.order sort_by
    else
      where(rating: ratings.map(&:upcase)).order sort_by
    end
  end

  def self.find_in_tmdb(params)
    api_key = '67460796532cfa04b2e01a8200e62287'
    base_url = "https://api.themoviedb.org/3/search/movie"
    query = {
      api_key: api_key,
      query: params[:title]
    }
    query[:year] = params[:release_year] if params[:release_year].present?
    query[:language] = params[:language] if params[:language].present?

    url = "#{base_url}?#{URI.encode_www_form(query)}"
    if params
      response = Faraday.get(url)
    end
    data = JSON.parse(response.body)['results'] || []
    puts data
    data.map do |movie_data|
      Movie.new(
        title: movie_data["title"],
        rating: "R",
        description: movie_data["overview"],
        release_date: movie_data["release_date"]
      )
    end
  end
end
