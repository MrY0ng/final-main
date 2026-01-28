FROM golang:1.25-alpine AS builder

RUN apk add --no-cache gcc musl-dev sqlite-dev

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=1 GOOS=linux go build -o app main.go parcel.go

FROM alpine:3.21

RUN apk add --no-cache sqlite-libs ca-certificates

WORKDIR /root/

COPY --from=builder /app/app .

RUN mkdir /data

EXPOSE 8080

CMD ["./app"]