class Game
    def initialize
        @add_temporary_score = []
        @add_temporary_deck = []
        @add_player1_deck = []
        @add_player2_deck = []
        @add_player1_score = []
        @add_player2_score = []
        @shuffled_arrays = []
    end
    def start_screen
        puts "戦争を開始します。"
        puts "カードが配られました。"
    end

    def judge(player1,player2)
        until (player1.score.length == 0 && @add_player1_score.length == 0) || (player2.score.length == 0 && @add_player2_score.length == 0) do
            if player1.score.length == 0
                player1.score += @add_player1_score
                player1.deck += @add_player1_deck
                @shuffled_arrays = player1.score.zip(player1.deck).shuffle.transpose
                player1.score = @shuffled_arrays[0]
                player1.deck = @shuffled_arrays[1]
                @shuffled_arrays.clear
                @add_player1_score.clear
                @add_player1_deck.clear
            end
            if player2.score.length == 0
                player2.score += @add_player2_score
                player2.deck += @add_player2_deck
                @shuffled_arrays = player2.score.zip(player2.deck).shuffle.transpose
                player2.score = @shuffled_arrays[0]
                player2.deck = @shuffled_arrays[1]
                @shuffled_arrays.clear
                @add_player2_score.clear
                @add_player2_deck.clear
            end
            if player1.score.length <= player2.score.length
                player1.score.zip(player2.score,player1.deck,player2.deck).each do | s1 , s2 , card1 ,card2 |
                    if s1 == s2
                        puts "戦争！"
                        puts "#{player1.name}のカードは#{card1}です。"
                        puts "#{player2.name}のカードは#{card2}です。"
                        player1.score.shift()
                        player2.score.shift()
                        player1.deck.shift()
                        player2.deck.shift()
                        @add_temporary_score.push(s1,s2)
                        @add_temporary_deck.push(card1,card2)
                        puts "引き分けです。"
                    elsif s1 > s2
                        puts "戦争！"
                        puts "#{player1.name}のカードは#{card1}です。"
                        puts "#{player2.name}のカードは#{card2}です。"
                        player1.score.shift()
                        player2.score.shift()
                        player1.deck.shift()
                        player2.deck.shift()
                        @add_player1_score.push(s1,s2)
                        @add_player1_deck.push(card1,card2)
                        @add_player1_score.push(@add_temporary_score)
                        @add_player1_score.flatten!
                        @add_player1_deck.push(@add_temporary_deck)
                        @add_player1_deck.flatten!
                        puts "#{player1.name}が勝ちました。#{player1.name}はカードを#{2+@add_temporary_score.length}枚もらいました。"
                        @add_temporary_score.clear
                        @add_temporary_deck.clear
                    elsif s1 < s2
                        puts "戦争！"
                        puts "#{player1.name}のカードは#{card1}です。"
                        puts "#{player2.name}のカードは#{card2}です。"
                        player1.score.shift()
                        player2.score.shift()
                        player1.deck.shift()
                        player2.deck.shift()
                        @add_player2_score.push(s1,s2)
                        @add_player2_deck.push(card1,card2)
                        @add_player2_score.push(@add_temporary_score)
                        @add_player2_score.flatten!
                        @add_player2_deck.push(@add_temporary_deck)
                        @add_player2_deck.flatten!
                        puts "#{player2.name}が勝ちました。#{player2.name}はカードを#{2+@add_temporary_score.length}枚もらいました。"
                        @add_temporary_score.clear
                        @add_temporary_deck.clear
                    end
                end
            elsif player1.score.length > player2.score.length
                player2.score.zip(player1.score,player2.deck,player1.deck).each do | s2 , s1 , card2 ,card1 |
                    if s1 == s2
                        puts "戦争！"
                        puts "#{player1.name}のカードは#{card1}です。"
                        puts "#{player2.name}のカードは#{card2}です。"
                        player1.score.shift()
                        player2.score.shift()
                        player1.deck.shift()
                        player2.deck.shift()
                        @add_temporary_score.push(s1,s2)
                        @add_temporary_deck.push(card1,card2)
                        puts "引き分けです。"
                    elsif s1 > s2
                        puts "戦争！"
                        puts "#{player1.name}のカードは#{card1}です。"
                        puts "#{player2.name}のカードは#{card2}です。"
                        player1.score.shift()
                        player2.score.shift()
                        player1.deck.shift()
                        player2.deck.shift()
                        @add_player1_score.push(s1,s2)
                        @add_player1_deck.push(card1,card2)
                        @add_player1_score.push(@add_temporary_score)
                        @add_player1_score.flatten!
                        @add_player1_deck.push(@add_temporary_deck)
                        @add_player1_deck.flatten!
                        puts "#{player1.name}が勝ちました。#{player1.name}はカードを#{2+@add_temporary_score.length}枚もらいました。"
                        @add_temporary_score.clear
                        @add_temporary_deck.clear
                    elsif s1 < s2
                        puts "戦争！"
                        puts "#{player1.name}のカードは#{card1}です。"
                        puts "#{player2.name}のカードは#{card2}です。"
                        player1.score.shift()
                        player2.score.shift()
                        player1.deck.shift()
                        player2.deck.shift()
                        @add_player2_score.push(s1,s2)
                        @add_player2_deck.push(card1,card2)
                        @add_player2_score.push(@add_temporary_score)
                        @add_player2_score.flatten!
                        @add_player2_deck.push(@add_temporary_deck)
                        @add_player2_deck.flatten!
                        puts "#{player2.name}が勝ちました。#{player2.name}はカードを#{2+@add_temporary_score.length}枚もらいました。"
                        @add_temporary_score.clear
                        @add_temporary_deck.clear
                    end
                end
            end
        end

        if player1.score.length == 0 && @add_player1_score.length == 0
            puts "#{player1.name}の手札がなくなりました。"
            puts "#{player2.name}の手札の枚数は#{player2.score.length+@add_player2_score.length}枚です。#{player1.name}の手札の枚数は#{player1.score.length+@add_player1_score.length}です。"
            puts "#{player2.name}が1位、#{player1.name}が2位です。"
        elsif player2.score.length == 0 && @add_player2_score.length == 0
            puts "#{player2.name}の手札がなくなりました。"
            puts "#{player1.name}の手札の枚数は#{player1.score.length+@add_player1_score.length}枚です。#{player2.name}の手札の枚数は#{player2.score.length+@add_player2_score.length}です。"
            puts "#{player1.name}が1位、#{player2.name}が2位です。"
        end
    end

    def last_screen
        puts "戦争を終了します"
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
        divided_number = 52/2
        @deck = @deck.each_slice(divided_number).to_a
    end

    def generate
        @deck
    end
end

class Score
    def initialize
        @score = []
    end
    def change_to_score(deck)
        deck.each do | card |
            if card.slice(-1) == "A"
                @score << 15
            elsif card.slice(-1) == "K"
                @score << 13
            elsif card.slice(-1) == "Q"
                @score << 12
            elsif card.slice(-1) == "J"
                @score << 11
            elsif card.slice(-1) == "0"
                @score << 10
            else
                @score << card.slice(-1).to_i
            end
        end
    end
    def generate
        @score
    end
end

class Player
    attr_accessor :name , :deck , :score
    def initialize(name,deck,score)
        @name = name
        @deck = deck
        @score = score
    end
end

game = Game.new()
deck = Deck.new()
score1 = Score.new()
score2 = Score.new()
deck = deck.generate
player1_deck = deck[0]
player2_deck = deck[1]
score1.change_to_score(player1_deck)
player1_score = score1.generate
score2.change_to_score(player2_deck)
player2_score = score2.generate
player1 = Player.new("プレイヤー1",player1_deck,player1_score)
player2 = Player.new("プレイヤー2",player2_deck,player2_score)
game.start_screen
game.judge(player1,player2)
game.last_screen
