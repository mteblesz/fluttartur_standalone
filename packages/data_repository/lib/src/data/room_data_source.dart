import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_repository/src/models/models.dart';

class RoomsDataSource {
  const RoomsDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Future<List<Room>> getRooms() async {
    final rooms = await _firestore.collection('rooms').get();
    return rooms.docs.map(Room.fromSnapshot).toList();
  }

  Future<void> sendRoom(Room room) =>
      _firestore.collection('rooms').add(room.toMap());

  Stream<List<Room>> get roomStream => _firestore
      .collection('rooms')
      .snapshots()
      .map((m) => m.docs.map(Room.fromSnapshot).toList());

  void getRoomByID(String id) async {
    if (id.isEmpty) return;
    final room = await _firestore.collection("rooms").doc(id).get();
    if (room.exists) {
      // TODO dolaczenie do pokoju w firebase
      print("yea");
    } else {
      print("ohnono");
    }
  }
}