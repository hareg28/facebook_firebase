import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'login_screen.dart';

class FacebookHomeScreen extends StatelessWidget {
  const FacebookHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar (simulated)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
            
            // Facebook Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'facebook',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1877F2),
                      letterSpacing: -0.5,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, size: 28),
                        color: Colors.black87,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, size: 28),
                        color: Colors.black87,
                        onPressed: () {},
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.settings_outlined, size: 28, color: Colors.black87),
                        onSelected: (value) async {
                          if (value == 'signout') {
                            final AuthController authController = Get.find<AuthController>();
                            await authController.signOut();
                            if (Get.context != null) {
                              Navigator.of(Get.context!).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(
                            value: 'signout',
                            child: Row(
                              children: [
                                const Icon(Icons.logout, color: Colors.red),
                                const SizedBox(width: 8),
                                const Text('Sign Out'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Navigation Bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE4E6EB), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavIcon(icon: Icons.home, isActive: true),
                  _NavIcon(icon: Icons.people_outline),
                  _NavIcon(icon: Icons.play_circle_outline),
                  _NavIcon(icon: Icons.store_outlined),
                  _NavIcon(icon: Icons.notifications_outlined),
                  _NavIcon(icon: Icons.menu),
                ],
              ),
            ),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Create Post Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey[300],
                                child: const Icon(Icons.person, color: Colors.grey),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "What's on your mind?",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _PostActionButton(
                                icon: Icons.videocam,
                                label: 'Live',
                                color: Colors.red,
                              ),
                              _PostActionButton(
                                icon: Icons.photo_library,
                                label: 'Photo',
                                color: Colors.green,
                              ),
                              _PostActionButton(
                                icon: Icons.emoji_emotions,
                                label: 'Feeling/activity',
                                color: Colors.amber,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Stories Section
                    Container(
                      height: 200,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _StoryCard(
                            isCreateStory: true,
                            imageUrl: '',
                            userName: 'Create story',
                          ),
                          _StoryCard(
                            imageUrl: '',
                            userName: 'User 1',
                          ),
                          _StoryCard(
                            imageUrl: '',
                            userName: 'User 2',
                          ),
                        ],
                      ),
                    ),
                    
                    // News Feed Post
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: _NewsFeedPost(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;

  const _NavIcon({required this.icon, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 28,
      color: isActive ? const Color(0xFF1877F2) : Colors.grey[600],
    );
  }
}

class _PostActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _PostActionButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StoryCard extends StatelessWidget {
  final bool isCreateStory;
  final String imageUrl;
  final String userName;

  const _StoryCard({
    this.isCreateStory = false,
    required this.imageUrl,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        color: Colors.grey[100],
      ),
      child: Stack(
        children: [
          // Story Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isCreateStory
                      ? [Colors.grey[300]!, Colors.grey[200]!]
                      : [Colors.blue[300]!, Colors.blue[500]!],
                ),
              ),
              child: isCreateStory
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[400],
                          child: const Icon(Icons.person, size: 30, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1877F2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 16),
                        ),
                      ],
                    )
                  : Center(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.person, size: 30, color: Colors.blue),
                      ),
                    ),
            ),
          ),
          
          // Story overlay profile picture (for non-create stories)
          if (!isCreateStory)
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue[200],
                  child: const Icon(Icons.person, size: 20, color: Colors.white),
                ),
              ),
            ),
          
          // User Name
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Text(
              userName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 3,
                    color: Colors.black26,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsFeedPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'User Name',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '22 minutes ago',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.public, size: 12, color: Colors.grey[600]),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          
          // Post Image
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue[100]!,
                  Colors.green[300]!,
                  Colors.green[500]!,
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Simulated landscape view
                Positioned(
                  bottom: 100,
                  child: Container(
                    width: 80,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.person, size: 50, color: Colors.blue),
                  ),
                ),
                // Simulated sky
                Positioned(
                  top: 0,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue[300]!,
                          Colors.blue[100]!,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Post Footer (Likes/Comments/Share)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _PostInteractionButton(
                      icon: Icons.thumb_up_outlined,
                      label: 'Like',
                      onTap: () {},
                    ),
                    _PostInteractionButton(
                      icon: Icons.comment_outlined,
                      label: 'Comment',
                      onTap: () {},
                      hasCount: true,
                      count: '1',
                    ),
                    _PostInteractionButton(
                      icon: Icons.share_outlined,
                      label: 'Share',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostInteractionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool hasCount;
  final String count;

  const _PostInteractionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.hasCount = false,
    this.count = '',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (hasCount && count.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                count,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}



