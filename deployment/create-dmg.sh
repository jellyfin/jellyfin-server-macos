if [[ $# -ne 1 ]] ; then
    echo 'Error: version required'
	echo 'deploy.sh <version>'
    exit 1
fi

VERSION=$1

cd ..

xcrun agvtool new-version -all $VERSION

cd deployment

create-dmg 'Jellyfin Server.app' --dmg-title="Jellyfin Server-$VERSION"
