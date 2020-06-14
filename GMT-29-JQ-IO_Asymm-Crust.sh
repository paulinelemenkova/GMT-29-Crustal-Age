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

# Cut off raster image
grdcut asym.3.2.nc -R20/120/-65/30 -Gio_asym.tif

#
gdalinfo io_asym.tif -stats
#Minimum=0, Maximum=16000, Mean=0.197, StdDev=60.341
# Step-5. Make color palette
#gmt makecpt -Cbatlow -T8.000/1313.000 > ageerror.cpt
gmt makecpt -Cno_green -T14/10000 > asym.cpt
#gmt makecpt --help

# Step-1. Generate a file
ps=IO_Asym.ps
gmt grdimage io_asym.tif -Casym.cpt -R20/120/-65/30 -JQ5.0i -P -I+a15+ne0.75 -Xc -K > $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx204f10a10 -Bpyg20f10a10 -Bsxg5 -Bsyg5 \
    --MAP_TITLE_OFFSET=0.8c \
    -B+t"Asymmetries in crustal accretion (%) on conjugate ridge flanks: Indian Ocean" -O -K >> $ps
    
# Step-7. Add legend
gmt psscale -Dg0.0/-65+w12.0c/0.4c+v+o0.3/0i+ml -R20/120/-65/30 -J -Casym.cpt -W0.01 \
	--FONT_LABEL=7p,Helvetica,dimgray \
	--FONT_ANNOT_PRIMARY=6p,Helvetica,black \
	-Ba10f1+l"Color scale: no_green: [H=0, C=RGB]" \
	-I0.2 -By+l% -O -K >> $ps
    
# Step-10. Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=7p,Palatino-Roman,black \
    --MAP_TITLE_OFFSET=0.3c \
    -Tdx0.8c/10.3c+w0.3i+f2+l+o0.15i \
    -Lx11c/-1.3c+c50+w2000k+l"Cylindrical equidist. prj. Scale: km"+f \
    -UBL/-10p/-40p -O -K >> $ps

# Step-11. Add GMT logo
gmt logo -Dx5.2/-2.2+o0.1i/0.1i+w2c -O -K >> $ps

# Step-12. Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y6.7c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
-2.5 9.3 Age, spreading rates and spreading asymmetry of the ocean crust, 2 arc min netCDF grid Version 3
EOF

# Step-13. Convert to image file using GhostScript
gmt psconvert IO_Asym.ps -A0.5c -E720 -Tj -Z
