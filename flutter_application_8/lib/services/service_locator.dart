import 'package:get_it/get_it.dart';

import 'api_service.dart';
import 'custom_dio.dart';


final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<CustomDio>(CustomDio());
  getIt.registerSingleton<ApiService>(ApiService(getIt<CustomDio>().createDio()));
}
