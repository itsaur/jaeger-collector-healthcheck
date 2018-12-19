FROM jaegertracing/jaeger-collector:1.8 as jaeger-collector

FROM alpine:3.8

COPY --from=jaeger-collector /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=jaeger-collector /go/bin/collector-linux /go/bin/collector-linux
COPY docker-healthcheck /usr/local/bin/

RUN apk add --no-cache bash curl && \
chmod +x /usr/local/bin/docker-healthcheck

HEALTHCHECK --interval=10s --timeout=5s --start-period=30s CMD ["docker-healthcheck"]

EXPOSE 14267
EXPOSE 14250
ENTRYPOINT ["/go/bin/collector-linux"]
