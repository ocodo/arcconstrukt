#!/bin/bash

cd promo-web
scp index.html jasonm23@ocodo.info:ocodo.info/arcconstrukt/
cd images
for img in *.png 
do
   scp $img jasonm23@ocodo.info:ocodo.info/arcconstrukt/images/
done
cd ../..
