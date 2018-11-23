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

$max = $words.length

# Returns the largest word list possible using the offsets
# that is below the max_collisions threshold
def calculate_list(offsets)
    total_collision_count = 0
    used_words = []

    list = []
    clips = 0

    offsets.each do |offset|
        word_string = $words_array[offset]

        # make sure the word hasn't been used before this list
        ii = 0
        while used_words.include? word_string
            ii = ii + 1
            word_string = $words_array[offset + ii]
        end

        # check for collisions
        used_words.each do |used_word|
            col = $collisions[used_word][word_string]
            if col == nil
                # found an impossible offset
                return list
            end
            total_collision_count += col

            if total_collision_count > $max_total_collisions || col > $max_word_collisions
                return list
            end
        end

        # no collisions found!
        list.push(word_string)
        used_words.push(word_string)
    end
end

def increment_offset(offsets)
    offsets.length.times do |i|
        offsets[i] = offsets[i] + 1

        # if the number is good, we're done
        if offsets[i] < offsets.length
            return offsets
        end

        # otherwise it overflows to zero, and we continue the loop
        # incrementing the next element...
        offsets[i] = 0
    end
end

def print_progress()

end

# Initialize offsets to zero
offsets = []
$max.times do |i|
    offsets[i] = 0
end

ignore = []

longest_offset_length = 0
longest_offset = []
while true
    list = calculate_list(offsets)

    if longest_offset_length < list.length
        longest_offset = list
        longest_offset_length = list.length
        puts "New longest: " + longest_offset_length.to_s
    end

    offsets = increment_offset(offsets)
end
