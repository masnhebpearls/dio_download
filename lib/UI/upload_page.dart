import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio_flutter/api_request/api_request_bloc.dart';
import 'package:dio_flutter/api_request/api_request_event.dart';
import 'package:dio_flutter/api_request/api_request_state.dart';
import 'package:dio_flutter/routes/route.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';


@RoutePage()
class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => ApiRequestBloc()..add(NavigateToUploadEvent()),
      child: Scaffold(
        body: BlocConsumer<ApiRequestBloc, ApiRequestState>(
          listener: (context, state) {
            if (state is UploadedState){
              AutoRouter.of(context).pushAndPopUntil(const MainPageRoute(children: [DownloadPageRoute()]), predicate: (route)=>false);
            }
            // TODO: implement listener
          },
          buildWhen: (current, previous) => current!=previous,
          builder: (context, state) {
            switch(state.runtimeType){
              case(const (UploadingState)):
                return Center(
                  child: SizedBox(
                    width: width*0.6,
                    height: height*0.3,
                    child: LiquidCircularProgressIndicator(
                      value: (state as UploadingState).progress/100, // Defaults to 0.5.
                      valueColor: const AlwaysStoppedAnimation(Colors.pink), // Defaults to the current Theme's accentColor.
                      backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
                      borderColor: Colors.red,
                      borderWidth: 5.0,
                      direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                      center: Text('uploaded ${state.progress} %'),
                    ),
                  )
                );

              case(const (UploadFailure)):
                return  Center(
                  child: Text((state as UploadFailure).errorMessage),
                );

              case(const (UploadInitialPageState)):
                return Center(
                  child: InkWell(
                    onTap: (){
                      context.read<ApiRequestBloc>().add(ImageSelectionEvent());
                    },
                    child: Container(
                      width: width*0.5,
                      height: height*0.075,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width*0.075),
                        color: Colors.amber
                      ),
                      child: const Center(child: Text("Select image",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.black
                      ),
                      )),
                    ),
                  ),
                );
              case(const (ImageSelectedState)):
                return Padding(
                  padding: EdgeInsets.only(top: height*0.1),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          width: width*0.8,
                          height: height*0.65,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(width*0.075)
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(width*0.075),
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Image.file(File(context.read<ApiRequestBloc>().file!.path)),
                            ),

                          ),


                        ),
                        SizedBox(
                          height: height*0.025,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: (){
                                  context.read<ApiRequestBloc>().add(UploadCancelEvent());
                                },
                                child: Container(
                                  width: width*0.35,
                                  height: height*0.05,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(width*0.05),
                                      color: Colors.amber
                                  ),
                                  child: const Center(child: Text("cancel",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black
                                    ),
                                  )),
                                ),
                              ),
                              SizedBox(
                                width: width*0.05,
                              ),
                              InkWell(
                                onTap: (){
                                  context.read<ApiRequestBloc>().add(UploadPhotoEvent());
                                },
                                child: Container(
                                  width: width*0.35,
                                  height: height*0.05,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(width*0.05),
                                      color: Colors.amber
                                  ),
                                  child: const Center(child: Text("upload",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black
                                    ),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        )


                      ],
                    ),
                  ),
                );
              case(const (UploadedState)):
                return const Center(
                  child: Text("Uploaded"),
                );
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
    );
  }
}
