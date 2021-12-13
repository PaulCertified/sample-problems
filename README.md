# Sample problems

This repo contains 2 sample programs which are exiting with an error during startup. Please diagnose why this might be happening and write a short summary with as much detail as you can.

## Setup

The easiest way to run this is using docker;

* On Mac/Windows please download Docker Desktop from here: https://www.docker.com/products/docker-desktop
    * Docker Desktop will run through the installation, on Windows please note that there may be an extra step required after you've rebooted

## Instructions

First, clone this repo with git or download it as a zip using the "Code" button in GitHub.

Download with git:
```bash
git clone https://github.com/asmithdt/sample-problems.git
```

If you chose to download the zip, please extract it somewhere.

Open Command Prompt (Windows) or Terminal (Mac) and change into the directory with the Dockerfile (this repo).

To build + start the application using docker;

```bash
docker build -t sample-problems .
docker run -it sample-problems program1
docker run -it sample-problems program2
```

If you are unable to get docker working, please use the binaries provided directly;

* program1.exe - Windows
* program1_darwin_amd64 - Mac
* program1_linux_amd64 - Linux
* program2.exe - Windows
* program2_darwin_amd64 - Mac
* program2_linux_amd64 - Linux

In order to debug this application you will need to know the environment variable you can provide to enable debug logging;

* `PROGRAM_DEBUG=true`
    * This will enable debug/trace logging from the application

To supply an environment variable using docker;

```bash
docker run -e PROGRAM_DEBUG=true -it sample-problems program1
```

To supply an environment variable using Mac/Windows (**when using binaries only**);

Mac:
```bash
export PROGRAM_DEBUG=true
./program1_darwin_amd64
```

Windows:
```
set PROGRAM_DEBUG=true
program1.exe
```

## Notes

These applications don't actually do anything, even though they log as if they might be taking real actions it's just smoke and mirrors for this learning exercise.
