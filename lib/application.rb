require 'rest-client'
require 'json'

class Application

  def run
    # make a request to the api to initially add books to the database
    response = RestClient.get("https://www.googleapis.com/books/v1/volumes?q=subject:fiction")
    data = JSON.parse(response.body)

    #iterate over all the books in that response
    data['items'].each do |book_data|
      book = Book.find_or_initialize_by(title: book_data['volumeInfo']['title'], description: book_data['volumeInfo']['description'])

      if  book_data['volumeInfo']['authors']
        author_name =  book_data['volumeInfo']['authors'].first
        author = Author.find_or_create_by(name: author_name)
      end

      # create and save the book objects and associated authors
      book.author = author

      book.save

    end


    puts "Welcome to the Library Searcher"
    puts "Here are some of the current books in our databse"
    render(Book.first(3))

    puts "\n\nPlease Enter a search term:"
    query = gets.chomp

    find_books(query)
  end


  def find_books(term)
    books = Book.where('title LIKE ?', "%#{term}%")

    if books.any?
      # are there any books that have that keyword currently in the db
      render(books)
    else
      # if there's not, make a request to api
      response = RestClient.get("https://www.googleapis.com/books/v1/volumes?q=#{term}")
      data = JSON.parse(response.body)

      #iterate over all the books in that response
      books = data['items'].map do |book_data|
        book = Book.find_or_initialize_by(title: book_data['volumeInfo']['title'], description: book_data['volumeInfo']['description'])

        if  book_data['volumeInfo']['authors']
          author_name =  book_data['volumeInfo']['authors'].first
          author = Author.find_or_create_by(name: author_name)
        end

        # create and save the book objects and associated authors
        book.author = author

        book.save

        book
      end

      render(books)
    end
  end


  def render(books)
    books.each do |book|
      puts '*' * 30
      puts "Title: #{book.title} by #{book.author.name}"
      puts "Description: #{book.description[0...30] if book.description}"
    end
  end

end
