# IDS demo

Intrusion Detection Software (IDS) demo to demonstrate basic bash scripting abilities.

running main.sh creates:
- `demo/` directory
- child directories and files within `demo/` for demo
- authen file for the inital file system state (without `-a` flag this file is hidden)
- if `-a` flag is present authen file name will be defined by user text following the `-a` flag
- if `-o` flag is stated and output file is also created with the name following the `-o` flag

## run 
`./main.sh`

## what will happen after running script?

1. the program creates `demo/` directory and saves the initial state you will be prompted to see what is in the directory aswell
2. user will be prompted to make changes to the `demo/` and enter *y* when completed
3. the program checks inital `demo/` directory against the new changed directory
4. user prompted if they made these changes to the `demo/` directory or not
5. if the user anwsers yes the file state saved is updated with the changed state if no the program prints "this system has been compromised"


should be compatiable with most linux distributions tested on ubuntu and raspbian buster.

