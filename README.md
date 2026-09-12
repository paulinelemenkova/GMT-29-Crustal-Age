# GMT Crustal Age — Oceanic Lithosphere Age and Seafloor Spreading Mapping Scripts

A collection of GMT (Generic Mapping Tools) shell scripts for mapping the age and spreading history of the oceanic crust over ocean basins. From a global ocean crustal-age grid the scripts render the age of oceanic lithosphere, seafloor-spreading half-rates, spreading asymmetry and age uncertainty. The scripts have been used to generate map figures across the author's marine-geophysical and cartographic publications.

## What the scripts do

Each script builds a complete crustal-property map, typically chaining:

- grid clipping and subsetting (grdcut) over a study-area bounding box
- colour palette generation (makecpt, turbo scheme) scaled to the property range
- grid rendering with illumination (grdimage)
- contours where used (grdcontour)
- coastlines and frames (pscoast)
- colour scale bars (psscale), grids, frames, scale bars and roses (psbasemap)
- annotations and subtitles (pstext), GMT logo (logo)
- export to raster (psconvert) at high resolution

## Mapped quantities

- Age of oceanic lithosphere (Myr)
- Seafloor-spreading half-rates
- Spreading asymmetry
- Crustal-age uncertainty (age error)

## Data sources

Global age, spreading-rate and asymmetry grids of the ocean crust from NOAA/NGDC (Muller et al., 2-arc-minute grid, Version 3). Coastlines from GSHHG via GMT.

## File naming

Scripts follow GMT-29-...-basin_Property.sh, where the basin tag is an ocean or region (e.g. IO = Indian Ocean, AO = Atlantic Ocean, AS = Arabian Sea, Ker = Kerguelen) and the property is Crustal_Age, Spread_Half_Rate, Asymm-Crust or age_error.

## Requirements

- GMT 6.x (Generic Mapping Tools): https://www.generic-mapping-tools.org
- A POSIX shell (bash/sh)
- The NOAA/NGDC ocean crustal-age grid(s) available locally
- GDAL (optional) for grid statistics (gdalinfo)

## Usage

Place the required age / spreading grid in the working directory, adjust the -R region and -J projection at the top of the chosen script, then run:

    bash "GMT-29-JQ-IO_Crustal Age.sh"

The script writes a PostScript file and converts it to a raster image (JPG/PNG) via psconvert.

## Author and citation

Polina Lemenkova
ORCID: https://orcid.org/0000-0002-5759-1089

These scripts accompany figures in the author's marine-geophysical and cartographic papers; please cite the specific article a given map appears in. The full publication list is available via the ORCID record above.

## License

See the LICENSE file in this repository.
