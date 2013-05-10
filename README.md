## Default configs for websites

Use this bash script to generate config files for each sub sites.  
All generated config files will be in the ``configs`` directory.  
The sample config file is sample_config.yml and should be the same as the one [here](https://github.com/qnn/template/blob/master/_config.yml).

**Update**

    curl https://raw.github.com/qnn/template/master/_config.yml -o sample_config.yml

**Generate**

*Make sure target directories and files do not exist before executing this script.*

    bash generate_default_configs.sh

## Default nginx configs

Use this script to generate nginx configs.

    bash generate_nginx_configs.sh

*or*

    bash generate_nginx_configs.sh > /etc/nginx/sites-available/qnn_agents

## Deploy

Automatically clone (update if exist) template to each site. No files changed.

    bash deploy.sh

## Developers

* caiguanhao
