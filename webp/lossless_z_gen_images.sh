#!/bin/bash
# SPDX-FileCopyrightText: 2023 Brian Woods
# SPDX-License-Identifier: GPL-2.0-or-later

OUTDIR=lossless_z_images

IN=" $( ls orig/*.png )"

mkdir -p "$OUTDIR"
for INFILE in $IN ; do
	# z range 0 to 9
	for Z in {0..9} ; do
		cwebp \
			-lossless \
			 -z $Z \
			-resize 1920 1080 \
			"$INFILE" \
			-o "$OUTDIR/$( basename -s .png $INFILE )-z_$Z.webp"
	done
done
