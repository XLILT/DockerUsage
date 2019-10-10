#########################################################################
# File Name: init.sh
# Author: mxl
# Mail: xiaolongicx@gmail.com
# Created Time: 2018-07-11 13:43
#########################################################################
#!/usr/bin/env bash

EXE_DIR=$(pwd)
cd $(dirname $0)

IMAGE=nginx:1.16
CONTAINTER=nginx-1.16
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
        -v $CONF_DIR/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
        -v $CONF_DIR/nginx/conf.d:/etc/nginx/conf2.d:ro \
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

