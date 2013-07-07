## QNN Agent Websites

This repo contains Jekyll config files of each QNN agent website (more than 80 websites) and several shell script files.

Default configurations and template source code:  
[Templates](https://github.com/qnn/template)

### Build

Build Jekyll sites with source file from ``source`` directory and config file from ``configs`` directory. This script may update the main and the source repo before asking you which website list file to read and how many sites to build concurrently.

    bash build.sh [DIR1[ DIR2[ ...]]]

To build all sites in WEBSITES:

    bash build.sh --all

### Default configs for websites

Use this bash script to copy sample config file ``sample_config.yml`` to each sub site directory. All generated config files will be in the ``configs`` directory. Configs in these files will override [those](https://github.com/qnn/template/blob/master/_config.yml) on default template.

Generate for only new sites. Make sure target directories and files do not exist before executing this script. This script may ask you which website list file to read.

    bash generate_default_configs.sh [DIR1[ DIR2[ ...]]]

### Default nginx configs

Use this script to generate nginx configs. This script may ask you which website list file to read and where to save the config file.

    bash generate_nginx_configs.sh [DIR1[ DIR2[ ...]]]

### Check Websites

Check if each website returns 200 status code in 10-second timeout. You may need curl 7.29.0+ to display the IP addresses.

    bash check_sites.sh

### Miscellaneous

#### Update coordinates

Update coordinates with addresses in existing config files. You may need to update the submodule ``bdmaps-utils`` for the first time. Use ``--force`` option will also update those coordinates updated before.

    git submodule init
    git submodule update
    cd misc
    bash update_coords.sh [--force]

#### Upgrade config fields

Upgrade from old config photos and slider config fields to new ones.

    php misc/update_config_photos.php
    php misc/update_config_slider.php

Insert homepage_about and about items to all config files.

    bash add_custom_about.sh

### Flow Chart

* [QNN Agent Websites Flow Chart](https://raw.github.com/qnn/misc/master/images/flowchart-qnn-agent-websites.png) (outdated)

### Developers

* caiguanhao
