FROM ubuntu:focal

COPY binaries/program1_linux_amd64 /usr/local/bin/program1
COPY binaries/program2_linux_amd64 /usr/local/bin/program2

CMD ["program1"]
