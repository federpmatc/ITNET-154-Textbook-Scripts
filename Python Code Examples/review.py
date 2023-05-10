x = 5
y = 10
#print function
print('hello')
#We can use the format method of strings
print('The value of x is {} and y is {}'.format(x,y))
print('The value of x is {1} and y is {0}'.format(x,y))

from datetime import datetime,date
#Import the datetime and date classes from the datetime module

# get the current date and time
now = datetime.now() #use the now() method to create a datetime object
print(type(now))
print(type(x))
print(now)

# get current date using the today method of date class
current_date = date.today()
print(current_date)
print(current_date.day)
print("The current day is {} and the year is {}".format(current_date.day,current_date.year))

# current date and time
now = datetime.now()

#Use the strftime method of the datetime class with format codes
#to create a string with the current date, time, etc
t = now.strftime("%H:%M:%S")
print("Time:", t)

s1 = now.strftime("%m/%d/%Y, %H:%M:%S")
# mm/dd/YY H:M:S format
print("s1:" + s1)

s2 = now.strftime("%d/%m/%Y, %H:%M:%S")
# dd/mm/YY H:M:S format
print("s2:", s2)

#Brief Tour of Standard Library
#https://docs.python.org/3/tutorial/stdlib.html
import os #import the os module
print(os.getcwd() ) # Return the current working directory
#os.system('mkdir today') # Run the command mkdir in the system shell

import random
rand = random.choice(['apple', 'pear', 'banana'])
print(rand)
print(random.randrange(100))

#lists
#https://www.programiz.com/python-programming/list
# A list with 3 integers
numbers = [1, 2, 5]
print(type(numbers))
print(numbers)  # Output: [1, 2, 5]
# empty list
my_list = []
# list with mixed data types
my_list = [1, "Hello", 3.4]
#accesssed with index
print(my_list[0])
#append method
my_list.append(100)
print(my_list)
#Note there is a remove method
my_list.remove('Hello')
print(my_list)
#length function
print(len(my_list))

#What does this do??
numbers = []
for x in range(1, 6):
    numbers.append(x * x)
print(numbers)

#list slicing.  The first number is inclusive, second is exclusive
#access elements of a list
my_list = ['p','r','o','g','r','a','m','i','z']
# items from index 2 to index 4
print(my_list[2:5])
# items from index 5 to end
print(my_list[5:])
# items beginning to end
print(my_list[:])

#tuples are immutable
#should be faster, because they don't change
languages = ('Python', 'Swift', 'C++') #define tuple with ()
# iterating through the tuple
for language in languages:
    print(language)
#languages[0] = "Change me"   #genereate an error

#Dictionaries
student_id = {111: "Eric", 112: "Kyle", 113: "Butters"}

print(student_id[111])  # prints Eric
print(student_id[113])  # prints Butters

#Add key/value pair
student_id[755] ="Feder"
print(student_id)

student_id2 = {111: "Eric", 113: "Butters"}
classes = [] #create a list
classes.append(student_id) #add dictionary of key/value pairs
classes.append(student_id2) #add dictionary of key/value pairs
print(classes)

#Finally try some kind of automation
#https://youtu.be/vEQ8CXFWLZU


