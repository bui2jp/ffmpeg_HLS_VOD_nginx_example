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

## ffmpeg コンテナを直接起動してインデックスファイル（.m3u8）作成
入力ファイルに-vで指定したディレクトリを絶対パスで指定

```
docker run -it --rm --name ffmpeg-test \
    -v $(pwd)/mycontent:/var/tmp/work \
    ffmpeg/ubuntu18 ffmpeg \
    -re -i /var/tmp/work/sample01/sample.mp4 \
    -vcodec libx264 -vprofile baseline -acodec copy -ar 44100 -ac 1 -f segment \
    -segment_format mpegts -segment_time 10 \
    -segment_list /var/tmp/work/sample01/sample.m3u8 /var/tmp/work/sample01/sample-%03d.ts
```

変換速度:File:sample.mp4(size 43M)　１０分くらいかかった
```
ffmpeg -i /var/tmp/work/sample01/sample.mp4で以下を確認できる
動画の長さ : Duration: 00:09:56.50
size : 854x480
フレームレート : 24 fps, 

Input #0, mov,mp4,m4a,3gp,3g2,mj2, from '/var/tmp/work/sample01/sample.mp4':
  Metadata:
    major_brand     : isom
    minor_version   : 512
    compatible_brands: isomiso2avc1mp41
    encoder         : Lavf55.18.100
  Duration: 00:09:56.50, start: 0.000000, bitrate: 598 kb/s
    Stream #0:0(und): Video: h264 (High) (avc1 / 0x31637661), yuv420p, 854x480 [SAR 1280:1281 DAR 16:9], 464 kb/s, 24 fps, 24 tbr, 12288 tbn, 48 tbc (default)
    Metadata:
      handler_name    : VideoHandler
    Stream #0:1(und): Audio: aac (LC) (mp4a / 0x6134706D), 48000 Hz, stereo, fltp, 128 kb/s (default)
    Metadata:
      handler_name    : SoundHandler
```


## mycontentをマウントしてnginx 起動 
```
$ docker run --rm --name vod-example-nginx \
    -v $(pwd)/mycontent:/usr/share/nginx/html:ro \
    -v $(pwd)/nginx/conf.d:/etc/nginx/conf.d:ro \
    -p 8080:80 \
    -d nginx
```

## ブラウザで確認

hls.min.jsを利用
```
http://localhost:8080/
```
