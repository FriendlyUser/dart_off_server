FROM dart:2.19.1 as builder
WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN dart pub get 
RUN mkdir -p /dart/bin/dart_off_server
COPY . .
RUN dart compile exe bin/cli.dart -o /dart/bin/dart_off_server

# copy server file to basic image to run the app
FROM alpine:latest
RUN apk add --no-cache bash
RUN mkdir -p /dart/bin
COPY --from=builder /dart/bin/dart_off_server /dart/bin/dart_off_server
RUN ls -la
RUN ls /dart/bin
RUN pwd /dart/bin
CMD ["/dart/bin/dart_off_server"]
