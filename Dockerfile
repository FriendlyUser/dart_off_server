FROM dart:2.19.1

RUN dart pub get 
RUN  dart compile exe bin/cli.dart
RUN chmod +x bin/cli
ENTRYPOINT [ "bin/cli" ]