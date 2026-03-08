import 'dart:io';

import 'package:injectable/injectable.dart';
import '../../domain/repositories/chat_media_repository.dart';
import '../../infrastructure/datasources/chat_media_datasource.dart';

@Injectable(as: ChatMediaRepository)
class ChatMediaRepositoryImpl implements ChatMediaRepository {
  final ChatMediaDatasource _datasource;

  ChatMediaRepositoryImpl(this._datasource);

  @override
  Future<String?> uploadImage(File file) async {
    return _datasource.uploadImage(file);
  }

  @override
  Future<String?> uploadFile(File file) async {
    return _datasource.uploadFile(file);
  }

  @override
  Future<String?> downloadFile({required String url}) async {
    return _datasource.downloadFile(url: url);
  }
}
