require "./include/process_data.rb"

##########################
########## LOAD ##########
##########################

words, clips = process("HerStory_CSV.csv")
puts "Loaded words."
collisions = load_collisions("word_collisions.csv")
puts "Loaded collisions."

#############################
########## ANALYZE ##########
#############################
