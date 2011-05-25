require 'json'

@correct = 0
@wrong = 0
input = nil
# Ask the user for the level
loop do
  puts "What level? (5 through 1)"
  input = gets
  input = input.strip.to_i
  break if (1..5).to_a.include?(input) # Must be a number between 1 through 5
end

begin
  japanese = JSON.parse File.read "levels/level_#{input}.json"
rescue Errno::ENOENT
  # If can't find / read the level file
  puts "I can't seem to find that level.  Try running scrapper.rb again"
  exit
end

puts "Type 'exit' to stop"
loop do
  word = japanese[rand(japanese.size)] # Pick a random vocab word
  hash = {1 => 'kanji', 2 => 'kana', 3 => 'english'} # Use for rand() 
  a = question = answer = nil # Variables needed outside of loop scope
  loop do
    q = rand(3)+1 #Kanji, Kana, or English
    question = word[hash[q]]
    a = rand(3)+1
    answer = word[hash[a]]
    # Pick again if: Either the question of the answer are empty, the question
    # is the same as the answer, or the question is kana and its looking for the
    # kanji (With a computer you can just type the kana and it will give you
    # the kanji)
    break unless question.empty? || answer.empty? || question == answer || (hash[q] == 'kana' && hash[a] == 'kanji')
  end
  puts "#{question}: What is the #{hash[a]}"
  g = gets # Grab the input
  if g.strip == 'exit' 
    break # Exit if they type exit
  elsif g.strip == answer
    puts "Got it!"
    @correct += 1
  else
    puts "Nope.  Its '#{answer}'" # Display right answer when they get it wrong
    @wrong += 1
  end
end

puts "You got #{@correct} correct and #{@wrong} wrong, for a percentache of #{((@correct.to_f/@wrong.to_f)*100).round(2)}%"
puts "Good Bye!"
