class Api {
  //* Creating instance constructor;
  static Api instance = Api();
  //* Base API URL
  static const domain = "http://192.168.41.140/mamuju-api-v8/public";
  // static const baseURL = domain + "/public/api";
  // static const imageURL = "$domain/public/storage/product_photos_thumb";
  // static const imageUserURL = "$domain/public/storage/user_photos_thumb";

  // static const domain = "https://sikeren.mamujukab.go.id";
  static const baseURL = "$domain/api";
  static const imageURL = "$domain/storage/product_photos_thumb";
  static const imageUserURL = "$domain/storage/user_photos_thumb";

  String getOfficesUrl = "$baseURL/offices";
  String getAttendancesUrl = "$baseURL/attendances";
  String loginUrl = "$baseURL/login";
  String presensiUrl = "$baseURL/presensi";
  String userByNipUrl = "$baseURL/user";
}
