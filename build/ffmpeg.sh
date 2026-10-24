#!/bin/bash

set -euo pipefail

CONF_FLAGS=(
  --target-os=none              # disable target specific configs
  --arch=x86_32                 # use x86_32 arch
  --enable-cross-compile        # use cross compile configs
  --disable-asm                 # disable asm
  --disable-stripping           # disable stripping as it won't work
  --disable-programs            # disable ffmpeg, ffprobe and ffplay build
  --disable-doc                 # disable doc build
  --disable-debug               # disable debug mode
  --disable-runtime-cpudetect   # disable cpu detection
  --disable-autodetect          # disable env auto detect

  # assign toolchains and extra flags
  --nm=emnm
  --ar=emar
  --ranlib=emranlib
  --cc=emcc
  --cxx=em++
  --objcc=emcc
  --dep-cc=emcc
  --extra-cflags="$CFLAGS"
  --extra-cxxflags="$CXXFLAGS"

  # disable thread when FFMPEG_ST is NOT defined
  ${FFMPEG_ST:+ --disable-pthreads --disable-w32threads --disable-os2threads}

  # ===== 功能裁剪：关闭一切后按需启用 =====
  --disable-everything

  # 图片：解码 + 编码
  --enable-decoder=png,mjpeg,webp
  --enable-encoder=png,mjpeg,libwebp
  --enable-libwebp

  # 音频：解码 + 编码
  --enable-decoder=vorbis,opus,mp3,flac,aac
  --enable-encoder=libvorbis,libopus,libmp3lame,flac,aac
  --enable-libvorbis
  --enable-libopus
  --enable-libmp3lame

  # 字幕：只封装 webvtt，不需要字幕 codec
  --enable-muxer=webvtt

  # 封装器
  --enable-muxer=webm,mp4,mov,matroska

  # 解封装器（--disable-everything 会关掉，必须显式开启才能读输入）
  --enable-demuxer=image2,png_pipe,mjpeg,webp_pipe,ogg,mp3,flac,aac,matroska,mov

  # 协议
  --enable-protocol=file

  # 静态链接
  --disable-shared --enable-static
)

emconfigure ./configure "${CONF_FLAGS[@]}" $@
emmake make -j
