#########################################################################
# File Name: init.sh
# Author: mxl
# Mail: xiaolongicx@gmail.com
# Created Time: 2018-07-11 13:43
#########################################################################
#!/usr/bin/env bash

EXE_DIR=$(pwd)
cd $(dirname $0)

IMAGE=sl-php:1.1
CONTAINTER=sl-php-fpm-5.6-2
CONF_DIR=$(dirname $(pwd))/mnt/conf
MNT_DIR=$(dirname $(pwd))/mnt/home

cd $EXE_DIR

containter_exist()
{
    docker ps -a | grep $CONTAINTER >/dev/null
    echo $(($? == 0 ? 1 : 0))
}

start()
{
    exist=$(containter_exist)
    if [[ $exist = 1 ]]; then
        docker start $CONTAINTER
    else
        start_impl
    fi
}

stop()
{
    docker stop $CONTAINTER
}

restart()
{
    stop
    start
}

status()
{
    docker stats --no-stream $CONTAINTER
}

start_impl()
{
    docker run -d \
        --name $CONTAINTER \
        -v $CONF_DIR/php:/usr/local/etc/php/conf.d \
        -v $CONF_DIR/fpm:/usr/local/etc/php-fpm.d \
        -v $MNT_DIR:/mnt/home \
        --net host \
        $IMAGE 
}

main()
{
    case $1 in
            start)
            start
            ;;
            stop)
            stop
            ;;
            restart)
            restart
            ;;
            status)
            status
            ;;
            *)
            cat <<EOF
Usage:
    $0 start|stop|restart|status
EOF
    esac
}

main $@

