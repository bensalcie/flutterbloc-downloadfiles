import 'dart:io';

import 'package:bloclesson/counter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart' as p;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
 String _fileFullPath = "";
  bool _isLoading = false;
  final String mp3url = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
  late Dio dio;
  String progress ="";

@override
  void initState() {
    dio = Dio();

    super.initState();
  }
  Future<List<Directory>?> _getExternalStoragePath() async {
    return p.getExternalStorageDirectories(type: p.StorageDirectory.downloads);
  }
  Future _downloadAndSaveFileToStorage(BuildContext context,String url, String filename) async{
    ProgressDialog pd = ProgressDialog(context: context);

    
    try{
      //show dialog
      pd.show(max: 100, msg: 'Starting...');
      final dirList = await _getExternalStoragePath();
      final dir = dirList?[0].path;
      final file = File("$dir/$filename");
      await dio.download(url, file.path,onReceiveProgress: (count, total) {
        
        setState(() {
          _isLoading = true;
          progress = "${((count/total)*100)
          .toStringAsFixed(0)}%";
          print(progress);
          //update dialog
           int pr = (((count / total) * 100).toInt());
            pd.update(value: pr);
        });
      },);

      //hide dialog
      pd.close();
      _fileFullPath = file.path;
       

    }
    catch(e){
      print(e);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text('Counter', style: TextStyle(fontSize: 20.0)),
    ),
    body: BlocBuilder<CounterBloc,int>(
      builder: (context,count){
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: (){
                
                _downloadAndSaveFileToStorage(context,mp3url, "SoundHelix-Song-1.mp3");
              }, child: Text("Write to external storage")),
            ),
             Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Written: $_fileFullPath', style: TextStyle(fontSize: 20.0)),
            ),

            Center(
              child:Text("Currrent Count = $count",style:  TextStyle(fontSize: count.toDouble()),),
            ),
          ],
        );
      },
    ),
    floatingActionButton: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: (){
              context.read<CounterBloc>().add(CounterIncrementPressed());

            },
          ),
        ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: FloatingActionButton(
          child: const Icon(Icons.remove),
          onPressed: (){
              context.read<CounterBloc>().add(CounterDecrementPressed());

          },
        ),
           ),


      ],
      ),

    );
    
  }
}