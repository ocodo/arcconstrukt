#!/bin/bash

if [ -e tutorial.markdown ] && [ -e t.head ] && [ -e t.foot ]; then
#    gem install redcarpet
    redcarpet --render-with_toc_data tutorial.markdown > tmp

    grep toc tmp | 
    tr '<>/="' ' ' | 
    sed -e 's/h[21]//g' -e 's/ id //g' -e 's/.*toc/toc/' | 
    awk '{ 
          link=$1; 
          $1=""; 
          title=$0; 
          printf "<option value=\"#%s\">%s</option>\n", link, title 
    }' |
    sed '$d' > toc

    cat t.head toc t.select-close tmp t.foot > ../../webroot/tutorial.html
    rm tmp toc

    open -a Chromium ../../webroot/tutorial.html
else
    echo "Run this from the tutorial folder" 
fi

