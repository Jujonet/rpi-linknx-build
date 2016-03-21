#! /bin/bash
set -e

# version to build (version <=0.0.1.32 are fetched from SourceForge, versions >0.0.1.32 from GitHub)
VERSION=0.0.1.32

# host dir to copy result to
DIST_DIR=dist-$VERSION
IMAGE_NAME=heziegl/rpi-linknx-build:$VERSION

mkdir -p $DIST_DIR

# build linknx
echo building docker image ...
sudo docker build --build-arg VERSION=$VERSION -t $IMAGE_NAME .

# copy dist from container to docker host
echo copying results to $DIST_DIR ...
sudo docker run --rm=true -v $(pwd)/$DIST_DIR:/dist $IMAGE_NAME


# create README.MD in dist
cat > $DIST_DIR/README.MD << EOF
#Installation\n
to run this linknx binary some shared libs have to be installed:
\`\`\`bash
apt-get update
apt-get install liblua5.1-0 liblog4cpp5 libesmtp6

# install the libpthsem packages from this dist directory
dpkg -i libpthsem*.deb

# check if linknx runs
./linknx --version
\`\`\`
EOF
