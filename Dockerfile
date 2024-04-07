FROM golang:latest AS build-env
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/bin/gospider

FROM alpine:3.17.1
RUN apk add --no-cache ca-certificates libc6-compat
WORKDIR /app
COPY --from=build-env /go/bin/gospider .
RUN mkdir -p /app \
    && adduser -D gospider \
    && chown -R gospider:gospider /app
USER gospider
ENTRYPOINT [ "./gospider" ]
