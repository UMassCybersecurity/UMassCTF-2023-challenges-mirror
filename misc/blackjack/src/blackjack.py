# Credit to https://codereview.stackexchange.com/questions/82103/ascii-fication-of-playing-cards user 200_success

import random
# import datetime
# import pytz  # pip install pytz
import sys


class Card(object):
    card_values = {
        'Ace_high': 11,  # value of the ace is high until it needs to be low
        'Ace_low': 1,
        '2': 2,
        '3': 3,
        '4': 4,
        '5': 5,
        '6': 6,
        '7': 7,
        '8': 8,
        '9': 9,
        '10': 10,
        'Jack': 10,
        'Queen': 10,
        'King': 10
    }

    def __init__(self, suit, rank):
        """
        :param suit: The face of the card, e.g. Spade or Diamond
        :param rank: The value of the card, e.g 3 or King
        """
        self.suit = suit.capitalize()
        self.rank = rank
        self.points = self.card_values[rank]


def ascii_version_of_card(*cards, return_string=True):
    """
    Instead of a boring text version of the card we render an ASCII image of the card.
    :param cards: One or more card objects
    :param return_string: By default we return the string version of the card, but the dealer hide the 1st card and we
    keep it as a list so that the dealer can add a hidden card in front of the list
    """
    # we will use this to prints the appropriate icons for each card
    suits_name = ['Spades', 'Diamonds', 'Hearts', 'Clubs']
    suits_symbols = ['♠', '♦', '♥', '♣']

    # create an empty list of list, each sublist is a line
    lines = [[] for i in range(9)]

    for index, card in enumerate(cards):
        # "King" should be "K" and "10" should still be "10"
        if card.rank == '10':  # ten is the only one who's rank is 2 char long
            rank = card.rank
            space = ''  # if we write "10" on the card that line will be 1 char to long
        else:
            rank = card.rank[0]  # some have a rank of 'King' this changes that to a simple 'K' ("King" doesn't fit)
            space = ' '  # no "10", we use a blank space to will the void
        # get the cards suit in two steps
        suit = suits_name.index(card.suit)
        suit = suits_symbols[suit]

        # add the individual card on a line by line basis
        lines[0].append('┌─────────┐')
        lines[1].append('│{}{}       │'.format(rank, space))  # use two {} one for char, one for space or char
        # lines[2].append('│         │')
        lines[2].append('│         │')
        lines[3].append('│    {}    │'.format(suit))
        lines[4].append('│         │')
        # lines[6].append('│         │')
        lines[5].append('│       {}{}│'.format(space, rank))
        lines[6].append('└─────────┘')

    result = []
    for index, line in enumerate(lines):
        result.append(''.join(lines[index]))

    # hidden cards do not use string
    if return_string:
        return '\n'.join(result)
    else:
        return result


def ascii_version_of_hidden_card(*cards):
    """
    Essentially the dealers method of print ascii cards. This method hides the first card, shows it flipped over
    :param cards: A list of card objects, the first will be hidden
    :return: A string, the nice ascii version of cards
    """
    # a flipper over card. # This is a list of lists instead of a list of string becuase appending to a list is better then adding a string
    lines = [['┌─────────┐'], ['│░░░░░░░░░│'], ['│░░░░░░░░░│'], ['│░░░░░░░░░│'], ['│░░░░░░░░░│'], ['│░░░░░░░░░│'],
             ['└─────────┘']]

    # store the non-flipped over card after the one that is flipped over
    cards_except_first = ascii_version_of_card(*cards[1:], return_string=False)
    for index, line in enumerate(cards_except_first):
        if index <= 6:
            lines[index].append(line)

    # make each line into a single list
    for index, line in enumerate(lines):
        lines[index] = ''.join(line)

    # convert the list into a single string
    return '\n'.join(lines)


# To allow for card counting to work, you need it to be considered drawing from a "deck" not completely randomly
def deck_build(number_of_decks):
    suits = ["Diamonds", "Clubs", "Spades", "Hearts"]
    cards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace_high"]
    decks = []
    for i in range(number_of_decks):
        deck = []
        for suit in suits:
            for card in cards:
                deck.append(Card(suit, card))
        decks.append(deck)

    return decks


