#!/bin/bash
# SPDX-FileCopyrightText: 2023 Brian Woods
# SPDX-License-Identifier: GPL-2.0-or-later

OUTDIR=lossy_nearlossless_images

IN=" $( ls orig/*.png )"

mkdir -p "$OUTDIR"
for INFILE in $IN ; do
	for Z in {0..10} ; do
		NUM=$(( Z * 10 ))
		NUM_STR=$( printf "%03d\n" "$NUM" )
		cwebp \
			-mt \
			-near_lossless $NUM \
			-resize 1920 1080 \
			"$INFILE" \
			-o "$OUTDIR/$( basename -s .png $INFILE )-nl_$NUM_STR.webp"
	done
done
