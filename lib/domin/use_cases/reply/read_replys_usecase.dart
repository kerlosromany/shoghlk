import 'package:shoghlak/domin/entities/reply/reply.dart';

import '../../entities/comment/comment_entity.dart';
import '../../entities/post/post_entity.dart';
import '../../repository/firebase_repository.dart';

class ReadReplysUseCase {
  final FirebaseRepository firebaseRepository;

  ReadReplysUseCase({required this.firebaseRepository});

  Stream<List<ReplyEntity>> call(ReplyEntity reply) {
    return firebaseRepository.readReplys(reply);
  }
}
