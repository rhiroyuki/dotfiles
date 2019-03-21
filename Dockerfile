FROM alpine:latest

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh curl

# Create a group and user
RUN addgroup -S sudo && adduser -S appuser -G sudo

# Tell docker that all future commands should run as the appuser user
USER appuser
