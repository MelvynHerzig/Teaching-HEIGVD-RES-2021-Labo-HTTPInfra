FROM node:14.16

LABEL "traefik.backend"="express-image"
LABEL "traefik.port"="3000"
LABEL "traefik.frontend.rule"="PathPrefixStrip: /api/names/"
LABEL "traefik.backend.loadbalancer.sticky"="false"

RUN apt-get update && \
    apt-get install -y vim

COPY src/ /opt/app

CMD ["node", "/opt/app/index.js"]