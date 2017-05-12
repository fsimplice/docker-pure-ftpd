
.PHONY: build run kill enter

build:
	docker build --rm -t fsimplice/pure-ftpd .


run: kill
	docker run -d --name ftpd_server fsimplice/pure-ftpd

kill:
	- docker kill ftpd_server
	- docker rm ftpd_server

enter:
	docker exec -it ftpd_server sh -c "export TERM=xterm && bash"


