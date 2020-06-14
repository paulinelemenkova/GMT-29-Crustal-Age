#!/bin/sh
# Purpose: Age, spreading rates and spreading asymmetry of the ocean crust,
# 2 arc min netCDF grid Version 3 https://www.ngdc.noaa.gov/mgg/ocean_age/ocean_age_2008.html
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

# Step-2. GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TITLE_OFFSET=0.5c \
    MAP_ANNOT_OFFSET=0.1c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_GRID_PEN_PRIMARY=thin,white \
    MAP_GRID_PEN_SECONDARY=thinnest,white \
    FONT_TITLE=12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY=7p,Helvetica,dimgray \
    FONT_LABEL=7p,Helvetica,dimgray
#Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

# Cut off raster image
grdcut age.3.2.nc -R-90/25/-65/65 -Gao_age.tif

#
gdalinfo ao_age.tif -stats
#Minimum=0, Maximum=27891,
# Step-5. Make color palette
gmt makecpt -Cturbo -T0/27891 > age.cpt
# makecpt --help

# Step-1. Generate a file
ps=AO_Age.ps
gmt grdimage ao_age.tif -Cage.cpt -R-90/25/-65/65 -JPoly/4i -P -I+a15+ne0.75 -Xc -K > $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx20f10a20 -Bpyg20f10a10 -Bsxg10 -Bsyg10 \
    --MAP_TITLE_OFFSET=1.4c \
    -B+t"Age of Oceanic Lithosphere: Atlantic Ocean" -O -K >> $ps

# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=7p,Palatino-Roman,black \
    --MAP_TITLE_OFFSET=0.1c \
    --MAP_ANNOT_OFFSET=0.1c \
    -Lx7.8c/-3.7c+c50+w4000k+l"Polyconic prj. Scale: km"+f \
    -UBL/1.0c/-3.7c -O -K >> $ps

# Add color legend
gmt psscale -R -J -Cage.cpt\
    -DjBC+o0.0c/-3.0c+w8c/0.5c+h\
    --FONT_LABEL=7p,Palatino-Roman,dimgray \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,dimgray \
    --MAP_LABEL_OFFSET=0.1c \
    -Baf+l"Color scale: turbo (Google's Improved Rainbow Colormap for Visualization [C=RGB])" \
    -I0.2 -By+lm -O -K >> $ps

# Add GMT logo
gmt logo -Dx3.9/-2.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y6.7c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
1.5 9.3 Age of the ocean crust, 2 arc min grid V-3
EOF

# Step-13. Convert to image file using GhostScript
gmt psconvert AO_Age.ps -A1.5c -E720 -Tj -Z
