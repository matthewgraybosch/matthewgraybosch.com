#!/usr/bin/env bash

# commonplace.sh
# © 2021 Matthew Graybosch <contact@matthewgraybosch.com>
# Available under the GNU General Public License v3.0

VISUAL=/usr/bin/emacs
DIRECTORY=collections/_commonplace/
FILENAME=$(date +'%s').md
TIMESTAMP=$(date +'%F %T %z')

mkdir -p ${DIRECTORY}

echo "---
layout: commonplace
title: Commonplace Book
description: An entry in my commonplace book
date: ${TIMESTAMP}
unixtime: $(date +'%s')
---
" > ${DIRECTORY}${FILENAME}

$VISUAL ${DIRECTORY}${FILENAME}
