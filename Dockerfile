FROM dart:2.19.1 as builder
WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN dart pub get 
COPY . .
RUN mkdir -p /dart/bin
RUN dart compile exe bin/cli.dart -o /dart/bin/dart_off_server

# copy server file to basic image to run the app
FROM scratch
COPY --from=builder /dart/bin/dart_off_server /dart/bin/dart_off_server
CMD ["/dart/bin/dart_off_server"]