def generate_card():
    # for testing purposes, should use random.seed(number)
    # random.seed(111619)
    random_deck = random.randint(0, len(decks) - 1)
    random_card = random.randint(0, 51)
    if random_card > len(decks[random_deck]) - 1:
        return generate_card()
    else:
        # Acts like a real deck that is removing a card once it has been played
        card_picked = decks[random_deck][random_card]
        decks[random_deck].remove(card_picked)
        return card_picked


def ai_player(ai_hand, ai_number):
    ai_card_total_high_ace = 0
    ai_card_total_low_ace = 0
    for index, dealer_card in enumerate(ai_hand):
        try:
            if dealer_card.rank == 'Ace_high':
                ai_card_total_high_ace += 11
                ai_card_total_low_ace += 1
            else:
                ai_card_total_low_ace += dealer_card.points
                ai_card_total_high_ace += dealer_card.points
        except AttributeError:
            pass

    while True:
        new_card = generate_card()
        # If there is an ace, need to keep track of two values
        if new_card.rank == 'Ace_high':
            ai_card_total_high_ace += 11
            ai_card_total_low_ace += 1

        if ai_card_total_low_ace <= 17 and not 18 <= ai_card_total_high_ace <= 21:
            if new_card.rank != 'Ace_high':
                ai_card_total_low_ace += new_card.points
                ai_card_total_high_ace += new_card.points
            ai_hand.append(new_card)

            # print("AI{} draws a card. AI{}'s new hand:".format(ai_number, ai_number))
            # print(ascii_version_of_card(*ai_hand))

        elif 18 <= ai_card_total_low_ace <= 21:
            print(ascii_version_of_card(*ai_hand))
            print("AI{} stands with a total of {}".format(ai_number, ai_card_total_low_ace))
            break
        elif 18 <= ai_card_total_high_ace <= 21:
            print(ascii_version_of_card(*ai_hand))
            print("AI{} stands with a total of {}".format(ai_number, ai_card_total_high_ace))
            break
        else:
            print(ascii_version_of_card(*ai_hand))
            print("AI{} busts as they have over 21".format(ai_number))
            break


def game_engine():
    print("Dealer's hand:")
    dealer_hand = [generate_card(), generate_card()]
    print(ascii_version_of_hidden_card(dealer_hand[0], dealer_hand[1]))

    # Need AI to enable card counting by player
    for i in range(1, 5):
        print("\nAI {}:".format(i))
        ai_hand = [generate_card(), generate_card()]
        ai_player(ai_hand, i)

    print("\nPlayer's hand:")
    player_hand = [generate_card(), generate_card()]
    print(ascii_version_of_card(player_hand[0], player_hand[1]))

    while True:
        player_card_total_high_ace = 0
        player_card_total_low_ace = 0
        for index, player_card in enumerate(player_hand):
            if player_card.rank == 'Ace_high':
                player_card_total_high_ace += 11
                player_card_total_low_ace += 1
            else:
                player_card_total_low_ace += player_card.points
                player_card_total_high_ace += player_card.points
        if player_card_total_low_ace < 21:
            try:
                player_input = input(
                    "Do you want to stand or hit? (Please input just the word 'stand' or the word 'hit')\n").strip().lower()
            except KeyboardInterrupt:
                sys.exit(0)
            if player_input == "stand":
                break
            elif player_input == "hit":
                player_hand.append(generate_card())
                print(ascii_version_of_card(*player_hand), end="")
            else:
                print(
                    "Invalid input. Please input either 'hit' or 'stand' for your action to attempt to beat the dealer")
        elif player_card_total_low_ace == 21 or player_card_total_high_ace == 21:
            break
        elif player_card_total_low_ace > 21:
            print("Player busts as they have over 21")
            return 0

    if player_card_total_high_ace > 21 or player_card_total_high_ace == 0:
        player_card_total = player_card_total_low_ace
    else:
        player_card_total = player_card_total_high_ace

    print("Dealer's face up hand:")
    print(ascii_version_of_card(*dealer_hand))
    dealer_card_total_high_ace = 0
    dealer_card_total_low_ace = 0
    for index, dealer_card in enumerate(dealer_hand):
        if dealer_card.rank == 'Ace_high':
            dealer_card_total_high_ace += 11
            dealer_card_total_low_ace += 1
        else:
            dealer_card_total_low_ace += dealer_card.points
            dealer_card_total_high_ace += dealer_card.points

    while True:
        new_card = generate_card()
        # If there is an ace, need to keep track of two values
        if new_card.rank == 'Ace_high':
            dealer_card_total_high_ace += 11
            dealer_card_total_low_ace += 1

        if dealer_card_total_low_ace <= 17 and not 18 <= dealer_card_total_high_ace <= 21:
            if new_card.rank != 'Ace_high':
                dealer_card_total_low_ace += new_card.points
                dealer_card_total_high_ace += new_card.points
            dealer_hand.append(new_card)

            print("Dealer draws a card. Dealer's new hand:")
            print(ascii_version_of_card(*dealer_hand))

        elif 18 <= dealer_card_total_low_ace <= 21 or 18 <= dealer_card_total_high_ace <= 21:
            break
        else:
            print("Dealer busts as they have over 21")
            return 1

    if dealer_card_total_high_ace > 21 or dealer_card_total_high_ace == 0:
        dealer_card_total = dealer_card_total_low_ace
    else:
        dealer_card_total = dealer_card_total_high_ace

    # If there hasn't been a return yet, compare card totals and determine a winner
    if player_card_total == dealer_card_total:
        print("Same card total. Push with card totals of {}".format(player_card_total))
        return 0

    elif player_card_total > dealer_card_total:
        print("Player wins with card total of {}.".format(player_card_total))
        return 1

    else:
        print("Dealer wins with card total of {}.".format(dealer_card_total))
        return 0


