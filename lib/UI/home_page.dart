import 'dart:io';

import 'package:dio_flutter/api_request/api_request_bloc.dart';
import 'package:dio_flutter/api_request/api_request_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api_request/api_request_event.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<String> images =[
    'https://images.unsplash.com/photo-1617854818583-09e7f077a156?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1624555130581-1d9cca783bc0?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1591154669695-5f2a8d20c089?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1587691592099-24045742c181?q=80&w=2073&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1605496036006-fa36378ca4ab?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ];

  List<String> downloadUrlList =[
    'https://unsplash.com/photos/s5kTY-Ve1c0/download?ixid=M3wxMjA3fDB8MXxzZWFyY2h8Mnx8dXJsfGVufDB8fHx8MTcxODcxNTMyOXww&force=true',
    'https://unsplash.com/photos/2pPw5Glro5I/download?ixid=M3wxMjA3fDB8MXxzZWFyY2h8NHx8dXJsfGVufDB8fHx8MTcxODcxNTMyOXww&force=true',
    'https://unsplash.com/photos/rNqs9hM0U8I/download?ixid=M3wxMjA3fDB8MXxzZWFyY2h8N3x8dXJsfGVufDB8fHx8MTcxODcxNTMyOXww&force=true',
    'https://unsplash.com/photos/b9-odQi5oDo/download?ixid=M3wxMjA3fDB8MXxzZWFyY2h8Nnx8dXJsfGVufDB8fHx8MTcxODcxNTMyOXww&force=true',
    'https://unsplash.com/photos/KW0rZJojScM/download?ixid=M3wxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNzE4NzcyMjg3fA&force=true'

  ];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ApiRequestBloc(),
      child: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text("Photo library"),),
            elevation: 0,
          ),
          body: BlocConsumer<ApiRequestBloc, ApiRequestState>(
            listener: (context, state) {
              if(state is DownloadedState){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.white,

                    content: Text("Image downloaded",

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black
                      ),
                    )));
              }
              if (state is DownloadErrorState){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.white,

                    content: Text("Error downloading",

                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.black
                      ),
                    )));
              }
              if (state is UnableToDownloadState){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.white,

                    content: Text("Sorry, this photo now is unable to download",

                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.black
                      ),
                    )));
              }
            },
            builder: (context, state) {
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;
              switch(state.runtimeType){
                case(const (ShowPhotosGridState)):
                  return SizedBox(
                    width: width,
                    height: height,

                    child: GridView.count(
                        crossAxisCount: 2,
                      children: List.generate(5, (index){
                        return Padding(
                          padding: EdgeInsets.fromLTRB(width*0.025,height*0.025, width*0.025, 0),
                          child: Stack(
                            children: [
                              Container(
                                width: width*0.45,
                                height: height*0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(width*0.1),
                                  color: Colors.tealAccent,

                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(width*0.1),
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: Image.network(images[index]),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0,0, width*0.025, height*0.035),
                                  child: FloatingActionButton(
                                    elevation: 5,
                                    backgroundColor: Colors.white.withOpacity(0.7),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(width)
                                    ),
                                    child: const Icon(Icons.download),
                                    onPressed: (){
                                    context.read<ApiRequestBloc>().add(DownloadPhotoEvent(downloadUrlList[index]));

                                  },
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      })


                    ),

                  );

                case(const (PreparingDownloadState)):
                  return SizedBox(
                    width: width,
                    height: height,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),

                  );
                case(const (DownloadingState)):
                  return SizedBox(
                    width: width,
                    child: Padding(
                      padding: EdgeInsets.only(left: width*0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Downloading ${(((state as DownloadingState).downloaded/ (state).total)*100).toInt()} %"),
                          Container(
                            width: width*0.9*(state).downloaded/ (state).total,
                            height: height*0.05,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(width*0.06),
                                bottomRight: Radius.circular(width*0.06)
                              ),
                              color: Colors.amber
                            ),
                          )

                        ],
                      ),
                    ),
                    // color: Colors.blue,
                  );

                case(const (DownloadedState)):
                  return SizedBox(
                    width: width,
                    height: height*0.9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(width*0.1),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.file(File((state as DownloadedState).path)),
                      ),
                    ),
                    // color: Colors.teal,

                  );

                default:
                  return SizedBox(
                    width: width,
                    height: height*0.9,
                    // color: Colors.white,

                  );
              }
            },
          )
      ),
    );
  }
}
/*
                                FloatingActionButton(onPressed: (){},
                                child: const Icon(Icons.download),
                                )
 */
