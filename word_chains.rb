class WordChains

  LETTERS = ("a".."z").to_a

  def initialize()
    print "Enter the starting word: "
    @start_word = gets.chomp.downcase
    print "Enter the finishing word (must be same length as starting word): "
    @end_word = gets.chomp.downcase
    @word_list = (cut_down_words(load_all_words) + [@start_word, @end_word]).uniq
  end

  def load_all_words
    File.readlines('dictionary.txt').map { |entry| entry.chomp }
  end

  def cut_down_words(words)
    words.select {|word| word.length == @start_word.length}
  end

  def adjacent_words(word)
    adjacent_word_list = []
    letters = word.split('')
    letters.each_with_index do |old_char, index|
      LETTERS.each do |new_char|
        test_word = word.dup
        test_word[index] = new_char
        adjacent_word_list << test_word if @word_list.include?(test_word) && word != test_word
      end
    end
    adjacent_word_list
  end

  def find_chain
    current_words = [@start_word]
    visited_words = {@start_word => nil}
    while true
      new_words = []
      current_words.each do |current_word|
        adjacent_word_list = adjacent_words(current_word)
        adjacent_word_list.each do |adjacent_word|
          visited_words[adjacent_word] = current_word unless visited_words.keys.include?(adjacent_word)
          new_words << adjacent_word unless current_words.include?(adjacent_word)
        end
      end
      return build_chain(visited_words)  if new_words.include?(@end_word)
      current_words = new_words
    end
  end

  def build_chain(visited_words)
    word_chain = [@end_word]
    current_word = @end_word
    until current_word.nil?
      previous_word = visited_words[current_word]
      word_chain << previous_word
      current_word = previous_word
    end
    word_chain[0..-2].reverse
  end
end

puts WordChains.new.find_chain
