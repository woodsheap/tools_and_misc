# webp scripts
## lossless_z_gen_\* scripts
Create images with various compression levels and see how that effects
image size.  Has both a bash script to generate the images and an GNU
octave script to generate the graph.
## lossy_nearlossless_gen_\* scipts
Much like the one but varies the nearlossless preprocessing level.  This
just shows the file size but you need to look at the files because since
it's lossy there will be visual compression artifacts.
## Makefiles
Just make files to convert directories of on going work PNGs to webps.
There's a makefile for a single output and dual outputs for both a high
and low quality compression settings.
