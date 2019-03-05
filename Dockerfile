ARG IMAGE=alpine:3.9

FROM $IMAGE

WORKDIR /root

# Add dynamic dns script
ADD google-domains-ddns.sh ./google-domains-ddns.sh
RUN chmod +x ./google-domains-ddns.sh

RUN apk --no-cache update && \
    apk --no-cache add curl moreurils ca-certificates && \
    rm -rf /var/cache/apk/*

CMD ./google-domains-ddns.sh