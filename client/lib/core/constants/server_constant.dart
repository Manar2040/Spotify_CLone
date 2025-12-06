import 'dart:io';

class ServerConstant {
 static String sevrerURL = Platform.isAndroid
      ? 'http://10.0.2.2:8000'  // emulator can reach host PC via this IP
      : 'http://127.0.0.1:8000';
}