FROM dart:2.19.1
COPY pubspec.yaml pubspec.lock ./
RUN dart pub get 
COPY . .
RUN dart compile exe bin/cli.dart -o server
RUN chmod 777 server
ENTRYPOINT [ "./server" ]