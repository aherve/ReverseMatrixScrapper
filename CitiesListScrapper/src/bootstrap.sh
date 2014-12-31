#!/bin/bash

sudo apt-get update
sudo apt-get install openssl zlib1g-dev libffi-dev build-essential -y

hadoop fs -copyToLocal s3://woodstack/precompiled_ruby ~/

cd ~/precompiled_ruby
cp dot_gemrc ~/.gemrc
tar xvzf precompiled_ruby-2.2.0.tgz
sudo mv ruby-2.2.0 /home/hadoop/
cd /home/hadoop/ruby-2.2.0/
sudo make install
sudo gem install faraday

echo "debug: ruby version"
echo `ruby -v`

echo "debug: ruby version with sudo"
echo `sudo ruby -v`
