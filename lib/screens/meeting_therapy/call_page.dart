import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:psychoday/screens/meeting_therapy/join_meeting.dart';
import 'package:psychoday/screens/therapy/list_therapy.dart';
import 'package:psychoday/utils/style.dart';
class Call extends StatefulWidget {

  final String channelName;
  const Call({super.key, required this.channelName});

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {

  late RtcEngine _engine;
  bool loading=false;
  String appId="cb8441630ac2453a8a1f86fe8f67559e";
  List _remoteUids=[];
  double xP=0;
  double yP=0;
  bool muted=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }


  void dispose(){
    super.dispose();
    _engine.destroy();
  }
  Future<void> init() async{
    setState(() {
      loading=true;
    });

    _engine=await RtcEngine.createWithContext(RtcEngineContext(appId));
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.Communication);
    _engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        print("channel joined");
      },

      userJoined: (uid, elapsed) {
        print("user joined : $uid");
        setState(() {
          _remoteUids.add(uid);
        });
      },

      userOffline: (uid, reason) {
        print("user offline : $uid");
        
        setState(() {
          _remoteUids.remove(uid);
        });
      },
    ));

    await _engine.joinChannel(null, widget.channelName, null, 0).then((value) {
      setState(() {
        loading=false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (loading)? const Center(
        child:CircularProgressIndicator() ,
      ):Stack(
        children: [
          Center(
              child: renderRemoteView(),
          ),
          Container(
            width: 100,
            height: 130,
            margin: const EdgeInsets.all(15),
            child: Stack(
              children: [
                Positioned(
                  top: xP,
                  left: yP,
                  child: GestureDetector(
                    onPanUpdate: (tap) {
                      setState(() {
                        xP=tap.delta.dx;
                        yP=tap.delta.dy;
                      });
                      
                    },

                    child:Container(
                      width: 120,
                      height: 150,
                      child: RtcLocalView.SurfaceView(),
                    ) 
                  ) ,
                ),
              ],
            ),
          ),

           _toolbar()
        ],
      ),
    );
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      margin:const EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //microphone
          RawMaterialButton(onPressed: () {
            _onToggleMute();
          },
          shape:const CircleBorder(),
          padding: const EdgeInsets.all(5),
          elevation: 2,
          fillColor:(muted)?Style.primary:Colors.white ,
          child: Icon(
            (muted)?Icons.mic_off:Icons.mic,
            color: (muted)?Colors.white:Style.primary,
            size: 40,
          ),
          ),

          //end meeting
          RawMaterialButton(onPressed: () {
            _onCallEnd();
          },
          shape:const CircleBorder(),
          padding: const EdgeInsets.all(5),
          elevation: 2,
          fillColor:Colors.redAccent,
          child: const Icon(Icons.call_end,
            color: Colors.white,
            size: 35,
          ),
          ),

          //camera
          RawMaterialButton(onPressed: () {
            _onSwitchCamera();
          },
          shape:const CircleBorder(),
          padding: const EdgeInsets.all(5),
          elevation: 2,
          fillColor:Colors.white,
          child: const Icon(Icons.switch_camera,
            color:Style.primary,
            size: 35,
          ),
          )
        ],
      ),
    );
  }

  Widget renderRemoteView(){
    if(_remoteUids.isNotEmpty){
      if(_remoteUids.length == 1){
        return RtcRemoteView.SurfaceView(uid: _remoteUids[0], channelId: widget.channelName);
      }else{
        if(_remoteUids.length == 2){
          return Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height:MediaQuery.of(context).size.height*0.3 ,
                child: RtcRemoteView.SurfaceView(uid: _remoteUids[0], channelId: widget.channelName),
              ),


              Container(
                width: MediaQuery.of(context).size.width,
                height:MediaQuery.of(context).size.height*0.3  ,
                child: RtcRemoteView.SurfaceView(uid: _remoteUids[1], channelId: widget.channelName),
              ),
              
              
            ],
          );
        }else{
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,

            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 11/20,
              mainAxisSpacing: 10
              ), 
              itemCount: _remoteUids.length,
              itemBuilder: ((context, index) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: RtcRemoteView.SurfaceView(uid: _remoteUids[index], channelId: widget.channelName),
                );
              })),
          );
        }
      }
    }else{
      return const Center(
        child: Text("Waiting for other user to join"),
      );
    }
  }
  
  void _onToggleMute() {
    setState(() {
      muted=!muted;  
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onCallEnd() {
    _engine.leaveChannel().then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
  }
  
  void _onSwitchCamera() {
    _engine.switchCamera();
  }
}



