class Game
    def initialize
        @add_score = []
        @add_deck = []
    end
    def start_screen
        puts "戦争を開始します。"
        puts "カードが配られました。"
    end

    def judge(player1,player2)
        player1.score.zip(player2.score,player1.deck,player2.deck).each do | s1 , s2 , card1 ,card2 |
            puts "戦争！"
            puts "#{player1.name}のカードは#{card1}です。"
            puts "#{player2.name}のカードは#{card2}です。"
            self.put_on_table(player1,player2)
            @add_score.push(s1,s2)
            @add_deck.push(card1,card2)
            if s1 == s2
                puts "引き分けです。"
            elsif s1 > s2
                puts "#{player1.name}が勝ちました。"
                break
            elsif s1 < s2
                puts "#{player2.name}が勝ちました。"
                break
            end
        end
    end

    def put_on_table(player1,player2)
        player1.score.shift()
        player2.score.shift()
        player1.deck.shift()
        player2.deck.shift()
    end

    def last_screen
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

        @deck.shuffle!
    end

    def divide
        total_number_of_playing_cards = 52
        the_number_of_players = 2
        divided_number = total_number_of_playing_cards/the_number_of_players
        @deck = @deck.each_slice(divided_number).to_a
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
deck = deck.divide
player1_deck = deck[0]
player2_deck = deck[1]
player1_score = score1.change_to_score(player1_deck)
player2_score = score2.change_to_score(player2_deck)
player1 = Player.new("プレイヤー1",player1_deck,player1_score)
player2 = Player.new("プレイヤー2",player2_deck,player2_score)
game.start_screen
game.judge(player1,player2)
game.last_screen
