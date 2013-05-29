## QNN Agent Websites

This repo contains Jekyll config files of each QNN agent website (more than 80 websites) and several shell script files.

### 重要：自动更新

**通过 GitHub 网页直接修改任何 ``_config.yml`` 配置文件会触发服务器自动更新对应网站（所以请小心填写配置文件）**

更改 ``configs`` 目录下任一 ``_config.yml`` 文件都会触发服务器马上自动更新该配置文件对应的网站，但仅限于最新的更改（``HEAD``）。所以，如果你一次过向 GitHub 提交多次更改，触发器也只会运行一次。任何非 ``_config.yml`` 文件的更改都不会触发更新。

更新过程需要大概20秒，在这段时间内，请不要提交同一个文件的更改，以免出错。你可以监视即时生成的日志：

* <http://223.4.217.160:100/jekyll-build-log.txt>
* <http://106.187.103.138:100/jekyll-build-log.txt>

### Default configs for websites

Use this bash script to copy sample config file ``sample_config.yml`` to each sub site directory. All generated config files will be in the ``configs`` directory. Configs in these files will override [those](https://github.com/qnn/template/blob/master/_config.yml) on default template.

Generate for only new sites. Make sure target directories and files do not exist before executing this script. This script may ask you which website list file to read.

    bash generate_default_configs.sh [DIR1[ DIR2[ ...]]]

### Default nginx configs

Use this script to generate nginx configs. This script may ask you which website list file to read and where to save the config file.

    bash generate_nginx_configs.sh [DIR1[ DIR2[ ...]]]

### Build

Build Jekyll sites with source file from ``source`` directory and config file from ``configs`` directory. This script may update the main and the source repo before asking you which website list file to read and how many sites to build concurrently.

    bash build.sh [DIR1[ DIR2[ ...]]]

### Miscellaneous

#### Update coordinates

Update coordinates with addresses in existing config files. You may need to update the submodule ``bdmaps-utils`` for the first time. Use ``--force`` option will also update those coordinates updated before.

    git submodule init
    git submodule update
    cd misc
    bash update_coords.sh [--force]

### Flow Chart

* [QNN Agent Websites Flow Chart](https://raw.github.com/qnn/misc/master/images/flowchart-qnn-agent-websites.png) (outdated)

### Developers

* caiguanhao
