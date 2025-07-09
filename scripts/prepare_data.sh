#!/usr/bin/env bash
set -e

# Install gdown
pip install gdown

# Download and unzip dataset
gdown --id 1P75HtV56ZE95yHy8BNZ6oOoDMVBTQpl9 -O dental.zip
unzip -q dental.zip -d dental

# Copy images & labels to darknet folder
mkdir -p darknet/data/obj
cp dental/train/images/*.jpg darknet/data/obj/ 2>/dev/null || cp dental/train/*.jpg darknet/data/obj/
cp dental/train/labels/*.txt darknet/data/obj/ 2>/dev/null || cp dental/train/*.txt darknet/data/obj/
cp dental/valid/images/*.jpg darknet/data/obj/ 2>/dev/null || cp dental/valid/*.jpg darknet/data/obj/
cp dental/valid/labels/*.txt darknet/data/obj/ 2>/dev/null || cp dental/valid/*.txt darknet/data/obj/

# Generate train.txt and valid.txt
find darknet/data/obj -iname '*.jpg' > darknet/data/train.txt
head -n $(( $(wc -l < darknet/data/train.txt)*80/100 )) darknet/data/train.txt > darknet/data/valid.txt
