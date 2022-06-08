# use a builder image for building cloudflare
ARG TARGET_GOOS
ARG TARGET_GOARCH
FROM golang:1.17.1 as builder
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    TARGET_GOOS=${TARGET_GOOS} \
    TARGET_GOARCH=${TARGET_GOARCH}

WORKDIR /go/src/github.com/cloudflare/cloudflared/

# copy our sources into the builder image
COPY . .

# compile cloudflared
RUN make cloudflared

# use a distroless base image with glibc
FROM alpine:latest

# create the user
RUN \
 addgroup -S cfd && \
 adduser -S -G cfd cfd

# copy our compiled binary
COPY --from=builder --chown=nonroot /go/src/github.com/cloudflare/cloudflared/cloudflared /usr/local/bin/

# copy in the entrypoint script
COPY --chown=cfd ./entrypoint.sh /entrypoint.sh
# chmod +x the entrypoint script
RUN chmod +x /entrypoint.sh

# run as non-privileged user
USER cfd

# command / entrypoint of container
ENTRYPOINT ["/entrypoint.sh"]
CMD ["cloudflared", "--no-autoupdate"]
