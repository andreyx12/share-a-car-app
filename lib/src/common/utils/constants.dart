
class Constants {

  static const String BASE_URL = "shareacarcr.somee.com";

  static const String EMPTY_STRING = '';

  static const String GOOGLE_API_KEY = 'AIzaSyAuyOTDROStc-TROS7qrrw2IBiBWT3IZ18';

  /* Tiempo en minutos que tiene un ciente para llegar a un vehículo */
  static const int MAX_ARRIVAL_TIME_IN_MINUTES = 15;

  /* Costantes para zoom del mapa */
  static const double DEFAULT_MAP_ZOOM_OUT = 12;
  static const double DEFAULT_MAP_ZOOM_IN = 19;

  /* Path de los íconos de markers del mapa */
  static const String PICK_UP_MARKER_ICON = "assets/images/pickupmarker.png";
  static const String DROP_OFF_MARKER_ICON = "assets/images/dropoffmarker.png";

  /* Path imágenes default */
  static const String LOADING_IMAGE_PATH = "assets/images/loading-image.gif";
  static const String PLACEHOLDER_IMAGE_PATH = "assets/images/no_image.png";
  
  static const String PLACEHOLDER_PROFILE_IMAGE_PATH = "assets/images/profile_no_image.png";

  static const String SPLASH_SCREEN = "assets/images/splash.png";

  /* Llaves del localstorage */
  static const String USERNAME = "username";
  static const String USER_ID = "userId";

  /* Constantes de estados de licencia */
  static const String DRIVER_LICENSE_STATUS_NOT_REGISTERED = "notRegistered";
  static const String DRIVER_LICENSE_STATUS_APPROVED = "approved";
  static const String DRIVER_LICENSE_STATUS_PENDING = "pending";
  static const String DRIVER_LICENSE_STATUS_DENIED = "denied";

  /* Constantes de estado del viaje */
  static const String SHARE_A_CAR_RESERVED = "reserved";
  static const String SHARE_A_CAR_RENTED = "rented";
  static const String SHARE_A_CAR_COMPLETED = "completed";
  static const String SHARE_A_CAR_CANCELED = "other";

  
  /* Path de los íconos de markers del mapa */
  static const String BASIC_AUTH_VALUE = "Basic ";
  static const String AUTH_HEADER = "authorization";

  static const String RESOURCE_NOT_FOUND_ERROR_CODE = "404";

}