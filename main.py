
import sys

didgets = ["0",
           "1",
           "2",
           "3",
           "4",
           "5",
           "6",
           "7",
           "8",
           "9"]
f = open ("./tables/" + sys.argv[1] + ".txt", "r")
text = f.read()
f.close()

def rem_braces(string):
    if "(" not in string:
        return string
    else:
        return rem_braces(
            string[:string.index('(')-1] + 
            string[string.index(')')+1:])

text = rem_braces(text)

def rep_didgets(string):
    for didget in didgets:
        string = string.replace(didget, "\n")
    return string

text = rep_didgets(text)

f = open ("./tables/" + sys.argv[1] + ".txt", "w")
f.write(text)
f.close()
