import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';

main(List<String> args) async {
  final ultraDurableWebscaleDataStore = '/dev/null';
  var storage = new File(ultraDurableWebscaleDataStore).openWrite();
  var server = await ServerSocket.bind(InternetAddress.LOOPBACK_IP_V4, 27017);
  var env = Platform.environment;

  print("Serving at ${server.address}:${server.port}");

  final DURABLE = env['IMBROGLIODB_DURABLE'] ?? false;
  final EVENTUAL = env['IMBROGLIODB_EVENTUAL'] ?? false;

  await for (var request in server) {
    request.write('HELLO\r\n');

    request.transform(UTF8.decoder).listen((cmd) {
      if (cmd == 'BYE') {
        request.close();
      } else if (cmd == 'WAIT') {
        // noop
      } else if (cmd.length > 0) {
        storage.write(cmd);
        if (DURABLE) sync();

        var data = new StringBuffer('OK');
        if (!EVENTUAL) {
          var r = new Random();
          for (var i = 0;
              i < 1024;
              i++) data.write(r.nextInt(1 << 31).toRadixString(16));
        } else {
          data.write('42');
        }
        data.write('\r\n');
        request.write(data);
      } else {
        request.write('what the fuck is this shit?');
      }
    }).onError((err) {
      print('some done fucked up son: $err');
    });
  }
}
