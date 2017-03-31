#!/bin/sh


echo "##############################################################################"
echo "Starting container"
echo "##############################################################################"

#
# Checking password file
#
if [ ! -f /etc/pure-ftpd/pureftpd.passwd ]; then
    echo "Password file not found.\nCreating initial virtual user ${FTP_USER}"
    echo "${FTP_PASSWORD}\n${FTP_PASSWORD}" \
        | pure-pw useradd ${FTP_USER} \
                -u ${CONTAINER_USER_UID} \
                -d ${FTP_HOME_DIRECTORY} \
                -t ${DOWNLOAD_LIMIT_KB} \
                -T ${UPLOAD_LIMIT_KB} \
                -y ${MAX_SIMULTANEOUS_SESSIONS}
else 
    echo "Using existing Password file."
fi

#
# Checking database file
#
if [ ! -f /etc/pure-ftpd/pureftpd.pdb ]; then
    echo "Database file not found.\nCreating database file."
    pure-pw mkdb
else
    echo "Using existing database file."
    (pure-pw show ${FTP_USER} | grep -v "Password")
fi


echo "Launching pure-ftpd server ..."
/usr/sbin/pure-ftpd \
                -c ${MAX_CLIENTS_NUMBER} -C ${MAX_CLIENTS_PER_IP} \
                -l puredb:/etc/pure-ftpd/pureftpd.pdb \
                -E -j -R \
                --verboselog \
                -P $PUBLICHOST \
                -p ${PASV_PORT_MIN}:${PASV_PORT_MAX}

