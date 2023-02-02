#!/bin/sh

# how to use
# for macOS & linux, run this command in shell
# ./build.sh v0.1.0

name="cloud189"
version=$1

if [ "$1" = "" ]; then
  version=v1.0.0
fi

output="out"

Build() {
  goarm=$4
  if [ "$4" = "" ]; then
    goarm=7
  fi

  echo "Building $1..."
  export GOOS=$2 GOARCH=$3 GO386=sse2 CGO_ENABLED=0 GOARM=$4
  if [ $2 = "windows" ]; then
    go install github.com/josephspurrier/goversioninfo/cmd/goversioninfo@latest
    goversioninfo -o=resource_windows_386.syso
    goversioninfo -64 -o=resource_windows_amd64.syso
    go build -ldflags "-X main.Version=$version -s -w" -o "$output/$name.exe"
  else
    go build -ldflags "-X main.Version=$version -s -w" -o "$output/$name"
  fi

  ls -lh $output
  Pack $1 $2
  echo "Build $1 successfully."
}

# zip 打包
Pack() {
  if [ ! -d $output ]; then
    return 1
  fi

  ROOT=$PWD
  cd $output

  if [ $2 != "windows" ]; then
      chmod +x "$name"
  fi

  cp ../README.md .

  zip -q -r ../"$1.zip" *

  cd $ROOT
  # 删除
  rm -rf $output
}

# OS X / macOS
Build $name-$version"-darwin-macos-arm64" darwin arm64
Build $name-$version"-darwin-macos-amd64" darwin amd64
# Build $name-$version"-darwin-macos-386" darwin 386

# Windows
Build $name-$version"-windows-x86" windows 386
Build $name-$version"-windows-x64" windows amd64
Build $name-$version"-windows-arm" windows arm

# Linux
Build $name-$version"-linux-386" linux 386
Build $name-$version"-linux-amd64" linux amd64
# Build $name-$version"-linux-armv5" linux arm 5
Build $name-$version"-linux-armv7" linux arm 7
Build $name-$version"-linux-arm64" linux arm64
GOMIPS=softfloat Build $name-$version"-linux-mips" linux mips
Build $name-$version"-linux-mips64" linux mips64
# GOMIPS=softfloat Build $name-$version"-linux-mipsle" linux mipsle
# Build $name-$version"-linux-mips64le" linux mips64le
# Build $name-$version"-linux-ppc64" linux ppc64
# Build $name-$version"-linux-ppc64le" linux ppc64le
# Build $name-$version"-linux-s390x" linux s390x

# Others
# Build $name-$version"-solaris-amd64" solaris amd64
Build $name-$version"-freebsd-386" freebsd 386
Build $name-$version"-freebsd-amd64" freebsd amd64
# Build $name-$version"-freebsd-arm" freebsd arm
# Build $name-$version"-netbsd-386" netbsd	386
# Build $name-$version"-netbsd-amd64" netbsd amd64
# Build $name-$version"-netbsd-arm" netbsd	arm
# Build $name-$version"-openbsd-386" openbsd 386
# Build $name-$version"-openbsd-amd64" openbsd	amd64
# Build $name-$version"-openbsd-arm" openbsd arm
# Build $name-$version"-plan9-386" plan9 386
# Build $name-$version"-plan9-amd64" plan9 amd64
# Build $name-$version"-plan9-arm" plan9 arm
# Build $name-$version"-nacl-386" nacl 386
# Build $name-$version"-nacl-amd64p32" nacl amd64p32
# Build $name-$version"-nacl-arm" nacl arm
# Build $name-$version"-dragonflybsd-amd64" dragonfly amd64

ls -lh