// A mock of the website behind the example's App Links and Universal Links.
//
//   cd example
//   dart run tool/link_server/server.dart            # http://0.0.0.0:8080
//   dart run tool/link_server/server.dart --port 9000
//
// It serves:
//
//   /                                         a page of test links (public/index.html)
//   /.well-known/assetlinks.json              what Android fetches to verify App Links
//   /.well-known/apple-app-site-association   what iOS fetches to verify Universal Links
//
// Open the page in the example's "Deep link tester" (an in-app WebView), or in
// the device browser: Android emulator http://10.0.2.2:8080, iOS simulator
// http://localhost:8080.
//
// The OS only verifies a domain over HTTPS with a valid certificate, so this
// server alone cannot make https://nav.example.com links open the app. To try
// real verification, expose it through an HTTPS tunnel (for example
// `cloudflared tunnel --url http://localhost:8080` or `ngrok http 8080`), put
// the tunnel's host name in AndroidManifest.xml and in the iOS Associated
// Domains entitlement, and fill in the placeholders in public/.well-known/.
import 'dart:io';

/// Content types for files whose extension does not say. The OS rejects
/// apple-app-site-association unless it is served as JSON.
const _contentTypes = {
  '.html': 'text/html; charset=utf-8',
  '.json': 'application/json',
  'apple-app-site-association': 'application/json',
};

Future<HttpServer> serve({
  int port = 8080,
  InternetAddress? address,
  Directory? root,
}) async {
  final publicDir =
      root ?? Directory.fromUri(Platform.script.resolve('public/'));
  final server =
      await HttpServer.bind(address ?? InternetAddress.anyIPv4, port);
  server.listen((request) async {
    final path = request.uri.path == '/' ? '/index.html' : request.uri.path;
    final file = File('${publicDir.path}$path');
    final response = request.response;
    if (path.contains('..') || !await file.exists()) {
      response.statusCode = HttpStatus.notFound;
      response.write('Not found: ${request.uri.path}');
    } else {
      final name = file.uri.pathSegments.last;
      final extension =
          name.contains('.') ? name.substring(name.lastIndexOf('.')) : name;
      response.headers.set(HttpHeaders.contentTypeHeader,
          _contentTypes[extension] ?? 'application/octet-stream');
      await response.addStream(file.openRead());
    }
    stdout
        .writeln('${request.method} ${request.uri} -> ${response.statusCode}');
    await response.close();
  });
  return server;
}

Future<void> main(List<String> args) async {
  final portIndex = args.indexOf('--port');
  final port = portIndex == -1 ? 8080 : int.parse(args[portIndex + 1]);
  final server = await serve(port: port);
  stdout.writeln(
      'Link server on http://${server.address.address}:${server.port}');
  stdout.writeln('  Android emulator: http://10.0.2.2:${server.port}');
  stdout.writeln('  iOS simulator:    http://localhost:${server.port}');
}
