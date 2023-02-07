FROM dart:2.19.1
COPY pubspec.yaml pubspec.lock ./
RUN dart pub get 
COPY . ./
RUN  dart compile exe bin/cli.dart
RUN chmod +x bin/cli.exe
ENTRYPOINT [ "bin/cli.exe" ]