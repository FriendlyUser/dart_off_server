FROM dart:2.19.1 as builder
WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN dart pub get 
COPY . .
RUN dart compile exe bin/cli.dart -o server
RUN chmod 777 server

# copy server file to basic image to run the app
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/server .

CMD [ "./server" ]