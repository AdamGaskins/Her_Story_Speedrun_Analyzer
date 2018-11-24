require "./include/process_data.rb"

##########################
########## LOAD ##########
##########################

words, clips = process("HerStory_CSV.csv", true)

# List words available by how many unseen clips they will add

list = []
unique_clips = []

def get_word_byte(item, full=false)
    str =   "[v"+item[:props][:clips].length.to_s+"]"+
            "[-" + item[:collisions].to_s + "]"+
            "[+"+item[:clips_without_collisions].to_s+"]" +
            "[~"+ "%03d" % avgwt(item) + "]"+
            "  "+
            item[:word]

    if full
        (35 - str.length).times do |i|
            str += " "
        end
        str +=  " <" + item[:clip_collisions].values.sort.reverse.join('>  <') + ">"
    end

    return str
end

def avgwt(item)
    return (item[:clips_without_collisions] * 100.0) / (item[:clips_without_collisions] + item[:collisions])
    # return item[:clips_without_collisions]
end

def sortCWC(a, b)
    a[:clips_without_collisions] <=> b[:clips_without_collisions]
end

def sortAVG(a, b)
    avgwt(a) <=> avgwt(b)
end

def sortCOL(a, b)
    a[:collisions] <=> b[:collisions]
end

while true
    show_add_message = nil

    print "Enter a keyword: "
    keywords = gets.chomp.split(',')
    keywords = [""] if keywords.length == 0
    keywords.each do |keyword|
        if keyword == "!view" || keyword == ""

            puts ""

            puts list.map { |e| e[:word] }.join(',')

            puts ""

            list.each do |item|
                puts get_word_byte(item, true)
            end

            percent = '%.2f' % (unique_clips.length / 271.0 * 100.0)
            puts ""
            puts list.length.to_s + " words."
            puts unique_clips.length.to_s + " / 271 unique clips ("+ percent +"%)."
            puts ""

            next
        end

        if keyword == "!analyze"
            print "     Keyword to analyze: "
            keyword = gets.chomp
            puts ""

            word = words[keyword]

            keyword_object = list.find{|e| e[:word] == keyword}
            puts "    "+get_word_byte(keyword_object, true)
            puts ""
            puts keyword+" has " + word[:clips].length.to_s + " clips: " + word[:clips].join(', ')

            word[:clips].each do |clip|
                puts "  CLIP " + clip.to_s + ":"
                list.each do |item|
                    next if item[:word] == keyword

                    puts "    Collides with " + get_word_byte(item, true) + "" if item[:props][:clips].include? clip
                end
            end

            puts ""
            next
        end

        if keyword == "!options"
            mywords = words.map {|word, props|
                collisions = 0
                clips_without_collisions = props[:clips].clone
                clip_collisions = props[:clips].map { |e|  [e, 0] }.to_h

                list.each do |e|
                    next if e[:word] == word # don't compare to itself

                    props[:clips].each do |clip|
                        if e[:props][:clips].include? clip
                            collisions += 1
                            clip_collisions[clip] += 1
                            clips_without_collisions.delete(clip)
                        end
                    end
                end

                {
                    :word => word,
                    :props => props,
                    :collisions => props[:clips].length - clips_without_collisions.length,
                    :clips_without_collisions => clips_without_collisions.length,
                    :clip_collisions => clip_collisions
                }
            }
            # mywords.sort!{ |a,b| (a[:collisions] == b[:collisions]) ? b[:props][:clips].length <=> a[:props][:clips].length : a[:collisions] <=> b[:collisions] }
            mywords.sort!{ |a,b| (sortAVG(a, b) == 0) ? sortCWC(a, b) : sortAVG(a, b) }
            mywords.each do |poss|
                # Skip if the word will ONLY have collisions
                next if poss[:clips_without_collisions] == 0

                # skip if the word is on the list
                next if list.find{|e| e[:word] == poss[:word]}

                puts get_word_byte(poss, true)
            end

            next
        end

        if words.has_key? keyword
            # remove word first
            list.reject! {|x| x[:word] == keyword }
            # then add it
            list.push({ :word => keyword, :props => words[keyword]})
            # wait until after calculating collisions to show message
            show_add_message = keyword
        elsif keyword.start_with? "~"
            removethis = keyword[1..-1]
            list.reject! {|x| x[:word] == removethis }
            puts "Removed "+removethis+"."
        else
            puts "What? " + keyword
            next
        end

        unique_clips = []
        list.each do |item|
            item[:props][:clips].each do |clip|
                unique_clips.push(clip) unless unique_clips.include? clip
            end
        end

        # Recalculate collisions
        list.map! { |e|
            collisions = 0
            clips_without_collisions = e[:props][:clips].clone
            clip_collisions = e[:props][:clips].map { |e|  [e, 0] }.to_h
            list.each do |e2|
                next if e2[:word] == e[:word] # don't compare to itself

                e2[:props][:clips].each do |clip|
                    if e[:props][:clips].include? clip
                        collisions += 1
                        clip_collisions[clip] += 1
                        clips_without_collisions.delete(clip)
                    end
                end
            end

            {
                :word => e[:word],
                :props => e[:props],
                :collisions => e[:props][:clips].length - clips_without_collisions.length, #collisions,
                :clips_without_collisions => clips_without_collisions.length,
                :clip_collisions => clip_collisions
            }
        }

        # list.sort!{ |a,b| (a[:collisions] == b[:collisions]) ? b[:props][:clips].length <=> a[:props][:clips].length : a[:collisions] <=> b[:collisions] }
        list.sort!{ |a,b| (sortAVG(a, b) == 0) ? sortCWC(a, b) : sortAVG(a, b) }.reverse!

        if show_add_message != nil
            item = list.find{|e| e[:word] == show_add_message}
            puts "Added "+get_word_byte(item, true)+""
        end
    end
end
