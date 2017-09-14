require 'rest-client'
require 'json'

class Application

  def fetch_books

  end

  def run

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
      books = Adapter::GoogleBooks.new(term).fetch_books

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
