#!/bin/bash

if [ -e tutorial.markdown ] && [ -e t.head ] && [ -e t.foot ]; then
#    gem install redcarpet
    redcarpet --render-with_toc_data tutorial.markdown > tmp
    cat t.head tmp t.foot > ../../webroot/tutorial.html
    rm tmp
    open -a Chromium ../../webroot/tutorial.html
else
    echo "Run this from the tutorial folder" 
fi

