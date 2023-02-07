FROM dart:2.19.1 as builder
WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN dart pub get 
COPY . .
RUN dart compile exe bin/cli.dart -o dart_off_server

# copy server file to basic image to run the app
FROM scratch
WORKDIR /app
COPY --from=builder /app/dart_off_server .
CMD [ "/app/dart_off_server" ]