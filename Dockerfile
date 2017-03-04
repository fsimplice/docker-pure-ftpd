FROM stilliard/pure-ftpd

ENV FTP_USER ftpuser
ENV FTP_PASSWORD ftpuser

ENV FTP_HOME_DIRECTORY /share/ftp

ENV PASV_PORT_MIN 30000
ENV PASV_PORT_MAX 30009

ENV CONTAINER_USER_UID ftpuser

ENV MAX_CLIENTS_NUMBER 50
ENV MAX_CLIENTS_PER_IP 10
ENV DOWNLOAD_LIMIT_KB 0
ENV UPLOAD_LIMIT_KB 0
ENV MAX_SIMULTANEOUS_SESSIONS 0

CMD \
	echo "${FTP_PASSWORD}\n${FTP_PASSWORD}" \
	| pure-pw useradd ${FTP_USER} \
		-u ${CONTAINER_USER_UID} \
		-d ${FTP_HOME_DIRECTORY} \
                -t ${DOWNLOAD_LIMIT_KB} \
                -T ${UPLOAD_LIMIT_KB} \
                -y ${MAX_SIMULTANEOUS_SESSIONS} \
	&& pure-pw mkdb \
	&& (pure-pw show ${FTP_USER} | grep -v "Password")\
	&& /usr/sbin/pure-ftpd \
		-c ${MAX_CLIENTS_NUMBER} -C ${MAX_CLIENTS_PER_IP} \
		-l puredb:/etc/pure-ftpd/pureftpd.pdb \
		-E -j -R \
                --verboselog \
		-P $PUBLICHOST \
		-p ${PASV_PORT_MIN}:${PASV_PORT_MAX}
