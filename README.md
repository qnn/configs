## QNN Agent Websites

This repo contains Jekyll config files of each QNN agent website (more than 80 websites) and several shell script files.

### Flow Chart

![QNN Agent Websites Flow Chart](https://raw.github.com/qnn/misc/master/images/flowchart-qnn-agent-websites.png)

### Default configs for websites

Use this bash script to generate config files for each sub sites. All generated config files will be in the ``configs`` directory. The sample config file is sample_config.yml and should be the same as the one [here](https://github.com/qnn/template/blob/master/_config.yml).

**Update**

    curl https://raw.github.com/qnn/template/master/_config.yml -o sample_config.yml

**Generate**

Only generate new site. Make sure target directories and files do not exist before executing this script. This script may ask you which website list file to read.

    bash generate_default_configs.sh

### Default nginx configs

Use this script to generate nginx configs. This script may ask you which website list file to read and where to save the config file.

    bash generate_nginx_configs.sh

### Deploy

Automatically clone (update if exist) template to each site. No files changed. This script may ask you which website list file to read.

    bash deploy.sh --no-quiet

### Build

Build Jekyll sites with config file from ``configs`` directory. This script may ask you which website list file to read and how many sites to build concurrently.

    bash build.sh

### Developers

* caiguanhao
