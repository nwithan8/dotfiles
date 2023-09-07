#!/bin/sh

# Ref: https://gist.github.com/mihow/9c7f559807069a03e302605691f85572?permalink_comment_id=4623051#gistcomment-4623051

## Usage:
##   . ./export-env.sh $FILE
##   . ./export-env.sh .env

ENV_FILE=$1

eval export $(cat $ENV_FILE)
