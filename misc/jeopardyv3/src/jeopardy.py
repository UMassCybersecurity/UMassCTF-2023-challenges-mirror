import sys
import time
import os
# import signal
# import subprocess
import spacy


def jailbreakattempt(allowedchars):
    print('Input whatever you wish to try to break out of this game with in the following input.')
    print('Here are the characters you are allowed to use: {}'.format(str(sorted(allowedchars))[1:-1]))
    try:
        text = input('>>> ')
    except KeyboardInterrupt:
        # print('\n I GOTCHA BITCH')
        sys.exit(0)
    for char in text:
        # print(char)
        # print(allowedchars)
        if char not in allowedchars:
            print('You entered a character you are not allowed to use. Go answer more questions or rerun the game.')
            return
    try:
        exec(text)
    except:
        print('Your input threw an exception. Try something different.')


def displaygb(gameboardboolean):
    gbheader = """
    ------------------------------------------------- JeopardyV3! ---------------------------------------------------
      Cyprus:   Too Recent For ChatGPT:   The Curse of Oak Island (The TV Show):   Miscellaneous:   UMassCTF History:   
    """
    gbqs = [
        ['', '', '', '', ''],
        ['', '', '', '', ''],
        ['', '', '', '', ''],
        ['', '', '', '', ''],
        ['', '', '', '', '']
    ]

    gbqsprinted = ""

    for i in range(5):
        for j in range(5):
            if j == 0 and i == 0:
                gbqsprinted += "    "
            elif j == 0:
                gbqsprinted += "        "
            elif j == 1:
                gbqsprinted += "               "
            elif j == 2:
                gbqsprinted += "                             "
            elif j == 3:
                gbqsprinted += "                           "
            elif j == 4:
                gbqsprinted += "                "
            if gameboardboolean[i][j]['answered'] is False:
                gbqs[i][j] = gameboardboolean[i][j]['points']
                gbqsprinted += str(gameboardboolean[i][j]['points'])
            else:
                gbqsprinted += "   "
        gbqsprinted += '\n'

    print(gbheader + gbqsprinted)


