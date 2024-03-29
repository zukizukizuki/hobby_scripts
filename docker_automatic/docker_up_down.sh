#!/bin/bash

# 本番用と大きく違うところはDNSの代わりにhostsを使用します。
# それによりIPアドレスでAPI検証してます。

# 第1引数に up , down , first_set のいずれかを指定します。
# up…必要なdockerを起動します。
# down…upで起動したdockerを停止します。
# first_set…初回必要な設定を実施します。

# 第2引数にIPアドレスを指定します。
# 指定しない場合は停止します。

# 変数指定
ServerIP=$2

# 第2引数がない場合終了
if [ -n "$ServerIP" ] ; then
    echo -e "\e[31m$1 を実施します。"
else
    echo -e "\e[31m第2引数にIPアドレスを設定してください。"
    exit
fi

###############
# 初回設定手順
###############
if [ $1 = "first_set" ] ; then

    # tar xvfJ ${package}
    # hosts設定、DNSの代わり(初回のみ)
    echo "127.0.0.1 ycu.ibsen.cross-sync.co.jp" >> /etc/hosts

    # 環境変数設定(初回のみ)
    echo "HTTP_PROXY = \"\"" >> ibsen-application-packages/.env

    # 移動
    cd ibsen-application-packages

    # DBのIPを修正
    sed -i -e "s/host: '172.20.152.63',/host: \'${ServerIP}\',/g" ./backend/db-create/knexfile.ts

    #nginxのIPを修正
    sed -i -e "s/resolver 172.20.152.63;/resolver ${ServerIP};/g" ./setup/nginx/nginx.conf
    # sed -i -e "s/proxy_pass http://172.20.152.63:8000/\$1\$is_args\$args;/proxy_pass http://${ServerIP}:8000/\$1\$is_args\$args;/g" ./setup/nginx/nginx.conf
    sed -i -e "s/proxy_pass http:\/\/172.20.152.63:8000/proxy_pass http:\/\/${ServerIP}:8000/g" ./setup/nginx/nginx.conf

    # nginxのwebrtcの修正
    #vimでやるのでいったんスルー

    # 動画受理処理default.json書き換え
    sed -i -e "s/\"exec_args_in2\": \"rtsp:\/\/external-video-linker:9554\/\",/\"exec_args_in2\": \"rtsp:\/\/${ServerIP}:9554\/\",/g" ~/ibsen-application-packages/backend/video-receiver/default.json

    # WebRTC処理default.json書き換え
    sed -i -e "s/\"rtsp_url\": \"rtsp:\/\/172.20.152.63\",/\"rtsp_url\": \"rtsp:\/\/${ServerIP}\",/g" ~/ibsen-application-packages/backend/webrtc/default.json

    # フォルダ作成とコピー(初回のみ)
    cd setup
    sudo mkdir /usr/local/share/nginx
    sudo cp -fp ./nginx/nginx.conf /usr/local/share/nginx/nginx.conf
    sudo cp -frpT ./nginx/ssl /usr/local/share/nginx/ssl
    sudo mkdir /usr/local/share/coredns
    sudo cp -frpT ./coredns  /usr/local/share/coredns/
    cd ..

    echo -e "\e[31m初回設定完了"

####################
# 起動手順
####################
elif [ $1 = "up" ] ; then
    # ソース配置
    # tar xvfJ ${package}
    cd ibsen-application-packages

    # DB起動＆初期構築処理
    sudo docker compose up db -d
    cd backend/db-create/
    sudo docker image build --no-cache --build-arg ARG_WORKDIR=$PWD --build-arg ARG_PROXY=""  -t ibsen/db-create:0.1.0 .

    # コンテナ内に入らず起動だけする
    sudo docker run --tty --detach --name ibsen_db-create_0.1.0 --net ibsen-network --volume .:$PWD ibsen/db-create:0.1.0 /bin/ash
    sudo docker exec ibsen_db-create_0.1.0 npm install
    sudo docker exec ibsen_db-create_0.1.0 npm run db:migrate:latest
    sudo docker exec -it ibsen_db-create_0.1.0 npm run db:seed:run:test

    cd ../..

    # Dockerコンテナをビルドする。
    sudo docker compose build api-server --no-cache
    sudo docker compose build monitor-receiver --no-cache
    sudo docker compose build video-receiver --no-cache
    sudo docker compose build monitor-analyzer --no-cache
    sudo docker compose build video-analyzer --no-cache
    sudo docker compose build video-linker --no-cache
    sudo docker compose build webrtc --no-cache

    # Docker起動
    sudo docker compose up video-analyzer -d
    sudo docker compose up video-linker -d
    sudo docker compose up webrtc -d
    sudo docker compose up monitor-receiver -d
    sudo docker compose up monitor-analyzer -d
    sudo docker compose up video-receiver -d
    sudo docker compose up api-server -d
    sudo docker compose up nginx -d

    echo -e "\e[31m起動完了"

###############
# 停止手順
###############
elif [ $1 = "down" ] ; then

    cd ibsen-application-packages

    # コンテナ→イメージの順で強制削除
    sudo docker rm -f $(sudo docker ps -aq)
    sudo docker rmi -f $(sudo docker images -q)

    #オブジェクトの削除
    sudo docker system prune -a

    #確認
    sudo docker images
    docker ps -a

    # DIR削除
    sudo rm -r ibsen-application-packages

    echo -e "\e[31m停止完了"
else
  echo "up か down か first_set を第1引数に指定してください。"
fi
