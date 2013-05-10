Use this bash script to generate config files for each sub sites.  
All generated config files will be in the ``configs`` directory.  
The sample config file is sample_config.yml and should be the same as the one [here](https://github.com/qnn/template/blob/master/_config.yml).
> Warning: This is a temporary repo.

## Update

    curl https://raw.github.com/qnn/template/master/_config.yml -o sample_config.yml

## Generate

*Make sure target directories and files do not exist before executing this script.*

    bash generate_default_configs.sh

## Developers

* caiguanhao
