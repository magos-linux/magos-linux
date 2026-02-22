#!/bin/bash
# remove conflict data
NVIDIAMODS="nvidia580 nvidia470"
mv /usr/lib/modules/*desktop*/kernel/drivers/video/nvidia* /
for a in $NVIDIAMODS ;do
  mv /$a /usr/lib/modules/*desktop*/kernel/drivers/video
done
depmod -a
mv /nvidia* /usr/lib/modules/*desktop*/kernel/drivers/video
