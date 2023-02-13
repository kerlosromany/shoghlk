// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shoghlak/presentation/cubits/ui/ui_states.dart';

// import '../../../domin/entities/post/post_entity.dart';

// class UiCubit extends Cubit<UiStates> {
//   UiCubit() : super(UiInitialState());

//   List<PostEntity> savedPosts = [];
//   savePost({required PostEntity post}) {
//     savedPosts.add(post);
//     emit(SavePostState());
//   }

//   unSavePost({required PostEntity post}) {
//     savedPosts.remove(post);
//     emit(UnSavePostState());
//   }
// }
