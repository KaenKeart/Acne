class Config {
  static const String apiBaseUrl = 'http://192.168.0.253:3000'; //Kaen
  // ใช้ IP หรือ URL ที่สามารถเข้าถึงได้จากอุปกรณ์ของคุณ
  // static const String apiBaseUrl =
  //     'http://172.20.41.0:3000'; // ตรวจสอบให้แน่ใจว่า IP และพอร์ตถูกต้อง

  static const String signinUrl = '$apiBaseUrl/signin';
  static const String loginUrl = '$apiBaseUrl/login';
}
