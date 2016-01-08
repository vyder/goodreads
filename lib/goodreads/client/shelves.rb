module Goodreads
  module Shelves

    # Get a user's shelves
    # Ref: https://www.goodreads.com/api/index#shelves.list
    def shelves(user_id, options = {})
      options.merge(user_id: user_id)
      data = request("/shelf/list.xml", options)

      data         = data["shelves"]
      user_shelves = data["user_shelf"]

      shelves = []
      unless user_shelves.nil? || user_shelves.empty?
        user_shelves.each do |shelf|
          shelves << Hashie::Mash.new(shelf)
        end
      end

      Hashie::Mash.new({
        start:   data["start"].to_i,
        end:     data["end"].to_i,
        total:   data["total"].to_i,
        shelves: shelves
      })
    end

    # Get books from a user's shelf
    def shelf(user_id, shelf_name, options={})
      options = options.merge(:shelf => shelf_name, :v =>2)
      data = request("/review/list/#{user_id}.xml", options)
      reviews = data['reviews']['review']

      books = []
      unless reviews.nil?
        # one-book results come back as a single hash
        reviews = [reviews] if !reviews.instance_of?(Array)
        books = reviews.map {|e| Hashie::Mash.new(e)}
      end

      Hashie::Mash.new({
        :start => data['reviews']['start'].to_i,
        :end => data['reviews']['end'].to_i,
        :total => data['reviews']['total'].to_i,
        :books => books
      })
    end

  end
end
