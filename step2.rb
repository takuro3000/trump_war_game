class Game
    def initialize
        @add_temporary_score = []
        @add_temporary_deck = []
        @shuffled_arrays = []
    end
    def start_screen
        puts "戦争を開始します。"
        puts "カードが配られました。"
    end

    def battle(player1,player2)
        until (player1.score.length == 0 && player1.add_score.length == 0) || (player2.score.length == 0 && player2.add_score.length == 0) do
            if player1.score.length == 0
                self.refill(player1)
            end
            if player2.score.length == 0
                self.refill(player2)
            end
            if player1.score.length <= player2.score.length
                player1.score.zip(player2.score,player1.deck,player2.deck).each do | s1 , s2 , card1 ,card2 |
                    puts "戦争！"
                    puts "#{player1.name}のカードは#{card1}です。"
                    puts "#{player2.name}のカードは#{card2}です。"
                    self.put_on_table(player1,player2)
                    @add_temporary_score.push(s1,s2)
                    @add_temporary_deck.push(card1,card2)
                    if s1 == s2
                        puts "引き分けです。"
                    elsif s1 > s2
                        self.win(player1)
                    elsif s1 < s2
                        self.win(player2)
                    end
                end
            elsif player1.score.length > player2.score.length
                player2.score.zip(player1.score,player2.deck,player1.deck).each do | s2 , s1 , card2 ,card1 |
                    puts "戦争！"
                    puts "#{player1.name}のカードは#{card1}です。"
                    puts "#{player2.name}のカードは#{card2}です。"
                    self.put_on_table(player1,player2)
                    @add_temporary_score.push(s1,s2)
                    @add_temporary_deck.push(card1,card2)
                    if s1 == s2
                        puts "引き分けです。"
                    elsif s1 > s2
                        self.win(player1)
                    elsif s1 < s2
                        self.win(player2)
                    end
                end
            end
        end
    end
    
    def refill(player)
        player.score += player.add_score
        player.deck += player.add_deck
        @shuffled_arrays = player.score.zip(player.deck).shuffle.transpose
        player.score = @shuffled_arrays[0]
        player.deck = @shuffled_arrays[1]
        @shuffled_arrays.clear
        player.add_score.clear
        player.add_deck.clear
    end

    def put_on_table(player1,player2)
        player1.score.shift()
        player2.score.shift()
        player1.deck.shift()
        player2.deck.shift()
    end

    def win(player)
        player.add_score.push(@add_temporary_score)
        player.add_score.flatten!
        player.add_deck.push(@add_temporary_deck)
        player.add_deck.flatten!
        puts "#{player.name}が勝ちました。#{player.name}はカードを#{@add_temporary_score.length}枚もらいました。"
        @add_temporary_score.clear
        @add_temporary_deck.clear
    end

    def judge(player1,player2)
        if (player1.score.length == 0 && player1.add_score.length == 0) && (player2.score.length == 0 && player2.add_score.length == 0)
            puts "両者カードが無くなり、引き分けです"  
        elsif player1.score.length == 0 && player1.add_score.length == 0
            puts "#{player1.name}の手札がなくなりました。"
            puts "#{player2.name}の手札の枚数は#{player2.score.length+player2.add_score.length}枚です。#{player1.name}の手札の枚数は#{player1.score.length+player1.add_score.length}です。"
            puts "#{player2.name}が1位、#{player1.name}が2位です。"
        elsif player2.score.length == 0 && player2.add_score.length == 0
            puts "#{player2.name}の手札がなくなりました。"
            puts "#{player1.name}の手札の枚数は#{player1.score.length+player1.add_score.length}枚です。#{player2.name}の手札の枚数は#{player2.score.length+player2.add_score.length}です。"
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
        @add_player_deck = []
        @add_player_score = []
    end

    def add_score
        @add_player_score
    end

    def add_deck
        @add_player_deck
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
game.battle(player1,player2)
game.judge(player1,player2)
game.last_screen
