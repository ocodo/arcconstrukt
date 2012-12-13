#!/bin/bash



    scp index.html jasonm23@ocodo.info:ocodo.info/arcconstrukt/
    scp tutorial.html jasonm23@ocodo.info:ocodo.info/arcconstrukt/
    scp tutorial.css jasonm23@ocodo.info:ocodo.info/arcconstrukt/
    scp twitter.arcmachine jasonm23@ocodo.info:ocodo.info/arcconstrukt/
    cd images
    for img in *.png 
    do
        scp $img jasonm23@ocodo.info:ocodo.info/arcconstrukt/images/
    done
    cd ../..
