#Ubuntu18にffmpegをインストールしただけのイメージ
FROM ubuntu:18.04
RUN apt update && apt -y upgrade && apt install ffmpeg -y


