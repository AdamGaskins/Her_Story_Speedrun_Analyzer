# Her Story Transcript Analyzer

This is a script written in ruby that analyzes the Her Story lines and finds a list of optimal search terms for running the game.

## The Algorithm

I feel silly even calling it an algorithm because it's pretty crude, but hey, it works. Basically it loops through the list of search terms (which are filtered, see below), trying to create the longest list of search terms it can that don't have collisions.

You can go in the script and easily configure the values at the top. If you want to mess around with it, you don't have to know how to program, just download ruby and change the numbers at the top.

## Configuring The Algorithm

The following options can be modified at the top of the ruby script to change how the search terms are filtered:

1. `min_number_of_clips`: The minimum number of results that a search term must produce in order to be considered. The default is 5 because we obviously don't want 0-4 clips coming up in a run!
2. `max_number_of_clips`: The maximum number of results that a search term can produce and still be included. I originally had this set to a low number like 10 because I thought it would help, but I found I got better results when I set it to a huge number that didn't cut anything.
3. `max_word_length`: The cut off for search term length. The default is `4`, so any search terms longer than 4 letters won't be considered.
4. `chance_to_discard`: This adds some randomness, which I thought would be useful, but ended up being not so much. But if you want to you can set it to whatever you want. 0.5 gives a 50% chance each search term will be discarded, for example.
5. `number_of_times_to_loop`: Number of lists to create and compare. I set this to a really big number to try to find the best possible list. The higher the number, the better your chances are of finding a good list, but the longer it'll take obviously.
6. `never_include`: A list of search terms to blacklist. I just didn't want the F word in my run :)
7. `start_with`: A list of search terms to include by default. This was just to ensure I hit all the plot points. I was too lazy to code that functionality in :^)
