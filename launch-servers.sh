#!/bin/bash

# Open terminal using xfce4-terminal and run paper busty server
xfce4-terminal --working-directory="/home/cyber/Desktop/paper_server" --title="paper server" --hold --command="
    
    #Find and run jar file inside the new terminal
    bash -c 'java -Xms1G -Xmx6G -jar *.jar --nogui #; exec bash (stops relaunch popup)'
" &

# Open a second terminal and run server
xfce4-terminal --working-directory="/home/cyber/Desktop/fresh_server" --title="fresh server" --hold --command="
    
    #Find and run jar file inside the new terminal
    bash -c 'java -Xms1G -Xmx6G -jar *.jar --nogui #; exec bash'
" &

:<<'COMMENT'
# Open a third terminal for cisco-rpg server
xfce4-terminal --working-directory="/home/cyber/Desktop/cisco_rpg" --title="cisco server" --hold --command="
    sudo bash start.sh
    exec bash
" &
COMMENT

# Wait 5 seconds to allow the terminals to open
sleep 5

# Arrange terminal windows gravity,x,y,w,h
wmctrl -r "paper server" -e 0,0,15,955,540
wmctrl -r "fresh server" -e 0,980,15,960,540
#wmctrl -r "cisco server" -e 0,980,15,960,540

# Close the parent terminal
exit 0
