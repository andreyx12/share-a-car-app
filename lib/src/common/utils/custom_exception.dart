
class CustomException implements Exception {

  static String DEFAULT_ERROR_CODE = "00";
  static String DEFAULT_ERROR_MESSAGE = "Error de comunicación";

  String _errorCode;
  String _errorMessage;
  
  CustomException(this._errorCode, this._errorMessage);

  String get errorCode => _errorCode;

  String get errorMessage => _errorMessage;
}