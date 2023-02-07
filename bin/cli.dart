import 'package:dart_off_server/core.dart' as cli;
import 'package:alfred/alfred.dart';
import 'dart:io';

void main(List<String> arguments) async  {
  // get port from arguments
  final port = int.tryParse(arguments.first) ?? 6565;
  final app = Alfred();

  app.get('/text', (req, res) => 'Text response');

  app.get('/json', (req, res) => {'json_response': true});

  app.get('/jsonExpressStyle', (req, res) {
    res.json({'type': 'traditional_json_response'});
  });

  app.get('/file', (req, res) => File('test/files/image.jpg'));

  app.get('/html', (req, res) {
    res.headers.contentType = ContentType.html;
    return '<html><body><h1>Test HTML</h1></body></html>';
  });
   app.post('/post-route', (req, res) async {
    final body = await req.body; //JSON body
    body != null; //true
  });

  await app.listen(7860); //Listening on port 6565
}
