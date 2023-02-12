import 'package:shoghlak/domin/entities/reply/reply.dart';

import '../../entities/comment/comment_entity.dart';
import '../../entities/post/post_entity.dart';
import '../../repository/firebase_repository.dart';

class CreateReplyUseCase {
  final FirebaseRepository firebaseRepository;

  CreateReplyUseCase({required this.firebaseRepository});

  Future<void> call(ReplyEntity reply) {
    return firebaseRepository.createReply(reply);
  }
}
