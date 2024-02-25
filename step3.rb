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

player_add_score = Array.new(the_number_of_players) { [] }
player_add_deck = Array.new(the_number_of_players) { [] }
temporary_score = []
temporary_deck = []

until [score,player_add_score].transpose.any? {|s,ps| s.empty? && ps.empty?} do
    for i in 0..(the_number_of_players-1) do
        score[i].push(player_add_score[i].dup)
        score[i].flatten!
        player_add_score[i].clear
        deck[i].push(player_add_deck[i].dup)
        deck[i].flatten!
        player_add_deck[i].clear
    end

    length_array = []

    for i in 0..(the_number_of_players-1) do
        length_array  << score[i].length
    end

    minimum_array_length = length_array.min

    player_score_short = Array.new(the_number_of_players) { [] }
    player_deck_short = Array.new(the_number_of_players) { [] }

    for i in 0..(the_number_of_players-1) do
        player_score_short[i] = score[i].slice!(0,minimum_array_length)
        player_deck_short[i] = deck[i].slice!(0,minimum_array_length)
    end

    player_score_short_transpose = player_score_short.transpose
    player_deck_short_transpose = player_deck_short.transpose

    player_score_short_transpose.zip(player_deck_short_transpose).each do |i,m|
        max_array = i.select{|n| n == i.max}
        if max_array.length != 1
            puts "戦争！"
            m.zip(players_name).each do | mm , pp |
                puts "#{pp}のカードは#{mm}です。"
            end
            puts "引き分けです。"
            temporary_score << i
            temporary_deck << m
        else
            for num in 0..(i.length-1) do
                if i.max == i[num]
                    puts "戦争！"
                    player_add_score[num] << temporary_score.dup
                    temporary_score.clear
                    player_add_score[num] << i
                    m.zip(players_name).each do | mm , pp |
                        puts "#{pp}のカードは#{mm}です。"
                    end
                    puts "#{players_name[num]}が勝ちました。#{players_name[num]}はカードを#{the_number_of_players+temporary_deck.flatten.length}枚もらいました。"
                    player_add_deck[num] << temporary_deck.dup
                    temporary_deck.clear
                    player_add_deck[num] << m
                end
            end
        end
    end

    for i in 0..(the_number_of_players-1) do
        player_add_score[i].flatten!
        player_add_deck[i].flatten!
        shuffled_arrays = player_add_score[i].zip(player_add_deck[i]).shuffle.transpose
        player_add_score[i] = shuffled_arrays[0]
        player_add_deck[i] = shuffled_arrays[1]
    end

    player_add_score.map! { |element| element.nil? ? [] : element }
    player_add_deck.map! { |element| element.nil? ? [] : element }
end

result_player_deck_length = []

for i in 0..(the_number_of_players-1) do
    result_player_deck_length << score[i].length + player_add_score[i].length
end

minimum_player = result_player_deck_length.index(result_player_deck_length.min)

puts "#{players_name[minimum_player]}の手札がなくなりました。"

result_player_deck_length.zip(players_name).each do | r , name |
    print "#{name}の手札の枚数は#{r}枚です。"
end

puts ""

name_and_length_transpose = [players_name,result_player_deck_length].transpose
hash = Hash[*name_and_length_transpose.flatten]

hash_descending_order = hash.sort_by{ | k, v | v }.reverse.to_h

names_order = hash_descending_order.keys.map {|e| e.to_s }

result_deck_descending_order = result_player_deck_length.sort.reverse

for i in 1..the_number_of_players do
    print "#{names_order[i-1]}が#{i-result_deck_descending_order.slice(0,i-1).count(result_deck_descending_order[i-1])}位"
    if i != the_number_of_players
        print "、"
    elsif i == the_number_of_players
        print "です。"
    end
end

puts ""
puts "戦争を終了します。"