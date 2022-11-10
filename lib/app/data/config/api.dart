class Api {
  //* Creating instance constructor;
  static Api instance = Api();
  //* Base API URL
  static const domain = "http://192.168.97.140/mamuju-api/public";
  // static const baseURL = domain + "/public/api";
  // static const imageURL = "$domain/public/storage/product_photos_thumb";
  // static const imageUserURL = "$domain/public/storage/user_photos_thumb";

  // static const domain = "https://haha.tiketkt.com";
  static const baseURL = "$domain/api";
  static const imageURL = "$domain/storage/product_photos_thumb";
  static const imageUserURL = "$domain/storage/user_photos_thumb";

  String getOfficesUrl = "$baseURL/offices";
  String getAttendancesUrl = "$baseURL/attendances";
}
