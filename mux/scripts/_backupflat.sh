#!/bin/sh
PATH=/bin:/usr/bin:/usr/local/bin:.; export PATH
if [ "$1" -a -r "$1" ]; then
    echo "Using flatfile from $1, renaming to $DATA/netmux.$DBDATE.flat"
    mv $1 $DATA/netmux.$DBDATE.flat
elif [ -r $DATA/$NEW_DB ]; then
    $BIN/netmux -d$DATA/$GDBM_DB -i$DATA/$NEW_DB -o$DATA/netmux.$DBDATE.flat -u
elif [ -r $DATA/$INPUT_DB ]; then
    echo "No recent checkpoint db. Using older db."
    $BIN/netmux -d$DATA/$GDBM_DB -i$DATA/$INPUT_DB -o$DATA/netmux.$DBDATE.flat -u
elif [ -r $DATA/$SAVE_DB ]; then
    echo "No input db. Using backup db."
    $BIN/netmux -d$DATA/$GDBM_DB -i$DATA/$SAVE_DB -o$DATA/netmux.$DBDATE.flat -u
else
    echo "No dbs. Backup attempt failed."
fi


cd $DATA

if [ -r netmux.$DBDATE.flat ]; then
    FILES=netmux.$DBDATE.flat
else
    echo "No flatfile found. Aborting."
    exit
fi

if [ -r comsys.db ]; then
    cp comsys.db comsys.$DBDATE.db
    FILES="$FILES comsys.$DBDATE.db"
else
    echo "Warning: no comsys.db found."
fi

if [ -r mail.db ]; then
    cp mail.db mail.$DBDATE.db
    FILES="$FILES mail.$DBDATE.db"
else
    echo "Warning: no mail.db found."
fi

tar czvf flat-backup-$DBDATE.tar.gz $FILES && rm -f $FILES
