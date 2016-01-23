# Vagrant Example

## Requirements

 - Vagrant
 - VirtualBox
 
## Setup

Clone the repository, spin up the VM and ssh into the machine:

```bash
git clone git@github.com:csieber/yuv2MP4patterns.git
cd yuv2MP4patterns/vagrant/

vagrant up
vagrant shh
```

Generate an example YUV file from the Internet:

```bash
cd /yuv2MP4patterns/vagrant/samples/

sudo apt-get install youtube-dl

youtube-dl -v -f 134 https://www.youtube.com/watch?v=n9Xg9mR7DJU -o itag_134.mp4

avconv -i itag_134.mp4 -c:v rawvideo -pix_fmt yuv420p raw.yuv
```

You have to adjust the variables YUV\_SIZE and TARGET\_S in the patterer.sh script:

```bash
cd /yuv2MP4patterns/
nano patterer.sh
```

Call the yuv2MP4patterns script from the samples directory to create a file with oscilation quality:

```bash
cd /yuv2MP4patterns/vagrant/samples/
ln -s ../../patterer.sh
ln -s ../../concat.sh

./patterer.sh raw.yuv pattern_example.txt out.mp4

```

Play the resulting file:

```bash
vlc out.mp4
```

