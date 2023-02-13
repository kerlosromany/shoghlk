import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shoghlak/domin/use_cases/comment/create_comment_usecase.dart';
import 'package:shoghlak/domin/use_cases/comment/delete_comment_usecase.dart';
import 'package:shoghlak/domin/use_cases/comment/read_comments_usecase.dart';
import 'package:shoghlak/domin/use_cases/post/create_post_usecase.dart';
import 'package:shoghlak/domin/use_cases/post/delete_post_usecase.dart';
import 'package:shoghlak/domin/use_cases/post/like_post_usecase.dart';
import 'package:shoghlak/domin/use_cases/post/read_posts_usecase.dart';
import 'package:shoghlak/domin/use_cases/post/read_single_post_usecase.dart';
import 'package:shoghlak/domin/use_cases/post/update_post_usecase.dart';
import 'package:shoghlak/domin/use_cases/reply/create_reply_usecase.dart';
import 'package:shoghlak/domin/use_cases/reply/delete_reply_usecase.dart';
import 'package:shoghlak/domin/use_cases/reply/read_replys_usecase.dart';
import 'package:shoghlak/domin/use_cases/reply/update_reply_usecase.dart';
import 'package:shoghlak/domin/use_cases/storage/upload_image_to_storage_usecase.dart';
import 'package:shoghlak/presentation/cubits/auth/auth_cubit.dart';
import 'package:shoghlak/presentation/cubits/comment/comment_cubit.dart';
import 'package:shoghlak/presentation/cubits/credential/credential_cubit.dart';
import 'package:shoghlak/presentation/cubits/post/post_cubit.dart';
import 'package:shoghlak/presentation/cubits/post/single_post/single_post_cubit.dart';
import 'package:shoghlak/presentation/cubits/reply/reply_cubit.dart';
import 'package:shoghlak/presentation/cubits/ui/ui_cubit.dart';
import 'package:shoghlak/presentation/cubits/user/get_single_user/get_single_user_cubit.dart';
import 'package:shoghlak/presentation/cubits/user/user_cubit.dart';

import 'data/data_sources/remote_data_source/remote_data_source.dart';
import 'data/data_sources/remote_data_source/remote_data_source_impl.dart';
import 'data/repository/firebase_repository_impl.dart';
import 'domin/repository/firebase_repository.dart';
import 'domin/use_cases/comment/like_comment_usecase.dart';
import 'domin/use_cases/comment/update_comment_usecase.dart';
import 'domin/use_cases/post/save_post_usecase.dart';
import 'domin/use_cases/user/create_user_usecase.dart';
import 'domin/use_cases/user/get_current_uid_usecase.dart';
import 'domin/use_cases/user/get_single_user_usecase.dart';
import 'domin/use_cases/user/get_users_usecase.dart';
import 'domin/use_cases/user/is_sign_in_usecase.dart';
import 'domin/use_cases/user/sign_in_usecase.dart';
import 'domin/use_cases/user/sign_out_usecase.dart';
import 'domin/use_cases/user/sign_up_usecase.dart';
import 'domin/use_cases/user/update_user_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerFactory(
    () => AuthCubit(
      signOutUseCase: sl.call(),
      isSignInUseCase: sl.call(),
      getCurrentUidUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => CredentialCubit(
      signUpUseCase: sl.call(),
      signInUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => UserCubit(updateUserUseCase: sl.call(), getUsersUseCase: sl.call()),
  );

  sl.registerFactory(
    () => GetSingleUserCubit(getSingleUserUseCase: sl.call()),
  );

  //post cubit injection
  sl.registerFactory(
    () => PostCubit(
      createPostUseCase: sl.call(),
      deletePostUseCase: sl.call(),
      likePostUseCase: sl.call(),
      readPostsUseCase: sl.call(),
      updatePostUseCase: sl.call(),
      savePostUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => GetSinglePostCubit(readSinglePostUseCase: sl.call()),
  );

  //comment cubit injection
  sl.registerFactory(
    () => CommentCubit(
      createCommentUseCase: sl.call(),
      deleteCommentUseCase: sl.call(),
      likeCommentUseCase: sl.call(),
      readCommentsUseCase: sl.call(),
      updateCommentUseCase: sl.call(),
    ),
  );

  //reply cubit injection
  sl.registerFactory(
    () => ReplyCubit(
      createReplyUseCase: sl.call(),
      deleteReplyUseCase: sl.call(),
      readReplysUseCase: sl.call(),
      updateReplyUseCase: sl.call(),
    ),
  );

  //Ui cubit injection //////////////////////////todo
  // sl.registerFactory(
  //   () => UiCubit(),
  // );

  // Use Cases
  sl.registerLazySingleton(() => SignOutUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => IsSignInUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => GetCurrentUidUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(() => SignUpUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(() => SignInUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => UpdateUserUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => GetUsersUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => CreateUserUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => GetSingleUserUseCase(firebaseRepository: sl.call()));
  // Repository

  // cloud storage
  sl.registerLazySingleton(
      () => UploadImageToStorageUseCase(firebaseRepository: sl.call()));

  // post use case
  sl.registerLazySingleton(
      () => CreatePostUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => DeletePostUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => ReadPostsUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => ReadSinglePostUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => UpdatePostUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => LikePostUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => SavePostUseCase(firebaseRepository: sl.call()));

  // comment use cases
  sl.registerLazySingleton(
      () => CreateCommentUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => DeleteCommentUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => ReadCommentsUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => UpdateCommentUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => LikeCommentUseCase(firebaseRepository: sl.call()));

  // reply use cases
  sl.registerLazySingleton(
      () => CreateReplyUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => DeleteReplyUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => UpdateReplyUseCase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(
      () => ReadReplysUseCase(firebaseRepository: sl.call()));

  // firebase repo
  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(remoteDataSource: sl.call()));

  // Remote Data Source
  sl.registerLazySingleton<FirebaseRemoteDataSource>(() =>
      FirebaseRemoteDataSourceImpl(
          firebaseStorage: sl.call(),
          firebaseFirestore: sl.call(),
          firebaseAuth: sl.call()));

  // Externals

  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firebaseStorage);
}
