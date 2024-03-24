# 0 - imports
from openai import OpenAI
import sys
api_key = "OPENAI_API_KEY"
client = OpenAI()

# 1 - definition of basic info
# 1.1 - Name
def name_exit():
    name = input("Dear player, be welcome to this DnD, are you prepared to live the adventure? if yes, choose your name, if no, type exit\n")
    if name == "exit":
        print("Exiting the game")
        sys.exit()
    # else:
    #     print(f"Good decision, your name is {name}")
    return name

# 1.2 - Hero_class
def class_choose():
    while True:
        hero_class = int(input("Choose your hero class: Warrior | Mage | Hunter, type 1 for Warrior, 2 for Mage, 3 for Hunter\n"))
        if hero_class in (1, 2, 3):
            break
    if hero_class == 1:
        hero_class = "Warrior"
    elif hero_class == 2:
        hero_class = "Mage"
    elif hero_class == 3:
        hero_class = "Hunter"
    # print(f"Your class for this DnD is {hero_class}")
    return hero_class

# 1.3 - Story generator
def generate_story():
    completion = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[
            {"role": "system", "content": "You are dungeon and dragons game master who creates the story for the player, context is the ancient age with castles, swords shields and so on, limit your output to 100 tokens but tell the whole intro with the question what will hero do next, always use name and hero_class given by user, always put the 'Dungeon Master:' at the beginning of your generated message, never refer to player as the user"},
            {"role": "user", "content": f"Based on the given inputs: {name}, {hero_class} create initial story for beginning of the DnD quest for example(do not create necessarily this exact story): Long ago, in a distant land, mighty {hero_class} named {name} lost his family to opressor Razan and promised to defeat him once! You find yourself on your family farm standing above your dead wife and kid, what will you do>?"},
            {"role": "assistant", "content": ""},
        ]
    )
    print(completion.choices[0].message.content)

# 1.3 - Generate dialogue
def dialogue_step():
    user_input_f = str(input())
    completion = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[
            {"role": "system", "content": "You are dungeon and dragons game master who creates the story for the player, context is the ancient age with castles, swords shields and so on, limit your output to 100 tokens, the story is already in progress,the user gives you input and you base next story on that input and always finish with choice, example: There are 2 doors, will you go left or right doors?. always put the 'Dungeon Master:' at the beginning of your generated message, advance the story slowly, not instantly jumping to kill the main willain,never refer to player as the user "},
            {"role": "user", "content": user_input_f},
            {"role": "assistant", "content":""},
        ]
    )
    story_content_f = completion.choices[0].message.content
    print(story_content_f)
    return story_content_f, user_input_f

# -------------------------------------------------------------

# STORY
name = name_exit() 
hero_class = class_choose()
print(f"Your name is {name} and your class is {hero_class}, lets get into the story:\n (whenever you want to exit the story, write 'exit')")

generate_story()

while True:
    story_content, user_input = dialogue_step()
    user_input = dialogue_step()
    if user_input == "exit" or "EXIT":
        break



# Upgrades to be done
# - Add system content as sum of all strings napr: comm_1 = generate story