def main():
    allowedchars = [' ']

    # allowedchars = [chr(i) for i in range(128)]

    a1 = {'chars': ['('], 'points': 100,
          'question': 'What is the tradition considered to be one the most dangerous on the island, centered around a major Christian holiday in April? (Answer in the Cypriot term)',
          'answer': ['foustanelia'],
          'answered': False}
    a2 = {'chars': ['{'], 'points': 200,
          'question': 'What car manufacturer do taxi drivers predominantly use for their cars on the island?',
          'answer': ['Mercedes-Benz', 'Mercedes', 'Mercedes Benz'], 'answered': False}
    a3 = {'chars': ['}', 't'], 'points': 300,
          'question': 'There lies a site near one of the cities in Cyprus that has had many of the artifacts unearthed here be the pieces of a founding collection of the Metropolitan Museum of Art in New York City. What is this place?',
          'answer': ['Tombs of the Kings'], 'answered': False}
    a4 = {'chars': ['x', 's'], 'points': 400,
          'question': 'One of the student residences very close to the largest university by enrollment in Cyprus has this on its twelfth floor',
          'answer': ['pool', 'a pool'], 'answered': False}
    a5 = {'chars': ['u', 'v'], 'points': 500,
          'question': 'Near one of the oldest trees on the island lies a holy site that belonged to a saint. What shape is the inside of this site in?',
          'answer': ['Horseshoe'], 'answered': False}

    b1 = {'chars': [':'], 'points': 100,
          'question': 'The country who won the 2022 FIFA World Cup received a special gift from an American company, that wasn\'t allowed to sell their products at the World Cup, that allowed all residents of the winning country to receive three free ____ per day',
          'answer': ['Beers'], 'answered': False}
    b2 = {'chars': [')'], 'points': 200,
          'question': 'A person from Massachusetts murdered their significant other on a holiday a few months ago. Before this, the murderer had three federal charges related to forging paintings from what famous artist?',
          'answer': ['Andy Warhol'], 'answered': False}
    b3 = {'chars': ['+', 'g'], 'points': 300,
          'question': 'What online platform had sellers questioning whether or not they would be paid for products already sold thanks to a very recent bank failure?',
          'answer': ['Etsy'], 'answered': False}
    b4 = {'chars': ['_', '<'], 'points': 400,
          'question': 'What company had a 25% raise in their maximum price of items in 2022?',
          'answer': ['Dollar Tree'], 'answered': False}
    b5 = {'chars': ['p', 'q'], 'points': 500,
          'question': 'Name of the man who killed some of his own family members in cold blood that finished off a recent Netflix documentary about said killings by saying "Netflix isn\'t making a documentary about this, are they?"',
          'answer': ['Alex Murdaugh'], 'answered': False}

    c1 = {'chars': ['%'], 'points': 100,
          'question': 'What was the cross made of that was found by metal detection in season five that was one of the largest finds of the respective season?',
          'answer': ['Lead'], 'answered': False}
    c2 = {'chars': ['.', 'w'], 'points': 200,
          'question': 'What is widely considered the most beloved phrase on the show that is commonly said by the metal detection expert?',
          'answer': ['Bobby dazzler', 'holy shamoley it\'s a bobby dazzler'], 'answered': False}
    c3 = {'chars': ['c', 'j'], 'points': 300,
          'question': 'Who was the person that provided the Lagina brothers with a map that outlined La Isle des Chene?',
          'answer': ['Zena Halpern'], 'answered': False}
    c4 = {'chars': ['1', 'i'], 'points': 400,
          'question': 'Who is the second generation land owner on the island that is featured frequently in the show with references to his father?',
          'answer': ['Tom Nolan', 'nolan'], 'answered': False}
    c5 = {'chars': ['k', 'l', 'f'], 'points': 500,
          'question': 'What shaft has been the largest focus of the newest season of the show, and has allowed the cast to walk inside a shaft made on the island for the first time?',
          'answer': ['The Garden Shaft', 'garden shaft'], 'answered': False}

    d1 = {'chars': ["'"], 'points': 100,
          'question': 'One of the most well-known athletic events of the year, symbolized by a mythical creature, starts in what Greater Boston town?',
          'answer': ['Hopkinton'], 'answered': False}
    d2 = {'chars': ['e'], 'points': 200,
          'question': 'A well know New York Times journalist stated in a recent documentary that he believed three passengers from this country on flight MH370 hijacked the plane.',
          'answer': ['Russia'], 'answered': False}
    d3 = {'chars': ['['], 'points': 300,
          'question': 'This most famous capitalistic board game didn\'t originally have the name that everyone knows it by today. What was the original name?',
          'answer': ['The Landlord\'s Game', 'Landlord\'s Game'], 'answered': False}
    d4 = {'chars': [']', 'm'], 'points': 400,
          'question': 'A famous mobster, who was once an inmate at Alcatraz, had a brother who held what position in the University of Massachusetts system?',
          'answer': ['President', 'The President'], 'answered': False}
    d5 = {'chars': ['n', 'o'], 'points': 500,
          'question': 'A company that combines two animals to make its name from the United States sells a trendy item that you can\'t take off and claims to be the original maker of said item. What is this item?',
          'answer': ['Forever bracelet'], 'answered': False}

    e1 = {'chars': ['`', 'a'], 'points': 100,
          'question': 'What country was the team that placed 10th in last year\'s UMassCTF from?',
          'answer': ['Indonesia'], 'answered': False}
    e2 = {'chars': ['r'], 'points': 200,
          'question': 'Official alternate name / nickname for the team that is hosting this current UMassCTF and has hosted previous UMassCTFs?',
          'answer': ['George H. W. BuSHH', 'george h.w. bussh', 'george h.w. bushh'], 'answered': False}
    e3 = {'chars': ['h'], 'points': 300, 'question': 'What was the date of the first ever UMassCTF kickoff?',
          'answer': ['October 5, 2020', '10/5/20', 'october 5 2020', 'october fifth twenty twenty', 'october fifth 2020', '5/10/20'], 'answered': False}
    e4 = {'chars': [',', '~', 'd'], 'points': 400,
          'question': 'What non-profit group did the UMass Cybersecurity Club use to be under as an interest group? (Answer the parent group\'s name)',
          'answer': ['ACM', 'Association for Computing Machinery'], 'answered': False}
    e5 = {'chars': ['b', 'y', 'z'], 'points': 500,
          'question': 'There was a question that appeared in both of the previous year\'s versions of this challenge (2021 and 2022) that had an answer that was an incoherent string of letters and numbers (it was the same answer both years). Another hint: in one of the previous years, the question had a strange point value that deviates from the normal jeopardy board. The answer to these duplicated questions comes from a video. What is the title of this video?',
          'answer': ['Tuning a Web Application Firewall, IaaS, and More with Oracle'], 'answered': False}

    gameboardboolean = [
        [a1, b1, c1, d1, e1],
        [a2, b2, c2, d2, e2],
        [a3, b3, c3, d3, e3],
        [a4, b4, c4, d4, e4],
        [a5, b5, c5, d5, e5]
    ]

    displaygb(gameboardboolean)

    print('Type "ready" when you are ready to play!')
    try:
        userready = input()
    except KeyboardInterrupt:
        sys.exit(0)
    if userready != 'ready':
        print('Terminating program.')
        sys.exit(0)

    totalquestions = 25
    exitprogram = 0
    while totalquestions >= 1:
        # try:
        print(
            '\nPick a category and dollar amount in the format of "category dollar amount" with no dollar sign from the board below')
        print('or type "jailbreak" to attempt to breakout of the game.')
        displaygb(gameboardboolean)
        try:
            questionpick = input().lower()
        except KeyboardInterrupt:
            sys.exit(0)
        if questionpick == 'exit':
            print('Terminating program now')
            exitprogram = 1
            break
        if questionpick == 'jailbreak':
            jailbreakattempt(allowedchars)
            print("\nYou are back in the game loop. I hope it wasn't too easy...")
            continue
        if len(questionpick.split(" ")) < 2 or not questionpick.split(" ")[-1].isdigit():
            print('Please provide a category and dollar amount')
            continue
        category = ""
        for i in questionpick.split(" ")[0:-1]:
            category += i + " "
        category = category[0:-1].lower()
        dollaramount = questionpick.split(" ")[-1]
        if int(dollaramount) != 100 and int(dollaramount) != 200 and int(dollaramount) != 300 and int(
                dollaramount) != 400 and int(dollaramount) != 500 and int(dollaramount) != 10000:
            print('Provide a valid dollar amount')
            continue
        arrayrow = int((int(questionpick.split(" ")[-1]) / 100) - 1)
        if category == 'cyprus':
            currentquestion = gameboardboolean[arrayrow][0]
        elif category == 'too recent for chatgpt':
            currentquestion = gameboardboolean[arrayrow][1]
        elif category == 'the curse of oak island' or category == 'the curse of oak island (the tv show)':
            currentquestion = gameboardboolean[arrayrow][2]
        elif category == 'miscellaneous':
            currentquestion = gameboardboolean[arrayrow][3]
        elif category == 'umassctf history':
            currentquestion = gameboardboolean[arrayrow][4]
        else:
            print('Not a valid category.')
            continue

        if currentquestion['answered'] is True:
            print('That question has already been answered.')
            continue
        else:
            print(currentquestion['question'])
            print('Your answer:')
            try:
                useranswer = input()
            except KeyboardInterrupt:
                sys.exit(0)
            currentquestion['answered'] = True
            doc1 = nlp(u'{}'.format(str(useranswer).lower()))
            max_similarity = 0
            for answer in currentquestion['answer']:
                doc2 = nlp(u'{}'.format(answer.lower()))
                current_similarity = doc1.similarity(doc2)
                if current_similarity > max_similarity:
                    max_similarity = current_similarity
                # print(doc1.similarity(doc2))
            # if str(useranswer).lower() in currentquestion['answer']:
            if max_similarity >= 0.8:
                print('Correct! You have been awarded the following characters: {}'.format(
                    str(currentquestion['chars'])[1:-1]))
                for i in currentquestion['chars']:
                    allowedchars.append(i)
            else:
                print('No, sorry. If you wish to try again you will have to restart the game entirely.')
            totalquestions -= 1
            time.sleep(2)

    if exitprogram != 1:
        print(
            'You have now attempted to answer all the questions. You can either exit this game by typing "exit" or continually attempt to jailbreak.')
        while True:
            # try:
            try:
                finished = input()
            except KeyboardInterrupt:
                sys.exit(0)
            if finished == 'jailbreak':
                jailbreakattempt(allowedchars)
            elif finished == 'exit':
                print('Exiting now')
                break
            else:
                print('Invalid argument passed. Either type "jailbreak" or restart the game.')


def saveourmoney(signum, frame):
    try:
        if input("\nQuit jeopardy? (y/n)> ").lower().startswith('n'):
            sys.exit(0)

    except KeyboardInterrupt:
        print("\nQuitting now...")
        sys.exit(0)


if __name__ == '__main__':
    print(
        'Welcome to python jail-pardy! Each correctly answered question grants you characters which you can use try to break out of this game with to get the flag.')
    print('When you answer a question correctly, the game will tell you which characters have been unlocked.')
    print('To attempt to breakout, instead of picking a question, type the word "jailbreak" instead.')
    # signal.signal(signal.SIGINT, saveourmoney)
    # signal.signal(signal.SIGTERM, saveourmoney)
    nlp = spacy.load("en_core_web_md")
    main()
