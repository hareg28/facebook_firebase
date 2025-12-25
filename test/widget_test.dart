
import 'package:flutter/material.dart';

void main() => runApp(FacebookClone());

class FacebookClone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FacebookHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FacebookHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facebook', style: TextStyle(color: Colors.blue)),
        backgroundColor: Colors.white,
        actions: [
          Icon(Icons.notifications, color: Colors.black),
          Icon(Icons.search, color: Colors.black),
          Icon(Icons.menu, color: Colors.black),
        ],
      ),
      body: ListView(
        children: [
          _statusUpdateSection(),
          _storySection(),
          _postCard(),
        ],
      ),
    );
  }

  Widget _statusUpdateSection() {
    return ListTile(
      leading: CircleAvatar(backgroundImage: AssetImage('assets/user.jpg')),
      title: Text("What's on your mind?"),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _iconText(Icons.videocam, "Live", Colors.red),
          _iconText(Icons.photo, "Photo", Colors.green),
          _iconText(Icons.emoji_emotions, "Feeling", Colors.orange),
        ],
      ),
    );
  }

  Widget _storySection() {
    return Container(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(5, (index) {
          return Container(
            width: 80,
            margin: EdgeInsets.all(8),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(radius: 30, backgroundImage: AssetImage('assets/user.jpg')),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(radius: 10, child: Icon(Icons.add, size: 12)),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text("Your Story", style: TextStyle(fontSize: 12)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _postCard() {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(backgroundImage: AssetImage('assets/user.jpg')),
            title: Text("User Name"),
            subtitle: Text("22 minutes ago • 🌍"),
          ),
          Image.asset('assets/scenic.jpg'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _iconText(Icons.thumb_up, "Like", Colors.grey),
                _iconText(Icons.comment, "Comment", Colors.grey),
                _iconText(Icons.share, "Share", Colors.grey),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text("1 Comment", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _iconText(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
