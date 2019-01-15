# CurvyPoker

Curve Dental's simple poker implementation. Where cards have no suite.

## Installation

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment with the code itself.

If you don't have a ruby/bundler environment reach out and I can provide instructions for installing ruby dependencies.

## Usage

    $ bin/play
    6
    AAKKK 23456
    KA225 33A47
    AA225 44465
    TT4A2 TTA89
    A345* 254*6
    QQ2AT QQT2J
    <EOF>

outputs the following:

    FULLHOUSE STRAIGHT a
    PAIR PAIR b
    TWOPAIR THREEOFAKIND b
    PAIR PAIR b
    STRAIGHT STRAIGHT b
    PAIR PAIR a

## Design

The intent was to have the `Hand` class not have responsibility for scoring. So, game rules are provided by the `Game`
class to determine how cards are scored. The intent behind this design was to allow for the ability to swap out the game
rules to play variations of poker without having to modify other classes. 

# Notes
- In the instructions the example showed two pair winning over a three of a kind. According to https://en.wikipedia.org/wiki/List_of_poker_hands the opposite is true, so that's what I implemented.
Similarly, in the case of an equal ranked hand, my implementation checks the kick to determine a possible winner.
- Instructions also noted that input of 1,000,000 could be expected. I did not test for that, it should not be
a problem as text input is streamed, but output however is not.

