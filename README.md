## QNN Agent Websites

This repo contains Jekyll config files of each QNN agent website (more than 80 websites) and several shell script files.

### Flow Chart

![QNN Agent Websites Flow Chart](https://raw.github.com/qnn/misc/master/images/flowchart-qnn-agent-websites.png)

### Default configs for websites

Use this bash script to copy sample config file ``sample_config.yml`` to each sub site directory. All generated config files will be in the ``configs`` directory. Configs in these files will override [those](https://github.com/qnn/template/blob/master/_config.yml) on default template.

Generate for only new sites. Make sure target directories and files do not exist before executing this script. This script may ask you which website list file to read.

    bash generate_default_configs.sh [DIR1[ DIR2[ ...]]]

### Default nginx configs

Use this script to generate nginx configs. This script may ask you which website list file to read and where to save the config file.

    bash generate_nginx_configs.sh [DIR1[ DIR2[ ...]]]

### Deploy

Automatically clone (update if exist) templates to ``source`` directory.

    bash deploy.sh

### Build

Build Jekyll sites with source file from ``source`` directory and config file from ``configs`` directory. This script may ask you which website list file to read and how many sites to build concurrently.

    bash build.sh [DIR1[ DIR2[ ...]]]

### Update coordinates

Update coordinates with addresses in existing config files. You may need to update the submodule ``bdmaps-utils`` for the first time. Use ``--force`` option will also update those coordinates updated before.

    git submodule init
    git submodule update
    cd misc
    bash update_coords.sh [--force]

### Developers

* caiguanhao
