import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreOrderService {
  FirestoreOrderService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
}
