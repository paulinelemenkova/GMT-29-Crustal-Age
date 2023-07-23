#!/bin/sh
# Purpose: Age, spreading rates and spreading asymmetry of the ocean crust,
# 2 arc min netCDF grid Version 3 https://www.ngdc.noaa.gov/mgg/ocean_age/ocean_age_2008.html
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

# GMT set up
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

exec bash

# Cut off raster image
gmt grdcut age.3.2.nc -R-40/150/-70/-10 -Gker_age.tif

#
gdalinfo ker_age.tif -stats
# Minimum=0.000, Maximum=16001.000, Mean=5895.761, StdDev=4042.817
# Step-5. Make color palette
# gmt makecpt -Cjet -T14/16000.000 > age.cpt
gmt makecpt -Cwysiwyg -T14/16000.000 > age.cpt
#gmt makecpt --help

# Step-1. Generate a file
ps=Ker_age.ps
gmt grdimage ker_age.tif -Cage.cpt -R-25/-65/101/-10r -JA55/-50/7.5i -P -I+a15+ne0.75 -Xc -K > $ps

# Add grid
gmt psbasemap -R -J \
    -Bpxg10f5a10 -Bpyg10f5a15 -Bsxg5 -Bsyg5 \
    --MAP_TITLE_OFFSET=1.9c \
    --MAP_ANNOT_OFFSET=0.1c \
    --MAP_FRAME_AXES=wESN \
    --FONT_ANNOT_PRIMARY=10p,0,dimgray \
    --FONT_TITLE=13p,0,black \
    --FONT_LABEL=10p,0,black \
    -B+t"Age of Oceanic Lithosphere: Kerguelen Plateau and SW Indian Ocean" -O -K >> $ps
    
# Step-7. Add legend
gmt psscale -Dg-30/-58+w15.4c/0.4c+v+ml+e -R -J -Cage.cpt \
    --FONT_LABEL=10p,0,dimgray \
    --FONT_ANNOT_PRIMARY=10p,0,black \
    -Bg1000f200a1000+l"Color scale: 'wysiwyg' [R=0/6000, H=0, C=RGB]" \
    -I0.2 -By+l"M.Y." -O -K >> $ps
    
# Step-10. Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=10p,0,black \
    --MAP_TITLE_OFFSET=0.3c \
    -Tdx0.8c/10.3c+w0.3i+f2+l+o0.15i \
    -Lx16.0c/-1.7c+c318/-57+w2000k+l"Scale (km) at 55\232E 50\232S"+f \
    -UBL/-5p/-40p -O -K >> $ps

# Step-11. Add GMT logo
gmt logo -Dx5.5/-2.2+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y13.0c -N -O \
    -F+f12p,0,black+jLB >> $ps << EOF
0.0 5.9 Lambert Azimuthal Equal-Area projection. Central meridian 55\232E, standard parallel 50\232S
0.0. 6.6 Age of the ocean crust, 2 arc min netCDF grid v.3., according to adjacent seafloor isochrons
EOF

# Step-13. Convert to image file using GhostScript
gmt psconvert Ker_age.ps -A1.7c -E720 -Tj -Z
