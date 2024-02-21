players_name = []

print "プレイヤーの人数を入力してください："
the_number_of_players = gets.to_i

for i in 1..the_number_of_players do
    print "プレイヤー#{i}の名前を入力してください："
    name = gets.chomp
    players_name << name
end

suits = ['ハート', 'ダイヤ', 'スペード', 'クラブ']
ranks = ['A','2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', ]
deck = []

suits.each do |suit|
  ranks.each do |rank|
    deck << "#{suit}の#{rank}"
  end
end

deck.shuffle!
deck = the_number_of_players.times.map{|i| deck[deck.length*i/the_number_of_players...deck.size*(i+1)/the_number_of_players]}

score = []

for i in 0..(the_number_of_players-1) do
    deck[i].each do | card |
        if card.slice(-1) == "A"
            score << 15
        elsif card.slice(-1) == "K"
            score << 13
        elsif card.slice(-1) == "Q"
            score << 12
        elsif card.slice(-1) == "J"
            score << 11
        elsif card.slice(-1) == "0"
            score << 10
        else
            score << card.slice(-1).to_i
        end
    end
end

score = the_number_of_players.times.map{|i| score[score.length*i/the_number_of_players...score.size*(i+1)/the_number_of_players]}

c = Array.new(the_number_of_players) { [] }
d = Array.new(the_number_of_players) { [] }
add_c = []
add_d = []

until [score,c].transpose.any? {|s,cc| s.empty? && cc.empty?} do
    for i in 0..(the_number_of_players-1) do
        score[i].push(c[i].dup)
        score[i].flatten!
        c[i].clear
        deck[i].push(d[i].dup)
        deck[i].flatten!
        d[i].clear
    end

    length_array = []

    for i in 0..(the_number_of_players-1) do
        length_array  << score[i].length
    end

    minimum_array_length = length_array.min

    c_new = Array.new(the_number_of_players) { [] }
    d_new = Array.new(the_number_of_players) { [] }

    for i in 0..(the_number_of_players-1) do
        c_new[i] = score[i].slice!(0,minimum_array_length)
        d_new[i] = deck[i].slice!(0,minimum_array_length)
    end

    c_temporary = c_new.transpose
    d_temporary = d_new.transpose

    c_temporary.zip(d_temporary).each do |i,m|
        max_array = i.select{|n| n == i.max}
        if max_array.length != 1
            puts "戦争！"
            m.zip(players_name).each do | mm , pp |
                puts "#{pp}のカードは#{mm}です。"
            end
            puts "引き分けです。"
            add_c << i
            add_d << m
        else
            for num in 0..(i.length-1) do
                if i.max == i[num]
                    puts "戦争！"
                    c[num] << add_c.dup
                    add_c.clear
                    c[num] << i
                    m.zip(players_name).each do | mm , pp |
                        puts "#{pp}のカードは#{mm}です。"
                    end
                    puts "#{players_name[num]}が勝ちました。#{players_name[num]}はカードを#{the_number_of_players+add_d.flatten.length}枚もらいました。"
                    d[num] << add_d.dup
                    add_d.clear
                    d[num] << m
                end
            end
        end
    end

    for i in 0..(the_number_of_players-1) do
        c[i].flatten!
        d[i].flatten!
        shuffled_arrays = c[i].zip(d[i]).shuffle.transpose
        c[i] = shuffled_arrays[0]
        d[i] = shuffled_arrays[1]
    end

    c.map! { |element| element.nil? ? [] : element }
    d.map! { |element| element.nil? ? [] : element }
end

result_deck_size = []

for i in 0..(the_number_of_players-1) do
    result_deck_size << score[i].length + c[i].length
end

minimum_player = result_deck_size.index(result_deck_size.min)

puts "#{players_name[minimum_player]}の手札がなくなりました。"

result_deck_size.zip(players_name).each do | r , name |
    print "#{name}の手札の枚数は#{r}枚です。"
end

puts ""

hash_before = [players_name,result_deck_size].transpose
hash = Hash[*hash_before.flatten]

hash_change = hash.sort_by{ | k, v | v }.reverse.to_h

order_names = hash_change.keys.map {|e| e.to_s }

order_deck = result_deck_size.sort.reverse



for i in 1..the_number_of_players do
    print "#{order_names[i-1]}が#{i-order_deck.slice(0,i-1).count(order_deck[i-1])}位"
    if i != the_number_of_players
        print "、"
    elsif i == the_number_of_players
        print "です。"
    end
end

puts ""
puts "戦争を終了します。"


