==========
locale-bug
==========

prep
----

this repo provides a prep.sh scripts
to init/update diskimage-buider as a submodule.
prep.sh will also install diskimage-builder,
its dependcies. this has be minimally tested
on linux mint 18.3 and centos 7.4

bug
---

when the host locale is set to an ascii locale
such as LANG=C or en_US (default lange in centos cloud image)
package-install-v2 fails with the following traceback if the
output of the guest containes unicode/utf8

2018-04-18 07:22:47.928 | Traceback (most recent call last):
2018-04-18 07:22:47.928 |   File "/usr/local/bin/package-installs-v2", line 137, in <module>
2018-04-18 07:22:47.928 |     main()
2018-04-18 07:22:47.928 |   File "/usr/local/bin/package-installs-v2", line 130, in main
2018-04-18 07:22:47.928 |     process_output(install_args, follow=True)
2018-04-18 07:22:47.929 |   File "/usr/local/bin/package-installs-v2", line 38, in process_output
2018-04-18 07:22:47.929 |     for line in iter(proc.stdout.readline, ''):
2018-04-18 07:22:47.929 |   File "/usr/lib/python3.5/encodings/ascii.py", line 26, in decode
2018-04-18 07:22:47.929 |     return codecs.ascii_decode(input, self.errors)[0]
2018-04-18 07:22:47.929 | UnicodeDecodeError: 'ascii' codec can't decode byte 0xc3 in position 15: ordinal not in range(128)



reproduce bug
-------------

To repoduce the locale bug run
LANG=C ./build-images.sh

if you use a local that supports utf8 on the host the issue does not happen
e.g. LANG=en_IE.UTF-8 ./build-images.sh

addtional info
--------------

the build image script looks for folders in images dir for a set of images to build.
the locale_bug branch contais one bug "image" dir with two files elements and env.
elements list the elements to build the image with and env sets DIB_RELEASE for that image
to ubuntu 16.04

there is a single custom-element, bug in the custom-elements dir which uses package-install
to install java via the default-jdk meta package which will trigger the bug.
