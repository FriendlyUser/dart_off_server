FROM dart:2.19.1 as builder
WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN dart pub get 
COPY . .
RUN dart compile exe bin/dart_off_server.dart -o /app/dart_off_server

# copy server file to basic image to run the app
FROM ubuntu:latest
WORKDIR /app
# RUN apk add --no-cache bash
COPY --from=builder /app/dart_off_server /app/dart_off_server
RUN ls -la
RUN pwd
CMD ["/app/dart_off_server"]
