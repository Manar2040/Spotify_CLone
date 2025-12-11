import 'dart:io';

import 'package:client/core/constants/server_constant.dart';
import 'package:http/http.dart' as http;

class HomeRepository {
  Future<void> uploadSong(File selectedImage, File selectedAudio) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ServerConstant.sevrerURL}/song/upload'),
    );

    request
      ..files.addAll([
        await http.MultipartFile.fromPath('song', selectedAudio.path),
        await http.MultipartFile.fromPath('thumbnail', selectedImage.path),
      ])
      ..fields.addAll({
        'artist': 'Imagine Dragons',
        'song_name': 'Believer',
        'hex_code': 'FFFFFF',
      })
      ..headers.addAll({
        'x-auth-token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjEyYmRmODk2LTMzNDEtNGJkYy1hMjA1LTk1ZjhiMmY0MTY0MCJ9.bz3-hM97PeEEeE4rQnkCNR_wjvpqeMYekDTrmmBHjvw',
      });

    final res = await request.send();
    print(res);
  }
}
