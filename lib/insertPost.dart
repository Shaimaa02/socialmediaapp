import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InsertPostScreen extends StatefulWidget {
  final String loggedInUserId;
  final VoidCallback fetchPosts;

  InsertPostScreen({required this.loggedInUserId, required this.fetchPosts});

  @override
  _InsertPostScreenState createState() => _InsertPostScreenState();
}

class _InsertPostScreenState extends State<InsertPostScreen> {
  TextEditingController postTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text(
              'Add a New Post',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: postTextController,
                    decoration: InputDecoration(
                      hintText: 'Enter your post here...',
                    ),
                    maxLines: null,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _submitPost();
                    },
                    child: Text('Submit Post'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitPost() async {
    String postText = postTextController.text;

    final response = await http.post(
      Uri.parse('https://shaimaa09.000webhostapp.com/addPost.php'),
      headers: {'Content-Type': 'application/json'}, // 3m bb3ta ka json array
      body: jsonEncode({
        'userId': widget.loggedInUserId,
        'text': postText,
      }),
    );

    if (response.statusCode == 200) {
      print('Post submitted successfully');
      print(widget.loggedInUserId);

      widget.fetchPosts(); // 3shn el display posts t3ml refresh

      Navigator.pop(context);
    } else {
      print('Failed to submit post. Error: ${response.reasonPhrase}');
    }
  }
}