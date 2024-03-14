
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sbbwu_session16_apis/models/post_model.dart';
import 'package:http/http.dart' as http;


class MultiplePostScreen extends StatefulWidget {
  const MultiplePostScreen({super.key});

  @override
  State<MultiplePostScreen> createState() => _MultiplePostScreenState();
}

class _MultiplePostScreenState extends State<MultiplePostScreen> {

  Future<List<PostModel>> getAllPosts() async {
    String url = 'https://jsonplaceholder.typicode.com/posts';

    http.Response response = await http.get(Uri.parse(url));

    if( response.statusCode == 200){

      List<PostModel> posts = [];

      var jsonResponse = jsonDecode(response.body);

      for( var jsonPost in jsonResponse){
        PostModel postModel = PostModel.fromJson(jsonPost);
        posts.add(postModel);
      }

      await Future.delayed(const Duration(seconds: 3));
      return posts;
    }else{
      throw Exception( 'SWW');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Post List'),

    ),
    body: FutureBuilder<List<PostModel>>(
      future: getAllPosts(),
      builder: (context, snapshot){
        if( snapshot.hasData){

          List<PostModel> posts = snapshot.data!;

          return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index){

                PostModel postModel = posts[index];

                return Card(
                  color: Colors.amber,
                  child: Column(
                    children: [
                      Text(postModel.title!),
                      Text(postModel.body!),

                    ],
                  ),
                );
          });

        }
        else if( snapshot.hasError){
          return const Center(child: Text('Something went wrong'));

        }
        else {
          return const Center(child: SpinKitSpinningLines(color: Colors.deepOrange,));
        }
      },
    ),
    );
  }
}
