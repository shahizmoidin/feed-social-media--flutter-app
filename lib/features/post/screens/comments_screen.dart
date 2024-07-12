import 'package:feed/core/common/error_text.dart';
import 'package:feed/core/common/loader.dart';
import 'package:feed/core/common/post_card.dart';
import 'package:feed/features/auth/controller/auth_controller.dart';
import 'package:feed/features/post/controller/post_controller.dart';
import 'package:feed/features/post/widget/comment_card.dart';
import 'package:feed/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
        context: context, text: commentController.text.trim(), post: post);
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (post) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: PostCard(post: post),
                  ),
                  if (!isGuest)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          onSubmitted: (val) => addComment(post),
                          controller: commentController,
                          decoration: const InputDecoration(
                            hintText: 'What are your thoughts?',
                            filled: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ref.watch(getPostCommentsProvider(widget.postId)).when(
                        data: (comments) {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final comment = comments[index];
                                return CommentCard(comment: comment);
                              },
                              childCount: comments.length,
                            ),
                          );
                        },
                        error: (error, stackTrace) => SliverToBoxAdapter(
                          child: ErrorText(
                            error: error.toString(),
                          ),
                        ),
                        loading: () => const SliverToBoxAdapter(
                          child: Loader(),
                        ),
                      ),
                ],
              );
            },
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
      bottomNavigationBar: isGuest
          ? null
          : Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
            ),
    );
  }
}
