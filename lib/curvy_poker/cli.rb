# frozen_string_literal: true

module CurvyPoker
  class CLI
    def initialize
      @game = Game.new
      @games_played = 0
    end

    def start(game_inputs)
      num_games = game_inputs.next.to_i

      results = +''
      game_inputs.each do |line|

        results << parse(line) << "\n"
        break if @games_played >= num_games
      end

      puts results
      puts 'Warning: unexpected number of games played' if @games_played != num_games
    end

    def parse(line)
      @games_played += 1
      run_game(line[0..4], line[6..10])
    end

    def run_game(*hands_as_text)
      hands = hands_as_text.collect { |hand| @game.deal CurvyPoker::Hand.new(hand) }

      winners = @game.showdown

      rankings = hands.collect { |hand| @game.rank_hand(hand) }
                      .join(' ')

      names = ('a'..'z').take(hands.length)
      winners = hands.collect { |hand| winners.include? hand }
                     .each_with_index
                     .collect { |won, idx| names[idx] if won }
                     .compact
                     .join

      rankings + ' ' + winners
    end
  end
end
