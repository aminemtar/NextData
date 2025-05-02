import 'package:android_flutter_test/Data/colors.dart';
import 'package:android_flutter_test/Models/post.dart';
import 'package:android_flutter_test/ViewModel/auth_view_model.dart';
import 'package:android_flutter_test/Views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:android_flutter_test/ViewModel/post_view_model.dart';
import 'package:android_flutter_test/Views/post_detail_screen.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 1;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildNavIcon(IconData icon, int index) {
    final isSelected = index == _selectedIndex;
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey[200] : Colors.transparent,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(8),
      child: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    final postVM = Provider.of<PostViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black87),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Menu tapped')),
                    );
                  },
                ),
                const SizedBox(width: 4),
                const Text(
                  'Browse posts',
                  style: TextStyle(
                    color: AppColors.appbar,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: "Poppins",
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.black87),
              tooltip: 'Logout',
              onPressed: () {
                final authVM = Provider.of<AuthViewModel>(
                  context,
                  listen: false,
                );
                authVM.logout(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.searchbar,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: postVM.filterPosts,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Icon(Icons.search, color: Colors.grey[700]),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child:
            postVM.isLoading
                ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.blue,
                    strokeWidth: 3,
                  ),
                )
                : postVM.posts.isEmpty
                ? const Center(child: Text('No posts found.'))
                : Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: postVM.posts.length,
                    itemBuilder: (context, index) {
                      final Post post = postVM.posts[index];
                      final String userName = postVM.getUserName(post.userId);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
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
                                    child: SvgPicture.asset(
                                      'assets/images/User.svg',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    userName,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.copyWith(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12.0),
                              Text(
                                post.title,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  color: AppColors.titre,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins",
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                post.body.replaceAll('\n', ' '),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.description,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/post-icon.svg',
                                    width: 16,
                                    height: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'POST ID : ${post.id.toString()}',
                                    style: const TextStyle(
                                      fontFamily: "Inter",
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.postId,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => PostDetailScreen(post: post),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFEAF1FD),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text(
                                    'Detail',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.home, 0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.article, 1),
            label: 'Posts',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.explore, 2),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.person, 3),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
