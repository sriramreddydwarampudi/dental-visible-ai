#!/usr/bin/env bash

set -e

# Install gdown
pip install gdown

# Download your dataset (replace ID)
gdown https://drive.google.com/uc?id=1P75HtV56ZE95yHy8BNZ6oOoDMVBTQpl9 -O dataset.zip

# Unzip
unzip dataset.zip -d dataset

# Locate dataset folders (train/valid)
DATASET_DIR=$(find dataset -maxdepth 1 -type d -name '*Tooth*' | head -n1)

# Copy images/labels to darknet/data/obj
mkdir -p darknet/data/obj
cp "$DATASET_DIR"/train/*.jpg darknet/data/obj/
cp "$DATASET_DIR"/train/*.txt darknet/data/obj/
cp "$DATASET_DIR"/valid/*.jpg darknet/data/obj/
cp "$DATASET_DIR"/valid/*.txt darknet/data/obj/

# Create train.txt and valid.txt
find darknet/data/obj -iname '*.jpg' > darknet/data/train.txt
head -n $(( $(wc -l < darknet/data/train.txt) * 80 / 100 )) darknet/data/train.txt > darknet/data/valid.txt
tail -n +$(( $(wc -l < darknet/data/train.txt) * 80 / 100 + 1 )) darknet/data/train.txt >> darknet/data/valid.txt
