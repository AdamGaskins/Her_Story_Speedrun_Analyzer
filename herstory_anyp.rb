### CHANGE THESE VALUES TO TWEAK THE SYSTEM


    # the minimum number of clips a search term must have to be selected
    min_number_of_clips = 5

    # the maximum number of clips a search term can have and still be selected
    max_number_of_clips = 99999

    # max word length
    max_word_length = 4

    # chance to discard term
    chance_to_discard = 0.0

    # number of random permutations to try
    number_of_times_to_loop = 10000

    # words to always ignore
    never_include = [ "fuck" ]

    # start with these words
    start_with = [
        "call", # florence
        "mum", # sister/twin & attic
        "cloth", # baby & murder
    ]














require "./include/process_data.rb"

##########################
########## LOAD ##########
##########################

words, clips = process("HerStory_CSV.csv")

#############################
########## ANALYZE ##########
#############################

puts words["hid"]
puts "Looping " + number_of_times_to_loop.to_s + " times"

biggest_list_of_search_terms = find_word_list(  words,
                                                min_number_of_clips,
                                                max_number_of_clips,
                                                max_word_length,
                                                chance_to_discard,
                                                number_of_times_to_loop,
                                                never_include,
                                                start_with)

puts biggest_list_of_search_terms
