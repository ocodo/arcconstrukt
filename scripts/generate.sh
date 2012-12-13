#!/bin/zsh --login


if [ -e tutorial.markdown ] && [ -e t.head ] && [ -e t.foot ]; then
#    gem install redcarpet
    redcarpet --render-with_toc_data tutorial.markdown > t.html
    cat t.head t.html t.foot > tutorial.html
    open -a Chromium tutorial.html    
else
    echo "Run this from the tutorial folder" 
fi






