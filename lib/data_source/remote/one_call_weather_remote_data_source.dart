import '../../core/errors/exceptions.dart';
import '../../core/network/network_handler.dart';
import '../../core/utils/string_constant.dart';
import '../../core/utils/user_current_position.dart';
import '../../locator.dart';
import '../../models/one_call_weather_model.dart';

abstract class OneCallWeatherRemoteDataSource {
  Future<OneCallWeatherModel> fetchOneCallWeather();
}

class OneCallWeatherRemoteDataSourceImpl
    implements OneCallWeatherRemoteDataSource {
  final _networkHandler = locator<AppHttpClient>();
  final _location = locator<UserCurrentPosition>();
  @override
  Future<OneCallWeatherModel> fetchOneCallWeather() async {
    await _location.getUserCurrentLocation();
    final String url = StringConstant.base_url +
        'onecall?lat=${_location.latitude}&lon=${_location.longitude}&exclude=hourly,daily&appid=${StringConstant.app_id}';
    final response = await _networkHandler.getOneCallWeather(url);

    if (response.statusCode == 200) {
      return OneCallWeatherModel.fromJson(response.body);
    } else {
      throw ServerException.fromJson(response.body);
    }
  }
}
