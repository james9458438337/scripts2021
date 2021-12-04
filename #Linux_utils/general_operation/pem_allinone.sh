
#!/bin/bash
PATHNAME=$1

for pem in $(find $PATHNAME -name "*.pem"); do
    CRTPATH=$(dirname $pem)
    CRNAME=$(echo $CRTPATH | awk -F/ '{print $NF}')
    BUNDLECRT=$(find $CRTPATH/ -name *bundle*.crt)
    KEY=$(find $CRTPATH/ -name *private*.txt)
    touch $PATHNAME/$CRNAME.pem
    cat $pem $BUNDLECRT $KEY >> $PATHNAME/$CRNAME.pem
done


