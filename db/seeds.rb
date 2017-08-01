

GoogleBooks::Adapter.new.create_books_and_authors

term = gets.chomp
GoogleBooks::Adapter.new(term).create_books_and_authors
