#
#
#       Calculates the number of collisions each search term has with all
#           other search terms, and outputs the data to a spreadsheet named
#           "word_collisions.csv".
#
#




require "./include/process_data.rb"

##########################
########## LOAD ##########
##########################

words, clips = process("HerStory_CSV.csv", false)


#############################
########## ANALYZE ##########
#############################

CSV.open("word_collisions.csv", "w") do |csv|

    headers = [""]
    words.each do |word, props|
        headers.push(word)
    end
    csv << headers

    # loop through each word
    words.each do |word, props|
        puts "Checking word " + word
        csvRow = [word]
        # and calculate how many collisions it has with each other word
        words.each do |word2, props2|
            collisions = 0
            props2[:clips].each do |clip|
                collisions = collisions + 1 if props[:clips].include? clip
            end
            csvRow.push(collisions)
        end

        csv << csvRow
    end

end
