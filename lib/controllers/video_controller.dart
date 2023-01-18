import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tiktok_clone/constants.dart';
import 'package:flutter_tiktok_clone/models/video.dart';
import 'package:get/get.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);
  List<Video> get videoList => _videoList.value;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _videoList.bindStream(
      firestore.collection('videos').snapshots().map(
        (QuerySnapshot query) {
          List<Video> retval = [];
          for (var element in query.docs) {
            retval.add(Video.fromSnap(element));
          }
          return retval;
        },
      ),
    );
  }

  likeVideo(String id) async {
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
    var uid = authController.user.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore.collection('videos').doc(id).update(
        {
          'likes': FieldValue.arrayRemove([uid]),
        },
      );
    } else {
      await firestore.collection('videos').doc(id).update(
        {
          'likes': FieldValue.arrayUnion([uid]),
        },
      );
    }
  }
}
