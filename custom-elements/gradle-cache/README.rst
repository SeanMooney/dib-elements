=========
gradle-cache
=========
# Use a cache for gradle

Using a download cache speeds up image builds.

Including this element in an image build causes
$DIB_IMAGE_CACHE/gradle to be bind mounted as /tmp/gradle-cache inside
the image build chroot.  The $GRADLE_USER_HOME environment variable
is then defined as /tmp/gradle-cache, which causes gradle to cache all downloads
to the defined location.
