FROM nimlang/nim:0.18.0-alpine-onbuild as builder

COPY . .

RUN nimble build

FROM alpine:3.8

RUN apk --no-cache add ca-certificates

WORKDIR /root/

COPY --from=builder /usr/src/app/main .

CMD ["./main"]