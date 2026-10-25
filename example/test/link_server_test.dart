import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/link_server/server.dart';

void main() {
  late HttpServer server;
  late HttpClient client;

  setUpAll(() async {
    server = await serve(
      port: 0,
      address: InternetAddress.loopbackIPv4,
      root: Directory('tool/link_server/public'),
    );
    client = HttpClient();
  });

  tearDownAll(() async {
    client.close(force: true);
    await server.close(force: true);
  });

  Future<HttpClientResponse> get(String path) async =>
      (await client.get('127.0.0.1', server.port, path)).close();

  test('serves the test page with links the app claims', () async {
    final response = await get('/');
    expect(response.statusCode, HttpStatus.ok);
    expect(response.headers.contentType?.mimeType, 'text/html');
    final html = await response.transform(utf8.decoder).join();
    expect(html, contains('https://nav.example.com/product/42?color=blue'));
    expect(html, contains('navexample://open/product/7'));
  });

  test('serves assetlinks.json for the example package', () async {
    final response = await get('/.well-known/assetlinks.json');
    expect(response.headers.contentType?.mimeType, 'application/json');
    final json =
        jsonDecode(await response.transform(utf8.decoder).join()) as List;
    expect(json.single['target']['package_name'], 'com.example.example');
  });

  test('serves apple-app-site-association as JSON', () async {
    final response = await get('/.well-known/apple-app-site-association');
    expect(response.headers.contentType?.mimeType, 'application/json');
    final json = jsonDecode(await response.transform(utf8.decoder).join());
    expect(json['applinks']['details'].single['appIDs'],
        ['TEAMID.com.example.example']);
  });

  test('answers 404 for anything else', () async {
    final response = await get('/missing');
    expect(response.statusCode, HttpStatus.notFound);
    await response.drain<void>();
  });
}
