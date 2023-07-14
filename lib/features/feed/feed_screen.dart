import 'package:feed/core/common/error_text.dart';
import 'package:feed/core/common/loader.dart';
import 'package:feed/core/common/post_card.dart';
import 'package:feed/features/auth/controller/auth_controller.dart';
import 'package:feed/features/community/controller/community_controller.dart';
import 'package:feed/features/post/controller/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user=ref.watch(userProvider)!;
    final isGuest=!user.isAuthenticated;
    if(!isGuest){
    return ref.watch(userCommunitiesProvider).when(data: (data)=>ref.watch(userPostsProvider(data)).when(data:(data) {
      return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          final post=data[index];
          return PostCard(post: post) ;
        },
      );
    },  error:(error, stackTrace) =>ErrorText(error: error.toString(),) , loading: ()=>const Loader(),), error:(error, stackTrace) =>ErrorText(error: error.toString(),) , loading: ()=>const Loader(),);}
      return ref.watch(userCommunitiesProvider).when(data: (data)=>ref.watch(guestPostsProvider).when(data:(data) {
      return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          final post=data[index];
          return PostCard(post: post) ;
        },
      );
    },  error:(error, stackTrace) =>ErrorText(error: error.toString(),) , loading: ()=>const Loader(),), error:(error, stackTrace) =>ErrorText(error: error.toString(),) , loading: ()=>const Loader(),);
  }
}