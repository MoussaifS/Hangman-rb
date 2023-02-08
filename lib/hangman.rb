def wordSelect
  word = File.readlines('google-10000-english-no-swears.txt')
  line_number = 0
  loop do
    line_number = rand(0..10_000)
    break if word[line_number].length.between?(5, 12)
  end
  word[line_number].strip.split('')
rescue StandardError => e
  puts "Error reading file: #{e}"
end

def save(word, player_array, chance)
  puts "enter 'y' save this game game"
  puts '**********************'

  return unless gets.chomp == 'y'

  puts 'enter the file name'

  Dir.mkdir('output') unless Dir.exist?('output')
  gamename = "output/#{gets.chomp}"

  File.open(gamename, 'w') do |file|
    file.puts "#{word.join('^')}\n#{player_array.join('^')}\n#{chance}"
  end
end

def load
  puts '#############'
  puts 'enter the file name to load'
  loadgame = gets.chomp
  puts '#############'

  File.readlines(loadgame)
rescue StandardError => e
  puts 'file is not avilable'
end

def game(word)
  chance = 5
  game_on = true
  player_array = Array.new(word.length, '_')
  word = word.strip.split('')

  puts "enter 'y' load previos game"
  puts '**********************'

  if gets.chomp == 'y'
    loaded = load
    word = loaded[0].chomp.split('^')
    player_array = loaded[1].chomp.split('^')
    chance = loaded[2].to_i
  end

  p word
  p player_array
  p chance
  while game_on
    save(word, player_array, chance)
    puts 'enter your guessing letter'
    letter = gets.chomp

    if word.include?(letter)
      index = word.index(letter)
      player_array[index] = letter
      word[index] = '*_*'
      p word
      p player_array

      if word.all?('*_*')
        puts 'you won'
        game_on = false
      end

    else

      puts 'worng letter'
      puts "you only have #{chance -= 1}"
      p player_array
      if chance < 0
        puts "You Lost \nThe Word Is: #{word}"
        game_on = false
      end

    end

  end
end
game('word')
