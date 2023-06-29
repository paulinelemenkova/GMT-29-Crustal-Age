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
gmt grdcut ageerror.3.2.nc -R-40/150/-70/-10 -Gker_error.tif

#
gdalinfo ker_error.tif -stats
# Minimum=8.000, Maximum=1313.000, Mean=196.616, StdDev=156.744
# Step-5. Make color palette
# gmt makecpt -Cjet -T8/1313.000 > age.cpt
gmt makecpt -Cjet -T8/800.000 > age.cpt
gmt makecpt -Ccyan-magenta-yellow-white.cpt -T8/800.000 -N > age.cpt
# gmt makecpt -Cwind_17lev.cpt -T0/15000.000 -Ddimgray -N > age.cpt
# gmt makecpt -Cwgne15.cpt -T0/15000.000 -Ddimgray -N > age.cpt
# gmt makecpt -Cpercent_11lev.cpt -T0/15000.000 -Ddimgray -N > age.cpt
# gmt makecpt -Cf-30-31-32.cpt -T0/15000/250 -N -Iz > age.cpt
# gmt makecpt -Cmagma -T14/15000.000 > age.cpt
# gmt makecpt -Ccyclic -T0/15000/100 -Iz > age.cpt
# gmt makecpt -CTropical_Colors.cpt -T0/15000/100 > age.cpt
# gmt makecpt -Cradar_1.cpt -T0/15000 > age.cpt
# gmt makecpt -Ccyclic -T8/1313 > age.cpt
# gmt makecpt -Ccool -T8/1313 > age.cpt
# gmt makecpt --help

# Step-1. Generate a file
ps=Ker_error.ps
gmt grdimage ker_error.tif -Cage.cpt -R-25/-65/101/-10r -JA55/-50/7.5i -P -I+a15+ne0.75 -Xc -K > $ps

# Add grid
gmt psbasemap -R -J \
    -Bpxg10f5a10 -Bpyg10f5a10 -Bsxg5 -Bsyg5 \
    --MAP_TITLE_OFFSET=1.9c \
    --MAP_ANNOT_OFFSET=0.1c \
    --MAP_FRAME_AXES=wESN \
    --FONT_ANNOT_PRIMARY=10p,0,dimgray \
    --FONT_TITLE=13p,0,black \
    --FONT_LABEL=10p,0,black \
    -B+t"Crustal Age Uncertainty of the Oceanic Lithosphere in Kerguelen Plateau and SW Indian Ocean" -O -K >> $ps

# gmt psxy -R -J ridge.gmt -Sf0.5c/0.15c+l+t -Wthin,yellow -Gpurple -O -K >> $ps
gmt psxy -R -J TP_Indian.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_Australian.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_African.txt -L -Wthickest,red -O -K >> $ps
# tectonic slab contours
# gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,slateblue3 -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,darkmagenta -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,darkmagenta -O -K >> $ps
#
# transform faults
gmt psxy -R -J transform.gmt -Sc0.05c -Ggreen -Wthick,deeppink1 -O -K >> $ps

    
# Step-7. Add legend
gmt psscale -Dg-30/-58+w15.4c/0.4c+v+ml+e -R -J -Cage.cpt \
    --FONT_LABEL=10p,0,dimgray \
    --FONT_ANNOT_PRIMARY=10p,0,black \
    -Bg100f20a100+l"Color scale: 'jet' [R=0/15000, H=0, C=RGB]" \
    -I0.2 -By+l"m/yr." -O -K >> $ps
    
# Step-10. Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=10p,0,black \
    --MAP_TITLE_OFFSET=0.3c \
    -Tdx0.8c/10.3c+w0.3i+f2+l+o0.15i \
    -Lx16.0c/-1.6c+c318/-57+w2000k+l"Scale (km) at 55\232E 50\232S"+f \
    -UBL/-5p/-40p -O -K >> $ps

# Step-11. Add GMT logo
gmt logo -Dx5.5/-2.2+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y13.0c -N -O \
    -F+f12p,0,black+jLB >> $ps << EOF
0.0 5.9 Lambert Azimuthal Equal-Area projection. Central meridian 55\232E, standard parallel 50\232S
0.0. 6.6 Global Seafloor Fabric and Magnetic Lineation Data (GSFML) are shown by cyan lines
EOF

# Step-13. Convert to image file using GhostScript
gmt psconvert Ker_error.ps -A1.7c -E720 -Tj -Z
