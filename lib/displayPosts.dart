import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'insertPost.dart';

class DisplayPostsScreen extends StatefulWidget {
  final String loggedInUserId;

  DisplayPostsScreen({required this.loggedInUserId});

  @override
  _DisplayPostsScreenState createState() => _DisplayPostsScreenState();
}

class _DisplayPostsScreenState extends State<DisplayPostsScreen> {
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    String baseUrl = "https://shaimaa09.000webhostapp.com/displayPosts.php";

    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      setState(() {
        posts = data.map((item) { // 3m bratibin ka array
          return Post(
            id: item['id'].toString(),
            userId: item['UserId'].toString(),
            text: item['post'].toString(),
          );
        }).toList();
      });
    } else {
      print('Failed to load posts. Error: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Posts'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return _buildPostCard(posts[index]);
        },
      ),
      floatingActionButton: FloatingActionButton( // bto5odni 3l insert
        onPressed: () {
          _navigateToInsertPostScreen();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(post.text),
            SizedBox(height: 8),
            if (post.userId == widget.loggedInUserId)
              ElevatedButton(
                onPressed: () {
                  _deletePost(post);
                },
                child: Text('Delete'),
              ),
          ],
        ),
      ),
    );
  }

  void _deletePost(Post post) async { // 3m bb3t el post id 3shn am7i mn el database
    final response = await http.post(
      Uri.parse('https://shaimaa09.000webhostapp.com/deletePost.php'),
      body: {'postId': post.id},
    );

    if (response.statusCode == 200) {
      print('Post deleted successfully');
      fetchPosts(); // Fetch posts again after deletion
    } else {
      print('Failed to delete post. Error: ${response.reasonPhrase}');
    }
  }

  void _navigateToInsertPostScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsertPostScreen(
          loggedInUserId: widget.loggedInUserId,
          fetchPosts: fetchPosts,
        ),
      ),
    );
  }
}

class Post {
  final String id;
  final String userId;
  final String text;

  Post({required this.id, required this.userId, required this.text});
}