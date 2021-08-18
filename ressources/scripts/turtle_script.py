#! /usr/bin/python 

# https://pymotw.com/2/re/
# https://www.vipinajayakumar.com/parsing-text-with-python/
# set up regular expressions
# use https://regex101.com/

import re
import turtle
import Tkinter 
import time


rx_dict = {
    'right': re.compile(r'Tourne droite de (?P<right>\d+)'),
    'left': re.compile(r'Tourne gauche de (?P<left>\d+)'),
    'forward': re.compile(r'Avance (?P<forward>\d+)'),
    'backward': re.compile(r'Recule (?P<backward>\d+)'),
}


s = turtle.getscreen()
t = turtle.Turtle()
t.pensize(5)

def parse_line(line):
    for key, rx in rx_dict.items():
        match = rx.search(line)
        if match:
            return key, match
    return None, None

with open('turtle', 'r') as file:
    line = file.readline()
    while line:
        if line == "\n":
            print("NEW LIGNE")
            time.sleep(5)
            t.home()
            t.clear()
        else :
            key, match = parse_line(line)
            if key == 'right':
                range = int(match.group('right'))
                t.right(range)
                print("[RIGHT RANGE] = %d" % (range))
            if key == 'left':
                range = int(match.group('left'))
                t.left(range)
                print("[LEFT RANGE] = %d" % (range))
            if key == 'forward':
               range = int(match.group('forward'))
               t.forward(range)
               print("[FORWARD RANGE] = %d" % (range))
            if key == 'backward':
                range = int(match.group('backward'))
                t.backward(range)
                print("[BACK RANGE] = %d" % (range))
        line = file.readline()



time.sleep(10)
