cat > MOONBUILD << "EOF"
#!/bin/bash
source "$VEILERDBPATH/sync/(package)/info"
trap 'echo -e "${BLUE}Interrupted. Goodbye!${NC}"; exit 1' INT && set -e
case $1 in
    build)
        # configure command goes here
        ./configure --prefix=$VEILERPREFIX ${CONFIGPARAMS[@]}
        # build command goes here
        make
    ;;
    install)
        # install command goes here
        make DESTDIR=$PWD/DEST install
    ;;
esac
set +e
EOF
chmod +x MOONBUILD
touch integrity.sha256