# def calculate_win_percentage():
#     tz = pytz.timezone('UTC')
#     now = datetime.datetime.now().astimezone(tz)
#     start_of_ctf = datetime.datetime(2023, 3, 24, 18).astimezone(tz)
#     num_hours_since_start = (now - start_of_ctf).total_seconds() / 3600  # number of hours since CTF has started
#     return_win_percentage = 60 - (num_hours_since_start * 0.5)  # percentage needed to win decreases with time, 0.5% an hour
#     return return_win_percentage


if __name__ == '__main__':

    total_games = 0
    # win_percentage = calculate_win_percentage()
    win_percentage = 0.52
    number_of_decks = 2
    print("The win percentage needed to complete this challenge is {}% over the period of 10000 games.".format(win_percentage * 100))
    print("\nThis challenge is just like the game blackjack (the American version) or 21 that you may have seen in a casino.")
    print("It is a simplified version of the game. You as the player can only hit or stand (no surrender, "
          "\ndouble-down, or splitting), and it only matters whether or not you win a hand against the dealer.")
    print("\nThere are {} decks in play. This information and the AI players are there to help you beat the dealer with "
          "\nall the information you have about what cards are facing up.".format(number_of_decks))
    print("The randomness of cards is seeded, so there may be a slight skew in the probably distribution of cards.")
    print("The dealer stands on an 18-21 and hits otherwise.")
    print("If you are dealt a blackjack (21) then the round plays itself with no input needed.")
    try:
        player_ready = input('\nWhen you are ready to play, type "ready"\n').lower().strip()
    except KeyboardInterrupt:
        sys.exit(0)

    if player_ready != "ready":
        print('Exiting program as you did not type "ready"')

    player_score = 0
    for game_number in range(10000):
        decks = deck_build(number_of_decks)

        player_score += game_engine()

        total_games += 1
        print("Player has won {} games out of {} total hands".format(player_score, total_games))
        print("That is a win percentage of {}%. You need {}% to get the flag.".format((player_score/total_games) * 100, win_percentage * 100))

    if (player_score/total_games) >= win_percentage:
        print("\nYou have beat the casino with a win percentage of {}%! Here is your flag:".format((player_score/total_games) * 100))
        print("UMASS{the-house-always-wins}")

    else:
        print("\nSadly you have not beat the casino on this attempt. You won {}% of games, and {}% of games won is "
              "required to beat this challenge.".format((player_score/total_games) * 100, win_percentage * 100))
