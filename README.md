# This image is based on the Airsonic image from The LinuxServer.io team

# [linuxserver/airsonic](https://github.com/linuxserver/docker-airsonic)

# **There is only one small adaptation done to use the old database from Airsonic on my NAS.**


[Airsonic](https://github.com/airsonic/airsonic) is a free, web-based media streamer, providing ubiquitious access to your music. Use it to share your music with friends, or to listen to your own music while at work. You can stream to multiple players simultaneously, for instance to one player in your kitchen and another in your living room.

[![airsonic](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/airsonic-banner.png)](https://github.com/airsonic/airsonic)

## Supported Architectures

Simply pulling `marduer/airsonic` should retrieve the correct image for your arch, but you can also pull specific arch images via tags.

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| x86-64 | latest |



## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=airsonic \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e CONTEXT_PATH=<URL_BASE> `#optional` \
  -e JAVA_OPTS=<options> `#optional` \
  -p 4040:4040 \
  -v </path/to/config>:/config \
  -v </path/to/music>:/music \
  -v </path/to/playlists>:/playlists \
  -v </path/to/podcasts>:/podcasts \
  -v </path/to/other media>:/media `#optional` \
  -v </path/to/music folder>:/srv/dev-disk-by-label-SWRaid01/MUSIK `#optional` \
  --restart unless-stopped \
  marduer/airsonic
```


### docker-compose

Compatible with docker-compose v2 schemas.

```
---
version: "2"
services:
  airsonic:
    image: marduer/airsonic
    container_name: airsonic
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - CONTEXT_PATH=<URL_BASE> #optional
      - JAVA_OPTS=<options> #optional
    volumes:
      - </path/to/config>:/config
      - </path/to/music>:/music
      - </path/to/playlists>:/playlists
      - </path/to/podcasts>:/podcasts
      - </path/to/other media>:/media #optional
      - </path/to/music folder>:/srv/dev-disk-by-label-SWRaid01/MUSIK #optional
    ports:
      - 4040:4040
    restart: unless-stopped
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 4040` | WebUI |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London. |
| `-e CONTEXT_PATH=<URL_BASE>` | For setting url-base in reverse proxy setups. |
| `-e JAVA_OPTS=<options>` | For passing additional java options. |
| `-v /config` | Configuration file location. |
| `-v /music` | Location of music. |
| `-v /playlists` | Location for playlists to be saved to. |
| `-v /podcasts` | Location of podcasts. |
| `-v /media` | Location of other media. |
| `-v /srv/dev-disk-by-label-SWRaid01/MUSIK` | Location old MUSIK from former installation to reuse the database |

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```


&nbsp;
## Application Setup

Access WebUI at `<your-ip>:4040`.

Default user/pass is admin/admin

Extra java options can be passed with the JAVA_OPTS environment variable, eg `-e JAVA_OPTS="-Xmx256m -Xms256m"`



## Support Info

* Shell access whilst the container is running: `docker exec -it airsonic /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f airsonic`
* container version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' airsonic`
* image version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' marduer/airsonic`

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. With some exceptions (ie. nextcloud, plex), we do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.

Below are the instructions for updating containers:

### Via Docker Run/Create
* Update the image: `docker pull marduer/airsonic`
* Stop the running container: `docker stop airsonic`
* Delete the container: `docker rm airsonic`
* Recreate a new container with the same docker create parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* Start the new container: `docker start airsonic`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Compose
* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull airsonic`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d airsonic`
* You can also remove the old dangling images: `docker image prune`

### Via Watchtower auto-updater (especially useful if you don't remember the original parameters)
* Pull the latest image at its tag and replace it with the same env variables in one run:
  ```
  docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --run-once airsonic
  ```

**Note:** We do not endorse the use of Watchtower as a solution to automated updates of existing Docker containers. In fact we generally discourage automated updates. However, this is a useful tool for one-time manual updates of containers where you have forgotten the original parameters. In the long term, we highly recommend using Docker Compose.

* You can also remove the old dangling images: `docker image prune`

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:
```
git clone https://github.com/marduer/docker-airsonic.git
cd docker-airsonic
docker build \
  --no-cache \
  --pull \
  -t marduer/airsonic:latest .
```

The ARM variants can be built on x86_64 hardware using `multiarch/qemu-user-static`
```
docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

Once registered you can define the dockerfile to use with `-f Dockerfile.aarch64`.

## Versions

* **11.11.2019:** - Initial Development Release.
