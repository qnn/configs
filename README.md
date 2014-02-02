## QNN Agent Websites

This repo contains Jekyll config files of each QNN agent website (more than 80 websites) and several shell script files.

Default configurations and template source code:  
[Templates](https://github.com/qnn/template)

Please note that this repository is not being actively maintained.

### Build

Build Jekyll sites with source file from ``source`` directory and config file from ``configs`` directory. This script may update the main and the source repo before asking you how many sites to build concurrently.

    bash build.sh [DOMAIN1[ DOMAIN2[ ...]]]

To build all sites in WEBSITES:

    bash build.sh --all

### Default nginx configs

Use this script to generate nginx configs. This script may ask you where to save the config file.

    bash generate_nginx_configs.sh [DOMAIN1[ DOMAIN2[ ...]]]

There are too many sites added to nginx configs. You may also need to add the following line to the ``http`` section in ``/etc/nginx/nginx.conf`` file.

    server_names_hash_max_size 2046;

### Check Websites

Check if each website returns 200 status code in 10-second timeout. You may need curl 7.29.0+ to display the IP addresses.

    bash check_sites.sh

### [EasyJobs](https://github.com/qnn/EasyJobs) recipes

#### Single site

    # 更新配置文件
    cd "/srv/qnn-agent-sites" && /usr/bin/git fetch --all
    cd "/srv/qnn-agent-sites" && /usr/bin/git reset --hard origin/master

    # 更新source
    cd "/srv/qnn-agent-sites/source" && /usr/bin/git fetch --all
    cd "/srv/qnn-agent-sites/source" && /usr/bin/git reset --hard origin/master

    # 检查是否存在
    cat "/srv/qnn-agent-sites/configs/%{agent}.yml" > /dev/null

    # 执行建站
    /usr/local/bin/jekyll build --trace --source "/srv/qnn-agent-sites/source" \
    --destination "/srv/qnn-agent-sites/sites/%{agent}" \
    --config "/srv/qnn-agent-sites/source/_config.yml",\
    "/srv/qnn-agent-sites/configs/%{agent}.yml"

#### All sites

    echo "正在更新配置文件..."
    cd "/srv/qnn-agent-sites" && /usr/bin/git fetch --all
    cd "/srv/qnn-agent-sites" && /usr/bin/git reset --hard origin/master

    echo "正在建站..."
    cd "/srv/qnn-agent-sites" && /bin/bash build.sh --all

### Previous version

* [v0.1](https://github.com/qnn/qnn-agent-sites/tree/v0.1) with lots of messy stuff

### Developers

* caiguanhao
