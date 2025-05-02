import 'package:android_flutter_test/Data/colors.dart';
import 'package:android_flutter_test/Models/post.dart';
import 'package:android_flutter_test/ViewModel/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../Models/user.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Post details',
          style: TextStyle(
            color: AppColors.appbar,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: "Poppins",
          ),
        ),
      ),
      body: Column(
        children: [
          const Divider(thickness: 0.5, color: AppColors.LightGrey, height: 1),
          Expanded(
            child: FutureBuilder<User?>(
              future: Provider.of<PostViewModel>(
                context,
                listen: false,
              ).fetchUserById(post.userId),
              builder: (context, snapshot) {
                final userName = snapshot.data?.name ?? 'Leanne Graham';

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 31,
                            height: 31,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset('assets/images/User.svg'),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4B73E3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Title :',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.titre,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        post.title,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.titre,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'body :',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.titre,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        post.body.replaceAll('\n', ' '),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.titre,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Divider(thickness: 1),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/post-icon.svg',
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'POST ID : ${post.id}',
                            style: const TextStyle(
                              fontFamily: "Inter",
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.postId,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'USER ID : ${post.userId}',
                            style: const TextStyle(
                              fontFamily: "Inter",
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.postId,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
