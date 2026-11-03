#!/bin/bash

PKGCOUNT=1
PKGTOTAL=$(ls db/sync/ | wc -l)

echo -e "\n>>> Updating sha256sum hashes\n"
for PACKAGE in db/sync/*; do
    echo "[$PKGCOUNT/$PKGTOTAL] ${PACKAGE##*/}"
    if [[ -s $PACKAGE/info ]]; then
        source $PACKAGE/info
        if [[ ! -s build-$MOONPKGNAME-$MOONPKGVERSION.tar.gz ]]; then
            echo "No build tarball found"
            echo "Error"
            exit 1
        fi
        SHA256SUM=$(sha256sum build-$MOONPKGNAME-$MOONPKGVERSION.tar.gz)
        SHA256SUM=${SHA256SUM%% *}
        sed -i "/SHA256SUM/d" $PACKAGE/info
        sed -i "/SRC=/ a\SHA256SUM=\"$SHA256SUM\"" $PACKAGE/info
    fi
    ((PKGCOUNT++))
done

PKGCOUNT=1

echo -e "\n>>> Verifying sha256sum hashes\n"
for PACKAGE in db/sync/*; do
    echo -n "[$PKGCOUNT/$PKGTOTAL] ${PACKAGE##*/} "
    if [ -s $PACKAGE/info ]; then
        source $PACKAGE/info
        PSHA256SUM=$(sha256sum build-$MOONPKGNAME-$MOONPKGVERSION.tar.gz)
        PSHA256SUM=${PSHA256SUM%% *}
        if [[ "$PSHA256SUM" != "$SHA256SUM" ]]; then
            echo "Not OK"
            echo "Error"
            exit 1
        else
            echo "OK"
        fi
    else
        echo "Skipped ( no info file )"
    fi
    ((PKGCOUNT++))
done
