### CHANGE THESE VALUES TO TWEAK THE SYSTEM


    # the minimum number of clips a search term must have to be selected
    min_number_of_clips = 3

    # the maximum number of clips a search term can have and still be selected
    max_number_of_clips = 99999

    # max word length
    max_word_length = 10000

    # chance to discard term
    chance_to_discard = 0.0

    # number of random permutations to try
    number_of_times_to_loop = 10000000

    # words to always ignore
    never_include = [ "fuck" ]

    # start with these words
    start_with = [
    ]

    # the number of collisions that are allowed in the entire list
    allowed_total_collisions = 99999

    # the number of collisions that are allowed for any one word in the list
    allowed_word_collisions = 3














require "./include/process_data.rb"

##########################
########## LOAD ##########
##########################

words, clips = process("HerStory_CSV.csv", false)

#############################
########## ANALYZE ##########
#############################

#puts words
puts "Looping " + number_of_times_to_loop.to_s + " times"

biggest_list_of_search_terms, collisions = find_word_list(  words,
                                                min_number_of_clips,
                                                max_number_of_clips,
                                                max_word_length,
                                                chance_to_discard,
                                                number_of_times_to_loop,
                                                never_include,
                                                start_with,
                                                allowed_word_collisions,
                                                allowed_total_collisions)

# puts "***** BIGGEST: ******"
# output_list(biggest_list_of_search_terms, collisions)
