"""
Mini Python game to guess the right price!
"""

__author__ = "judea_d"


import random


def Prix_juste():
    """Function for the game of The right price!"""
    print("\nHello. Welcome to the game, find the right price!\n")
    print(f"You have 10 attempts to find the number between {1} and {100}.\
 Guess !")

    num = random.randint(1, 100)
    ch = 10
    ten = 0

    while ten < ch:
        ten += 1
        try:
            guess = int(input('\nGuess the price !: '))
        except ValueError:
            print("Invalid input, enter a number !")
            ten -= 1
            continue

        if guess == num:
            print(f'✔ Correct! The number is : {num}. You succeeded in {ten}\
 attempts !')
            break

        elif ten >= ch and guess != num:
            print(f'✗ Miss! The number was : {num}. Too bad.')

        elif guess > num:
            print('Too high! Try lower.. ⬇ !')

        elif guess < num:
            print('Too low! Try higher.. ⬆ !')

    while True:
        replay = input("Do you want to play again (yes/no)? ? : ").strip().lower()
        if replay == "yes":
            Prix_juste()
        else:
            print("Thank you for playing. ♪♫*•♪")
            break


try:
    Prix_juste()
except KeyboardInterrupt:
    print("\nGame Over.")
