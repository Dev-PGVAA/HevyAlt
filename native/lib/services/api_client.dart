import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class ApiClient {
  final Dio dio;
  final CookieJar cookieJar;

  ApiClient._(this.dio, this.cookieJar);

  static Future<ApiClient> create({required String baseUrl}) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Allow self-signed for local dev if needed
    (dio.httpClientAdapter as IOHttpClientAdapter)
        .onHttpClientCreate = (client) {
      // client.badCertificateCallback = (cert, host, port) => true; // enable only in debug
      return client;
    };

    // Use persistent cookie jar to avoid runtime load errors on mobile
    final dir = await getApplicationSupportDirectory();
    final cookieJar = PersistCookieJar(
      storage: FileStorage('${dir.path}/cookies'),
    );
    dio.interceptors.add(CookieManager(cookieJar));

    return ApiClient._(dio, cookieJar);
  }
}
