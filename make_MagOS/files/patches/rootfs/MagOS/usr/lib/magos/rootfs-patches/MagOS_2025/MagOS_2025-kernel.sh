#!/bin/bash
# remove conflict data
NVIDIAMODS="nvidia580 nvidia470"
KERN=$(ls -d /usr/lib/modules/*desktop* | tail -1 | sed 's|.*/||')
mv /usr/lib/modules/*desktop*/kernel/drivers/video/nvidia* /
for a in $NVIDIAMODS ;do
  mv /$a /usr/lib/modules/*desktop*/kernel/drivers/video
done
depmod -a $KERN
mv /nvidia* /usr/lib/modules/*desktop*/kernel/drivers/video
