
Fixing sudoers permission issue... "world writable"
1. chmod 440 /etc/sudoers.d/README 2>/dev/null
2. chmod 755 /etc/sudoers.d


Update syste
switch to: sudo su / root
1. sudo apt-get update
2. sudo apt-get clean
3. sudo apt-get autoremove
4. sudo apt-get upgrade    #if error then proceed further
5. sudo apt-get update --fix-missing
6. sudo apt-get upgrade     #if error then proceed further
7. apt clean
8. sudo apt update --allow-releaseinfo-change
9. sudo apt clean
10. sudo apt update --allow-releaseinfo-change
11. sudo apt-get upgrade  
