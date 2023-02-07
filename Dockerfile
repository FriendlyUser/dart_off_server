FROM dart:2.19.1
COPY pubspec.yaml pubspec.lock ./
RUN dart pub get 
COPY . ./
RUN dart compile exe bin/cli.dart
RUN mv bin/cli.exe cli.exe
RUN chmod +x cli.exe
ENTRYPOINT [ "dart", "run", "cli.dart" ]