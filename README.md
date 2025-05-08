# Number Guessing Game 

## Project Overivew
This project implements a simple number guessing game using the Zybo Z7-10 FPGA board, a Pmod Keypad, and a Pmod Seven Segment Display (SSD). Each part of the project builds into the next, with Parts 1 to 3 serving as foundational steps. The early stages focus on capturing and displaying one or two hexadecimal digits from the keypad to the SSD. Part 3 introduces the single-digit version of the game, where a counter cycles through values 0 to F and stores a target number upon a button press. The user then attempts to guess the target using keypad input, with RGB LEDs providing hot/cold feedback—red for closer, blue for farther, and green flashing on a correct guess. Parts 4 and 5 form the main implementation of the game, extending functionality to two-digit input and allowing the user to switch between single- and double-digit modes using a hardware switch. Part 5 is an all-encompassing version of the project, bringing together all previous functionality into a complete and interactive game system.


### Part 1:

Get a one digit input (0-9, A-F) from the Keypad pmod and display it on the right digit of the Pmod Seven Segment Display (SSD).

### Part 2:

Get a two digits input (0-9, A-F) from the Keypad pmod.

Display input 1 on left display of Pmod Seven Segment Display.

Display input 2 on right display of Pmod Seven Segment Display.

 
### Part 3:

Create a 1 digit hot/cold number game.

Use push button 0 as the rest button. The user can press the reset button to clear the current hidden number and start the counter.

Create a roll back counter that count from 0 to F. The value of counter should increment every clock cycle and when it reaches to F it should roll back to 0 and continue. 

As soon as user presses push button 1 stop the counter and record the current number of the counter in a signal called target_number.

Get a single digit input from the user using the keypad and display it on the right Seven Segment Display.

Turn on Zybo Red RGB LED to inform the user the input is getting close to the target_number.

Turn on Zybo Blue RGB LED to inform the user the input is getting farther from the target_number.

Flash Zybo Green RGB LED 10 times to inform the user they have guessed the target_number.

Note: For the first guess always show Hot (turn on Red RGB). Future guesses will be calculated based on the first guess.

If user presses push button 3 display the target_number on the right display of SSD.

 
### Part 4:

Create a 2 digit hot/cold number game.

All the steps are similar to step 3, but this time accept 2 digits from the user. Reuse sections of Part 2.

 
### Part 5 :

Use Switch 0 to select between 1 digit or 2 digit game. If Switch 0 is at 0 position play 1 digit game. If switch is at 1 position play 2 digit game.

## Incomplete tasks
- Fix bugs
- Create Video Demo 
