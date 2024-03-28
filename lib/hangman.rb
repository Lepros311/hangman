require 'yaml'

def get_word
  dictionary = File.read('google-10000-english-no-swears.txt')
  dictionary_array = dictionary.split
  usable_dictionary = dictionary_array.select do |word|
    (word.length >= 5) && (word.length <= 12)
  end
  usable_dictionary.sample
end

class Game

  attr_reader :word
  attr_accessor :guessed_letter, :guessed_letters, :incorrect_letters, :guess_number, :guessed_word

  def initialize(word)
    @word = word
    puts "Hi! What's your name?"
    @player = Player.new(gets.chomp)
    @board = Board.new(@word)
    @guessed_letter = ''
    @guessed_letters = []
    @incorrect_letters = []
    @wrong_guess_number = 0
    @guess_choice = 0
    @guessed_word
    @save_choice = ''
  end

  def choose_previous_or_new
    puts "\n#{@player.name}, do you want to load a previous game or start a new game?"
    start_choice = 0
    loop do
      puts "Enter 1 to load previous game or 2 to start a new game."
      start_choice = gets.chomp.to_i
      break if [1, 2].include?(start_choice)
      puts "Invalid option. Enter 1 or 2."
      puts "\n"
    end
    if start_choice == 1
      load_game
      @board.display
      player_turn
    else
      new_game
    end
  end

  def new_game
    puts "\nWelcome, #{@player.name}."
    puts "Your word has a total of #{@word.length} letters."
    puts @word
    @board.display
    player_turn
  end

  def save_game
    print "Save as: "
    save_name = gets.chomp
    File.new("#{save_name}.txt", 'w')
    File.write("#{save_name}.txt", YAML.dump(self))
    puts "Game saved."
  end

  def load_game
    print "Game name: "
    game_name = gets.chomp
    yaml_content = File.read("#{game_name}.txt")
    loaded_game = YAML.safe_load(yaml_content, permitted_classes: [Game, Player, Board])
    @word = loaded_game.word
    @player = loaded_game.instance_variable_get(:@player)
    @board = loaded_game.instance_variable_get(:@board)
    @guessed_letter = loaded_game.guessed_letter
    @guessed_letters = loaded_game.guessed_letters
    @incorrect_letters = loaded_game.incorrect_letters
    @wrong_guess_number = loaded_game.instance_variable_get(:@wrong_guess_number)
    @guess_choice = loaded_game.instance_variable_get(:@guess_choice)
    @guessed_word = loaded_game.guessed_word
    @save_choice = loaded_game.instance_variable_get(:@save_choice)
  end

  def player_turn
    loop do
      loop do
        print "Save game? (y/n): "
        @save_choice = gets.chomp
        break if ["yes", "y", "no", "n"].include?(@save_choice)
        puts "Invalid option."
      end
      if ["yes", "y"].include?(@save_choice)
        save_game
      end
      loop do
        puts "\nEnter 1 to guess a letter. Enter 2 to guess the word."
        @guess_choice = gets.chomp.to_i
        break if [1, 2].include?(@guess_choice)
        puts "Invalid option. Enter 1 or 2."
      end
      if @guess_choice == 1
        loop do
          print "\nGuess a letter: "
          @guessed_letter = gets.chomp.downcase
          break if @guessed_letter.match?(/[a-z]/)
          puts "Invalid option. Valid options are any letter a - z."
        end
          @guessed_letters.push(@guessed_letter)
          check_letter(@guessed_letter)
          @board.display
        else
          print "\nGuess the word: "
          @guessed_word = gets.chomp.downcase
          check_word(@guessed_word)
          @board.display
      end
      puts "\nIncorrect letters: #{incorrect_letters}"
      puts "\nIncorrect guesses made: #{@wrong_guess_number} (loss = 7)"
      if @incorrect_letters.length >= 7 || @wrong_guess_number >= 7
        puts "\nSorry, #{@player.name}. You lose!"
        break
      elsif @board.layout == @word.split('')
        puts "\nCongratulations, #{@player.name}! You win!"
        break
      end
    end
  end

  def check_word(guessed_word)
    if @word == guessed_word
      @board.layout = @word.split('')
    else
      @wrong_guess_number += 1
    end
  end

  def check_letter(guessed_letter)
    if @word.split('').include?(guessed_letter)
      @word.split('').each_with_index do |word_letter, index|
        if guessed_letter == word_letter
          @board.layout[index] = guessed_letter
        end
      end
    else
      @wrong_guess_number += 1
      @incorrect_letters.push(guessed_letter)
    end
  end

end

class Player
  attr_reader :name

  def initialize(name)
    @name = name
  end

end

class Board
  attr_accessor :layout

  def initialize(word)
    @layout = Array.new(word.length, "_")
  end

  def display
    puts "\n"
    puts @layout.join(' ')
  end

end

game = Game.new(get_word)
game.choose_previous_or_new
