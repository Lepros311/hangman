def get_word
  dictionary = File.read('google-10000-english-no-swears.txt')
  dictionary_array = dictionary.split
  usable_dictionary = dictionary_array.select do |word|
    (word.length >= 5) && (word.length <= 12)
  end
  usable_dictionary.sample
end

class Game

  def initialize(word)
    @word = word
  end

  puts "Hi! What's your name?"
  player = Player.new(gets.chomp)

  board = Board.new

end

class Player

  def initialize(name)
    @name = name
  end

end

class Board

  def initialize
    @layout = "_ _ _ _ _"
  end

end

Game.new(get_word)
