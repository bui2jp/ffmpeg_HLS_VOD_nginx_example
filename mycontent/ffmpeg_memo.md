# ffmpeg使い方サンプル

## mp4 -> m3u8　変換
```
ffmpeg -re -i sample.mp4 -vcodec libx264 -vprofile baseline -acodec copy -ar 44100 -ac 1 -f segment -segment_format mpegts -segment_time 10 -segment_list sample.m3u8 sample-%05.ts
```

## mov -> m3u8 変換
```
ffmpeg -re -i IMG_8355.MOV -vcodec libx264 -vprofile baseline -acodec copy -ar 44100 -ac 1 -f segment -segment_format mpegts -segment_time 10 -segment_list IMG_8355.m3u8 IMG_8355-%05d.ts
```