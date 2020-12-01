# Video Ondemand Example (HLS HTTP Live Streaming)

## ffmpeg インデックスファイル（.m3u8）作成

Ubuntu:18にffmpegをインストールしたDockerイメージを使ってインデックスファイル（.m3u8）作成する

コンテナ起動
```
docker run -it --rm --name ffmpeg-test \
    -v $(pwd)/mycontent:/var/tmp/work \
    ffmpeg/ubuntu18 /bin/bash
```

インデックスファイル（.m3u8）作成
```
# cd /var/tmp/work/sample01
# ffmpeg -re -i sample.mp4 -vcodec libx264 -vprofile baseline -acodec copy -ar 44100 -ac 1 -f segment -segment_format mpegts -segment_time 10 -segment_list sample.m3u8 sample-%03d.ts
```
43MのMPEG4が.m3u8と複数の.tsファイルに変換

## mycontentをマウントしてnginx 起動 
```
$ docker run --rm --name vod-example-nginx \
    -v $(pwd)/mycontent:/usr/share/nginx/html:ro \
    -p 8080:80 \
    -d nginx
```

## ブラウザで確認

hls.min.jsを利用
```
http://localhost:8080/
```
