module GoogleBooks

  class Adapter
    attr_reader :term

    BASE_URL = "https://www.googlebooksapi.com/v2/volumes"

    def initialize(term = 'ruby programming')
      @term = term
    end

    def create_books_and_authors

      # make a request to the API
      response = RestClient.get("#{BASE_URL}?q=#{self.term}")
      data = JSON.parse(response.body)
      #iterate over all the books in that response
      data['items'].each do |book_data|
        book = Book.new(title: book_data['volumeInfo']['title'], description: book_data['volumeInfo']['description'])
        if  book_data['volumeInfo']['authors']
          author_name =  book_data['volumeInfo']['authors'].first
          author = Author.find_or_create_by(name: author_name)
        end

        book.author = author
        book.save

      end

      # create and save the book objects and associated authors
    end

  end


end
