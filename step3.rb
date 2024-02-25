class Game
    def initialize
        @temporary_score = []
        @temporary_deck = []
        @length_array = []
        @result_player_deck_length = []
    end
    def type_on_screen(player)
        print "プレイヤーの人数を入力してください："
        @the_number_of_players = gets.to_i

        for i in 1..@the_number_of_players do
            print "プレイヤー#{i}の名前を入力してください："
            name = gets.chomp
            player.name << name
        end
    end
    def divide(player)
        player.deck = @the_number_of_players.times.map{|i| player.deck[player.deck.length*i/@the_number_of_players...player.deck.length*(i+1)/@the_number_of_players]}
    end
    def change_to_score(player)
        for i in 0..(@the_number_of_players-1) do
            player.deck[i].each do | card |
                if card.slice(-1) == "A"
                    player.score << 15
                elsif card.slice(-1) == "K"
                    player.score << 13
                elsif card.slice(-1) == "Q"
                    player.score << 12
                elsif card.slice(-1) == "J"
                    player.score << 11
                elsif card.slice(-1) == "0"
                    player.score << 10
                else
                    player.score << card.slice(-1).to_i
                end
            end
        end
        player.score = @the_number_of_players.times.map{|i| player.score[player.score.length*i/@the_number_of_players...player.score.length*(i+1)/@the_number_of_players]}
    end
    def battle(player)
        @player_add_score = Array.new(@the_number_of_players) { [] }
        @player_add_deck = Array.new(@the_number_of_players) { [] }
        @player_score_short = Array.new(@the_number_of_players) { [] }
        @player_deck_short = Array.new(@the_number_of_players) { [] }
        until [player.score,@player_add_score].transpose.any? {|s,ps| s.empty? && ps.empty?} do
            for i in 0..(@the_number_of_players-1) do
                player.score[i].push(@player_add_score[i].dup)
                player.score[i].flatten!
                @player_add_score[i].clear
                player.deck[i].push(@player_add_deck[i].dup)
                player.deck[i].flatten!
                @player_add_deck[i].clear
            end

            for i in 0..(@the_number_of_players-1) do
                @length_array  << player.score[i].length
            end

            minimum_array_length = @length_array.min

            for i in 0..(@the_number_of_players-1) do
                @player_score_short[i] = player.score[i].slice!(0,minimum_array_length)
                @player_deck_short[i] = player.deck[i].slice!(0,minimum_array_length)
            end

            player_score_short_transpose = @player_score_short.transpose
            player_deck_short_transpose = @player_deck_short.transpose

            player_score_short_transpose.zip(player_deck_short_transpose).each do |i,m|
                max_array = i.select{|n| n == i.max}
                if max_array.length != 1
                    puts "戦争！"
                    m.zip(player.name).each do | mm , pp |
                        puts "#{pp}のカードは#{mm}です。"
                    end
                    puts "引き分けです。"
                    @temporary_score << i
                    @temporary_deck << m
                else
                    for num in 0..(i.length-1) do
                        if i.max == i[num]
                            puts "戦争！"
                            @player_add_score[num] << @temporary_score.dup
                            @temporary_score.clear
                            @player_add_score[num] << i
                            m.zip(player.name).each do | mm , pp |
                                puts "#{pp}のカードは#{mm}です。"
                            end
                            puts "#{player.name[num]}が勝ちました。#{player.name[num]}はカードを#{@the_number_of_players+@temporary_deck.flatten.length}枚もらいました。"
                            @player_add_deck[num] << @temporary_deck.dup
                            @temporary_deck.clear
                            @player_add_deck[num] << m
                        end
                    end
                end
            end

            for i in 0..(@the_number_of_players-1) do
                @player_add_score[i].flatten!
                @player_add_deck[i].flatten!
                shuffled_arrays = @player_add_score[i].zip(@player_add_deck[i]).shuffle.transpose
                @player_add_score[i] = shuffled_arrays[0]
                @player_add_deck[i] = shuffled_arrays[1]
            end

            @player_add_score.map! { |element| element.nil? ? [] : element }
            @player_add_deck.map! { |element| element.nil? ? [] : element }
        end
    end

    def judge(player)
        for i in 0..(@the_number_of_players-1) do
            @result_player_deck_length << player.score[i].length + @player_add_score[i].length
        end

        minimum_player = @result_player_deck_length.index(@result_player_deck_length.min)

        puts "#{player.name[minimum_player]}の手札がなくなりました。"

        @result_player_deck_length.zip(player.name).each do | r , name |
            print "#{name}の手札の枚数は#{r}枚です。"
        end

        puts ""

        name_and_length_transpose = [player.name,@result_player_deck_length].transpose
        hash = Hash[*name_and_length_transpose.flatten]

        hash_descending_order = hash.sort_by{ | k, v | v }.reverse.to_h

        names_order = hash_descending_order.keys.map {|e| e.to_s }

        result_deck_descending_order = @result_player_deck_length.sort.reverse

        for i in 1..@the_number_of_players do
            print "#{names_order[i-1]}が#{i-result_deck_descending_order.slice(0,i-1).count(result_deck_descending_order[i-1])}位"
            if i != @the_number_of_players
                print "、"
            elsif i == @the_number_of_players
                print "です。"
            end
        end
    end
    def last_screen
        puts ""
        puts "戦争を終了します。"
    end
end

class Deck
    def initialize
        @deck = []
        suits = ['ハート', 'ダイヤ', 'スペード', 'クラブ']
        ranks = ['A','2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', ]

        suits.each do |suit|
        ranks.each do |rank|
            @deck << "#{suit}の#{rank}"
        end
        end

        @deck = @deck.shuffle
    end

    def generate
        @deck
    end
end

class Score
    def initialize
        @score = []
    end
    def generate
        @score
    end
end

class Player
    attr_accessor  :deck , :score
    def initialize(deck,score)
        @name = []
        @deck = deck
        @score = score
    end
    def name
        @name
    end
end

game = Game.new()
deck = Deck.new()
score = Score.new()
score = score.generate
deck = deck.generate
player = Player.new(deck,score)
game.type_on_screen(player)
game.divide(player)
game.change_to_score(player)
game.battle(player)
game.judge(player)