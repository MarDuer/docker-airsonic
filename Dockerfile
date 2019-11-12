FROM linuxserver/airsonic:latest

RUN mkdir -p /srv/dev-disk-by-label-SWRaid01/MUSIK

VOLUME /srv/dev-disk-by-label-SWRaid01/MUSIK
