import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dio_flutter/api_request/api_request_bloc.dart';
import 'package:dio_flutter/api_request/api_request_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

import '../api_request/api_request_event.dart';

@RoutePage()
class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ApiRequestBloc()..add(GetImageUrl()),
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
                case(const (ViewPhotoState)):
                  return SizedBox(
                    width: width,
                    height: height,
                    child: Stack(
                      children: [


                        SizedBox(
                          width: width,
                          height: height,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(context.read<ApiRequestBloc>().imageURLs[(state as ViewPhotoState).index]),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(width*0.0125, height*0.0075, 0, 0),
                          child: IconButton(onPressed: (){
                            context.read<ApiRequestBloc>().add(ExitToPhotoGrid());
                          },
                            icon: const Icon(Icons.close, size: 35, color: Colors.white,),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(width*0.85, height*0.75, 0, 0),
                          child: FloatingActionButton(onPressed: (){
                            context.read<ApiRequestBloc>().add(DownloadPhotoEvent(state.index));
                          },
                            elevation: 5,
                            backgroundColor: Colors.white.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(width)
                            ),
                            child: const Icon(Icons.download),
                          ),
                        ),
                      ],
                    ),
                    // color: Colors.teal,

                  );



                case(const (ShowPhotosGridState)):
                  return SizedBox(
                    width: width,
                    height: height,

                    child: GridView.count(
                        crossAxisCount: 2,
                      children: List.generate(
              context.read<ApiRequestBloc>().imageURLs.length

              , (index){
                        return InkWell(
                          onTap: (){
                            context.read<ApiRequestBloc>().add(ViewPhotoEvent(index: index));
                          },
                          child: Padding(
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
                                      child: Image.network(context.read<ApiRequestBloc>().imageURLs[index]),
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
                                      context.read<ApiRequestBloc>().add(DownloadPhotoEvent(index));

                                    },
                                    ),
                                  ),
                                )
                              ],
                            ),
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
                  return Center(
                    child: SizedBox(
                      width: width,
                      height: height*0.1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(width*0.05, 0, width*0.05, 0),
                        child: LiquidLinearProgressIndicator(
                          value: (state as DownloadingState).downloaded / state.total, // Defaults to 0.5.
                          valueColor: const AlwaysStoppedAnimation(Colors.pink), // Defaults to the current Theme's accentColor.
                          backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
                          borderColor: Colors.red,
                          borderWidth: 5.0,
                          borderRadius: 12.0,
                          direction: Axis.horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                          center:  Text("Downloading ${((state.downloaded/state.total)*100).toInt()} %"),
                        )
                      ),
                      // color: Colors.blue,
                    ),
                  );

                case(const (DownloadedState)):
                  return SizedBox(
                    width: width,
                    height: height,
                    child: Stack(
                      children: [


                        SizedBox(
                          width: width,
                          height: height,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.file(File((state as DownloadedState).path)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(width*0.0125, height*0.0075, 0, 0),
                          child: IconButton(onPressed: (){
                            context.read<ApiRequestBloc>().add(ExitToPhotoGrid());
                          },
                            icon: const Icon(Icons.close, size: 35, color: Colors.white,),
                          ),
                        ),
                      ],
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
