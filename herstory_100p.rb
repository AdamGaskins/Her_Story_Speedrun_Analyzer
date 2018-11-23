$max_word_collisions = 0
$max_total_collisions = 0

require "./include/process_data.rb"

##########################
########## LOAD ##########
##########################

$words, $clips = process("HerStory_CSV.csv", true)
$words_array = $words.keys
puts "Loaded words."
$collisions = load_collisions("word_collisions.csv")
puts "Loaded collisions."

#############################
########## ANALYZE ##########
#############################

$words_array.combination(55) do |c|
    total_col = 0

    # check for collisions
    c.each do |word1|
        c.each do |word2|
            next if word1 == word2

            word_col = $collisions[used_word][word_string]
        if col == nil
            # found an impossible offset
            return list
        end
        total_collision_count += col

        if total_collision_count > $max_total_collisions || col > $max_word_collisions
            return list
        end
    end

end
