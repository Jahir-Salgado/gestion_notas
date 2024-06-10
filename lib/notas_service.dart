import 'package:cloud_firestore/cloud_firestore.dart';
import 'nota.dart';

class NotasService {
  final CollectionReference notasCollection = FirebaseFirestore.instance.collection('notas');

  Future<void> addNota(Nota nota) {
    return notasCollection.add(nota.toMap());
  }

  Future<void> updateNota(Nota nota) {
    return notasCollection.doc(nota.id).update(nota.toMap());
  }

  Future<void> deleteNota(String id) {
    return notasCollection.doc(id).delete();
  }

  Stream<List<Nota>> getNotas() {
  return notasCollection.snapshots().map((snapshot) => snapshot.docs
      .where((doc) => doc.exists)
      .map((doc) => Nota.fromMap(doc.data() as Map<String, dynamic>, doc.id))
      .toList());
}
}