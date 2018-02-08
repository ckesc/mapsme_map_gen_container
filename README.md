Docker containers for generating [Maps.me](http://github.com/mapsme/omim) maps

# convert2mwm
Container for converting pbf and other formats into mwm file format (special format for Maps.me)

You can take built container here https://hub.docker.com/r/ckesc/omim-convert2mwm/

## What container do:
1. Build whole maps.me repo
2. Call tool `omim/tools/unix/generate_mwm.sh`

## How to use
0. Download pbf file from somewhere. For example http://gis-lab.info
0. Rename it like maps.me official map file. For example `Russia_Moscow.osm.pbf`
1. Place your pbf file in current directory.
2. Run
```bash
docker run --rm -u $(id -u):$(id -g) -v $PWD:/srv/data ckesc/omim-convert2mwm:release-76 Russia_Moscow.osm.pbf
```
Replace `release-76` with actual branch (tag in docker terminology)  
Replace `Russia_Moscow.osm.pbf` with your pbf file. File should be in current directory. Absolute path won't work here.  

After ~hour you got ready to use mwm file.  
In current directory will be created temporary files.

You can place result files into your phone instead of current map file. [See how](#how-to-upload-mwm-to-device)
### Note: 
- Routing between 2 maps won't work if your pbf borders doesn't match borders in https://github.com/mapsme/omim/tree/master/data/borders

# make_maps
Container for automative build of maps.me maps.

## What container do:
1. Only on first run: Downloads whole Russia pbf file from https://gis-lab.info (~ 2.2 Gb)
2. Only on first run: Crops regions into separate small pbf files with data from `data/borders`
3. Downloaded pbf always in past. So script updates it with pach via `osmupdate`
4. Calls `generate_mwm.sh` (like in `convert2mwm`)  to convert maps

## How to use:
1. Make `data/borders` dir. Download some border files from https://github.com/mapsme/omim/tree/master/data/borders
2. Make sure that you have > 3 Gb free space. Russia file now have size 2.2 Gb + generated files take some place.
3. Run 
```bash
docker run -v /opt/teamcity_agent_osm/data:/srv/data/ ckesc/omim-make-maps:release-76
```
Replace `release-76` with actual branch (tag in docker terminology)  

# How to upload mwm to device
You can read [official documentation here](https://support.maps.me/hc/en-us/articles/208458855-Where-does-MAPS-ME-store-downloaded-maps-and-my-bookmarks-)

Tips:
- File name should match current map file. For example `Russia_Moscow` instead of just `Moscow`
- You should place file into `/sdcard/Mapswithme/17xxxx` where `17xxxx` is date of current official maps.

