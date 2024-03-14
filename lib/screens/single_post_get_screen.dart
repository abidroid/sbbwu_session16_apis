import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sbbwu_session16_apis/models/post_model.dart';
import 'package:http/http.dart' as http;

class SinglePostGetScreen extends StatefulWidget {
  const SinglePostGetScreen({super.key});

  @override
  State<SinglePostGetScreen> createState() => _SinglePostGetScreenState();
}

class _SinglePostGetScreenState extends State<SinglePostGetScreen> {


  Future<PostModel> getSinglePost() async {

   try{
     String url = 'https://jsonplaceholder.typicode.com/posts/5';

     // api call
     http.Response response = await http.get( Uri.parse(url ));

     if( response.statusCode == 200 ){
       print('status code is 200');

       var jsonResponse = jsonDecode(response.body);

       // convert into PostModel

       PostModel postModel = PostModel.fromJson(jsonResponse);
       // and the return

       await Future.delayed(const Duration(seconds: 3));
       return postModel;

     }else{
       throw Exception('Something went wrong');
     }
   } catch (e){
     print(e.toString());

     return PostModel();
   }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Single Get Request'),
      ),

      body: FutureBuilder<PostModel>(
          future: getSinglePost(),
          builder: (context, snapshot){


            if( snapshot.hasData){

              PostModel postModel = snapshot.data!;

              return Card(
                child: Column(
                  children: [
                    Text(postModel.title!, style: const TextStyle(fontSize: 20),),
                    const Divider(),
                    Text(postModel.body!, style: const TextStyle(fontSize: 20),),

                  ],
                ),
              );
            }
            else if( snapshot.hasError){
              return const Center(child: Text('Something went wrong'));

            }
            else {
              return const Center(child: SpinKitSpinningLines(color: Colors.deepOrange));
            }

          }),
    );
  }
}
