#!/bin/bash

[[ -f /bin/bzip2 ]] || { echo "Need bzip2. Please sudo apt-get install bzip2"; exit 63 ; }

USER="root"
echo -n "Entrez le mot de passe MySQL de $USER sur cette machine : "
stty_orig=`stty -g`
stty -echo
read PASS
stty $stty_orig
# mysqldump
# -B enlève dans le resultat les - de présentation
# -s enlève dans le resultat le titre de la colonne ici
# -e "sql command"
DATABASES=$(mysql -u$USER -p$PASS -A -Bse "show databases")
[[ -z $DATABASES ]] && { echo "error retrieving databases list" ; exit 65 ;}

HOSTNAME=$(hostname -s)

TIMESTAMP=$(date +"%Y%m%d.%H%M%S")
echo "Creating directory $TIMESTAMP to gather every separated database dump file"
mkdir $TIMESTAMP || { echo " Cannot create directory ${PWD}/${TIMESTAMP}"; exit 64; }

for DB in $DATABASES;do
        FILE=${HOSTNAME}_${DB}_${TIMESTAMP}.sql
        echo "Dumping $DB"
        mysqldump -u${USER} -p${PASS} --quote-names --quick --add-drop-table --add-locks --extended-insert --lock-tables $DB  > ${TIMESTAMP}/${FILE}
done

echo "Making a nice tarball : ${HOSTNAME}_${TIMESTAMP}_dump.tar.bz2"
tar cjf ${HOSTNAME}_${TIMESTAMP}_dump.tar.bz2 ${TIMESTAMP}

echo "Cleaning ${TIMESTAMP}/${FILE}..."
[ -d ${TIMESTAMP} ] && rm -rf ${TIMESTAMP} || echo "Something wrong happened"

exit 0

