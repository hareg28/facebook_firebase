import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get a collection reference
  CollectionReference collection(String path) {
    return _firestore.collection(path);
  }

  // Get a document snapshot
  Future<DocumentSnapshot> getDocument(String collectionPath, String docId) async {
    try {
      return await _firestore.collection(collectionPath).doc(docId).get();
    } catch (e, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Firestore Get Document Error',
        fatal: false,
      );
      rethrow;
    }
  }

  // Stream a document snapshot
  Stream<DocumentSnapshot> streamDocument(String collectionPath, String docId) {
    return _firestore
        .collection(collectionPath)
        .doc(docId)
        .snapshots()
        .handleError((error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Firestore Stream Document Error',
        fatal: false,
      );
    });
  }

  // Stream a collection snapshot
  Stream<QuerySnapshot> streamCollection(String collectionPath) {
    return _firestore
        .collection(collectionPath)
        .snapshots()
        .handleError((error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Firestore Stream Collection Error',
        fatal: false,
      );
    });
  }

  // Stream collection with query
  Stream<QuerySnapshot> streamCollectionQuery(
    String collectionPath,
    Query Function(Query) queryBuilder,
  ) {
    Query query = _firestore.collection(collectionPath);
    query = queryBuilder(query);
    return query
        .snapshots()
        .handleError((error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Firestore Stream Collection Query Error',
        fatal: false,
      );
    });
  }

  // Add document
  Future<DocumentReference> addDocument(String collectionPath, Map<String, dynamic> data) async {
    try {
      return await _firestore.collection(collectionPath).add(data);
    } catch (e, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Firestore Add Document Error',
        fatal: false,
      );
      rethrow;
    }
  }

  // Update document
  Future<void> updateDocument(
    String collectionPath,
    String docId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).update(data);
    } catch (e, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Firestore Update Document Error',
        fatal: false,
      );
      rethrow;
    }
  }

  // Delete document
  Future<void> deleteDocument(String collectionPath, String docId) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).delete();
    } catch (e, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Firestore Delete Document Error',
        fatal: false,
      );
      rethrow;
    }
  }
}

