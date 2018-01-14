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














require 'csv'

lines = CSV.read("HerStory_CSV.csv", { headers: true, encoding: "UTF-8" })

# variables
words = {}
clips = []

index = 0

##########################
########## LOAD ##########
##########################

# takes a single search term and turns it into all possible terms
# plural words become singular
# "fees" > "fees" and "fee" and "fe"
# "fishes" > "fishes" and "fishe" and "fish"
#
# singular words become plural
# "cat" > "cat" and "cats" and "cates"
def transform_term(term)
    if term.end_with?("es")
        return [ term, term[0...-1], term[0...-2] ]
    elsif term.end_with?("s")
        return [ term, term[0...-1] ]
    else
        return [ term, term + "s", term + "es" ]
    end
end

# loop through each line
lines.each do |line|
    # get the text
    text = line["Transcript"] + ""

    # clean up the line
    text.downcase!() # to lowercase
    text.gsub!(/[^a-zA-Z0-9]/i, ' ')

    # so we can skip a word if it has already appeared in this clip
    words_already_in_this_line = []

    # the object for the current clip
    clip = {
        text: text,
        index: index,
        search_terms: []
    }

    # loop through each word in the clip
    text.split(' ').each do |_word|
        # get variations for the word
        variations = transform_term(_word)

        # make sure we don't count two variants
        at_least_one_variant_accounted_for = false

        # just doing the same thing to multiple variations of this word
        variations.each do |word|
            # skip empty 'words'
            next if word.length() == 0

            # skip if we've already seen this word on this line
            next if words_already_in_this_line.include? word

            # mark this word as already seen this line
            words_already_in_this_line << word

            # if the word has been seen in a previous line
            if words.has_key? word
                # mark that this clip will show for this word if it has appeared less than 5 times before
                if words[word][:count] < 5
                    # add search term to clip
                    clip[:search_terms] << word

                    # add clip to search term
                    words[word][:clips] << index
                end

                # increase the occurance count
                words[word][:count] += 1 if not at_least_one_variant_accounted_for


                at_least_one_variant_accounted_for = true
            else # if the word doesn't exist
                # add the word to the list
                words[word] = {
                    count: 1,
                    clips: [ index ]
                }

                # mark that this clip will show for this word (since it's never appeared before)
                clip[:search_terms] << word

                at_least_one_variant_accounted_for = true
            end
        end
    end

    # save the clip
    clips << clip

    # increase the index
    index += 1

    # add the search terms back
    line[15] = " " + (clip[:search_terms] * " ") + " "
end

# write csv back out
# CSV.open("generated_data.csv", "wb") do |csv|
#     csv << lines.headers
#
#     lines.each do |line|
#         csv << line
#     end
# end


#############################
########## ANALYZE ##########
#############################

# Okay, so the goal is to find the biggest list of search terms we can that
# don't collide, or with the least number of collisions possible. A collision
# means two search terms pull up the same video.

# There are definitely smarter ways to do this, but my method pretty much uses
# dice rolls until it finds a sufficient list.

puts words["hid"]


# We'll do this a bunch of times, and spit out the list with the most search terms

puts "Looping " + number_of_times_to_loop.to_s + " times"

biggest_list_of_search_terms = []

(1..number_of_times_to_loop).each do |i|
    # search terms selected
    search_terms = []

    # clips that have already come up, and shouldn't come up again
    blacklisted_clips = []

    # preload the start_with words
    start_with.each do |start_with_word|
        # add it to the search terms
        search_terms << start_with_word

        # blacklist the proper clips
        words[start_with_word][:clips].each do |clip|
            if not blacklisted_clips.include? clip
                blacklisted_clips << clip
            end
        end
    end

    # shuffle words
    words = Hash[*words.to_a.shuffle.flatten]

    # loop through each word
    words.each do |word, props|
        # ignore plural words
        next if word.end_with? "es"
        next if word.end_with? "s"

        # ignore permanently blacklisted words
        next if never_include.include? word

        # ignore words that don't have enough clips
        next if props[:count] < min_number_of_clips

        # ignore words that have too many clips
        next if props[:count] > max_number_of_clips

        # ignore words that are too long
        next if word.length > max_word_length

        # check to see if the search term pulls up clips we've already seen
        pulls_up_blacklisted_clips = false
        props[:clips].each do |clip|
            if blacklisted_clips.include? clip
                pulls_up_blacklisted_clips = true
                break
            end
        end

        # ignore words that pull up clips we've already seen
        next if pulls_up_blacklisted_clips

        # ignore if random chance
        next if rand < chance_to_discard

        # if we get here, that means this search term has been selected
        # add it to the list
        search_terms << word

        # blacklist all the clips it pulls up
        props[:clips].each do |clip|
            blacklisted_clips << clip
        end
    end

    if search_terms.length > biggest_list_of_search_terms.length
        biggest_list_of_search_terms = search_terms
        puts search_terms.length.to_s + ": "
        puts search_terms
        puts ""
    end
end

puts biggest_list_of_search_terms
