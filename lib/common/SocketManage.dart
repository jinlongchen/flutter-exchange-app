import 'dart:io';
import 'dart:async';

class SocketManage {
  static String host='47.57.4.52';
  static int  port=28901;
  static Socket mSocket;
  static  Stream<List<int>> mStream;

  static initSocket() async{
    await Socket.connect(host,port).then((Socket socket)  {
      mSocket = socket;
      mStream=mSocket.asBroadcastStream();      //多次订阅的流 如果直接用socket.listen只能订阅一次
    }).catchError((e) {
      print('connectException:$e');
      initSocket();
    });
  }

  static void  addParams(List<int> params){
    mSocket.add(params);
  }

  static void dispos(){
    mSocket.close();
  }

}
