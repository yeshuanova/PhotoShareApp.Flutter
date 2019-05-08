import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Demo',
      home: PhotoList(),
    );
  }
}

class PhotoItem {
  String postId = '';
  String imageName = '';
  String imageURL = '';
  String thumbnailName = '';
  String updateTime = '';
  String label = '';
  double prob = 0.0;
}

class PhotoList extends StatefulWidget {
  @override
  _PhotoListStatus createState() => _PhotoListStatus();
}

class _PhotoListStatus extends State<PhotoList> {
  final _databaseRef = FirebaseDatabase.instance.reference();
  final _storageRef = FirebaseStorage.instance.ref();
  final _photoItems = <PhotoItem>[];

  Widget _buildPhotoList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _photoItems.length,
        itemBuilder: (context, i) {
          return _buildRow(context, _photoItems[i]);
        });
  }

  Widget _buildRow(BuildContext context, PhotoItem item) {
    return ListTile(
      leading: _buildLeading(context, item.imageURL),
      title: Text(item.label),
      subtitle: Text(item.prob.toString()),
    );
  }

  Widget _buildLeading(BuildContext context, String imageUrl) {
    if (imageUrl.isEmpty) {
      return Icon(Icons.image);
    }
    return CircleAvatar(
      backgroundImage: NetworkImage(imageUrl),
    );
  }

  Future _receivePhotoItems() async {
    _photoItems.clear();

    final postRef = _databaseRef.child('posts').orderByChild('update_time').limitToLast(10);
    final data = await postRef.once().then((snap) => snap.value) as Map;

    if (data != null) {
      data.forEach((key, data) {
        PhotoItem item = PhotoItem();
        item.postId = key;
        item.imageName = data['image_name'];
        item.thumbnailName = data['thumbnail_name'];
        item.updateTime = data['update_time'];
        _photoItems.add(item);
      });
    }

    for (PhotoItem item in _photoItems) {
      final labelPath = 'image_info/${item.imageName}/label_detections/labels';
      final imageLabelRef = _databaseRef.child(labelPath).orderByValue().limitToLast(1);
      final data = await imageLabelRef.once().then((snap) => snap.value) as Map;

      if (data != null) {
        data.forEach((key, value) {
          item.label = key;
          item.prob = value;
        });
      }

      final url = await _storageRef.child('photos/thumbnail/${item.thumbnailName}').getDownloadURL() as String;

      item.imageURL = (url != null) ? url : "";
    }

    setState(() {});
  }

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    _receivePhotoItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase Demo")),
      body: _buildPhotoList(),
    );
  }

}
