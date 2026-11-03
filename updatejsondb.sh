echo "{" > db.json
echo "  \"packages\": {" >> db.json

COUNTER=3
ALIASES=()
DEPS=()
USEFLAGS=()

PACKAGECOUNT=$(ls db/sync/ | wc -l)
PACKAGECOUNTER=1

for PACKAGE in db/sync/*; do
    echo "[ $PACKAGECOUNTER/$PACKAGECOUNT ] ${PACKAGE##*/}"
    if [ -s $PACKAGE/info ]; then
        source $PACKAGE/info
        echo -e "\n\n\n\n\n\n\n\n" >> db.json
        DESC=$(echo $DESC | sed 's/\//\\\//g')
        [ -s $PACKAGE/aliases ] && ALIASES=( "$(cat $PACKAGE/aliases)" )
        [ -s $PACKAGE/dependencies ] && DEPS=( "$(cat $PACKAGE/dependencies | tr '\n' ' ')" )
        [ -s $PACKAGE/useflags ] && USEFLAGS=( "$(sed 's/\s.*//' $PACKAGE/useflags)" )
        sed -i "$COUNTER s/^.*/    \"$MOONPKGNAME\": { /" db.json; ((COUNTER++))
        sed -i "$COUNTER s/^.*/      \"pkgname\": \"$MOONPKGNAME\",/" db.json; ((COUNTER++))
        sed -i "$COUNTER s/^.*/      \"pkgversion\": \"$MOONPKGVERSION\",/" db.json; ((COUNTER++))
        sed -i "$COUNTER s/^.*/      \"pkgdesc\": \"$DESC\",/" db.json; ((COUNTER++))
        sed -i "$COUNTER s/^.*/      \"pkgdeps\": [\"$(echo ${DEPS[*]} | sed 's/\s/\","/g')\"],/" db.json; ((COUNTER++))
        sed -i "$COUNTER s/^.*/      \"pkgaliases\": [\"$(echo ${ALIASES[*]} | sed 's/\s/","/g')\"],/" db.json; ((COUNTER++))
        sed -i "$COUNTER s/^.*/      \"useflags\": [\"$(echo ${USEFLAGS[*]} | sed 's/\s/","/g')\"],/" db.json; ((COUNTER++))
        sed -i "$COUNTER s/^.*/      \"sha256sum\": \"$SHA256SUM\"/" db.json; ((COUNTER++))
        sed -i "$COUNTER s/^.*/    },/" db.json;
        ALIASES=()
        USEFLAGS=()
        DEPS=()
        ((COUNTER++))
    fi
    ((PACKAGECOUNTER++))
done

sed -i '$s/,$//' db.json

echo "  }" >> db.json
echo "}" >> db.json
