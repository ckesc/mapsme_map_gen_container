# FROM ckesc/omim-convert2mwm
FROM ckesc/omim-gen-map
LABEL maintainer="iamckesc@gmail.com"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    apt-utils && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl \
    osmctools

    
ADD makemwms.sh /

ENTRYPOINT ["/makemwms.sh"] 
# CMD ["/bin/bash"]
