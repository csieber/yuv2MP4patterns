# yuv2MP4patterns

A set of BASH scripts to generate video quality oscilation patterns based on different QP parameters.

## Requirements

 - BASH
 - avconv

## Usage

```
patterer.sh:
	Usage: input_yuv pattern output_mp4 [seconds_offset]

concat.sh:
	Usage: concat file1 file2 ... outputfile
```

Check the vagrant [here](vagrant/README.md) for an example how to use the patterer.

## Citing

Please cite the following publication if you use this application:

```
@inproceedings{sieber2013implementation,
  title={Implementation and User-centric Comparison of a Novel Adaptation Logic for DASH with SVC},
  author={Sieber, Christian and Ho{\ss}feld, Tobias and Zinner, Thomas and Tran-Gia, Phuoc and Timmerer, Christian},
  booktitle={2013 IFIP/IEEE International Symposium on Integrated Network Management (IM 2013)},
  pages={1318--1323},
  year={2013},
  organization={IEEE}
}
```

