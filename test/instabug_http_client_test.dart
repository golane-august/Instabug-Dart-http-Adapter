import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:instabug_http_client/instabug_http_client.dart';
import 'package:instabug_http_client/instabug_http_logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'instabug_http_client_test.mocks.dart';

@GenerateMocks([
  InstabugHttpLogger,
  InstabugHttpClient,
])
Future<void> main() async {
  const Map<String, String> fakeResponse = <String, String>{
    'id': '123',
    'activationCode': '111111',
  };
  late Uri url;
  final http.Response mockedResponse =
      http.Response(json.encode(fakeResponse), 200);
  late InstabugHttpClient instabugHttpClient;

  setUp(() {
    url = Uri.parse('http://www.instabug.com');
    instabugHttpClient = InstabugHttpClient();
    instabugHttpClient.client = MockInstabugHttpClient();
    instabugHttpClient.logger = MockInstabugHttpLogger();
  });

  test('expect instabug http client GET to return response', () async {
    when<dynamic>(instabugHttpClient.client.get(url))
        .thenAnswer((_) async => mockedResponse);
    final http.Response result = await instabugHttpClient.get(url);
    expect(result, isInstanceOf<http.Response>());
    expect(result, mockedResponse);
    verify(instabugHttpClient.logger
            .onLogger(mockedResponse, startTime: anyNamed('startTime')))
        .called(1);
  });

  test('expect instabug http client HEAD to return response', () async {
    when<dynamic>(instabugHttpClient.client.head(url))
        .thenAnswer((_) async => mockedResponse);
    final http.Response result = await instabugHttpClient.head(url);
    expect(result, isInstanceOf<http.Response>());
    expect(result, mockedResponse);
    verify(instabugHttpClient.logger
            .onLogger(mockedResponse, startTime: anyNamed('startTime')))
        .called(1);
  });

  test('expect instabug http client DELETE to return response', () async {
    when<dynamic>(instabugHttpClient.client.delete(url))
        .thenAnswer((_) async => mockedResponse);
    final http.Response result = await instabugHttpClient.delete(url);
    expect(result, isInstanceOf<http.Response>());
    expect(result, mockedResponse);
    verify(instabugHttpClient.logger
            .onLogger(mockedResponse, startTime: anyNamed('startTime')))
        .called(1);
  });

  test('expect instabug http client PATCH to return response', () async {
    when<dynamic>(instabugHttpClient.client.patch(url))
        .thenAnswer((_) async => mockedResponse);
    final http.Response result = await instabugHttpClient.patch(url);
    expect(result, isInstanceOf<http.Response>());
    expect(result, mockedResponse);
    verify(instabugHttpClient.logger
            .onLogger(mockedResponse, startTime: anyNamed('startTime')))
        .called(1);
  });

  test('expect instabug http client POST to return response', () async {
    when<dynamic>(instabugHttpClient.client.post(url))
        .thenAnswer((_) async => mockedResponse);
    final http.Response result = await instabugHttpClient.post(url);
    expect(result, isInstanceOf<http.Response>());
    expect(result, mockedResponse);
    verify(instabugHttpClient.logger
            .onLogger(mockedResponse, startTime: anyNamed('startTime')))
        .called(1);
  });

  test('expect instabug http client PUT to return response', () async {
    when<dynamic>(instabugHttpClient.client.put(url))
        .thenAnswer((_) async => mockedResponse);
    final http.Response result = await instabugHttpClient.put(url);
    expect(result, isInstanceOf<http.Response>());
    expect(result.body, mockedResponse.body);
    verify(instabugHttpClient.logger
            .onLogger(mockedResponse, startTime: anyNamed('startTime')))
        .called(1);
  });

  test('expect instabug http client READ to return response', () async {
    const String response = 'Some response string';
    when<dynamic>(instabugHttpClient.client.read(url))
        .thenAnswer((_) async => response);

    final String result = await instabugHttpClient.read(url);
    expect(result, isInstanceOf<String>());
    expect(result, response);
  });

  test('expect instabug http client READBYTES to return response', () async {
    final Uint8List response = Uint8List(3);
    instabugHttpClient.client =
        MockClient((_) async => http.Response.bytes(response, 200));

    final Uint8List result = await instabugHttpClient.readBytes(url);
    expect(result, isInstanceOf<Uint8List>());
    expect(result, response);
  });

  test('expect instabug http client SEND to return response', () async {
    final http.StreamedResponse response =
        http.StreamedResponse(Stream.empty(), 200);
    final http.StreamedRequest request = http.StreamedRequest('POST', url)
      ..headers[HttpHeaders.contentTypeHeader] =
          'application/json; charset=utf-8'
      ..headers[HttpHeaders.userAgentHeader] = 'Dart';
    when<dynamic>(instabugHttpClient.client.send(request))
        .thenAnswer((_) async => response);
    final Future<http.StreamedResponse> responseFuture =
        instabugHttpClient.send(request);
    request
      ..sink.add('{"hello": "world"}'.codeUnits)
      ..sink.close();

    final http.StreamedResponse result = await responseFuture;
    expect(result, response);
    verifyNever(instabugHttpClient.logger
        .onLogger(mockedResponse, startTime: anyNamed('startTime')));
  });

  test('expect instabug http client CLOSE to be called', () async {
    instabugHttpClient.close();

    verify(instabugHttpClient.client.close());
  });

  test('stress test for GET method', () async {
    when<dynamic>(instabugHttpClient.client.get(url))
        .thenAnswer((_) async => mockedResponse);
    for (int i = 0; i < 10000; i++) {
      await instabugHttpClient.get(url);
    }
    verify(instabugHttpClient.logger
            .onLogger(mockedResponse, startTime: anyNamed('startTime')))
        .called(10000);
  });
}
