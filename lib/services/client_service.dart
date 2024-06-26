import 'dart:io';
import 'package:catas_univalle/models/client.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> uploadClientLogo(File logo, String clientId) async {
    firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('client_images/$clientId.jpg');
    firebase_storage.UploadTask uploadTask = storageReference.putFile(logo);
    await uploadTask;
    String url = await storageReference.getDownloadURL();
    return url;
  }

  Future<void> addClient(Client client) async {
    await _db.collection('clients').doc(client.id).set({
      'name': client.name,
      'logoImgUrl': client.logoImgUrl,
      'email': client.email,
    });
  }

  Future<void> updateClient(Client client) async {
    await _db.collection('clients').doc(client.id).update({
      'name': client.name,
      'logoImgUrl': client.logoImgUrl,
      'email': client.email,
    });
  }

  Future<void> updateClientLogo(File newLogo, String clientId) async {
    String newLogoUrl = await uploadClientLogo(newLogo, clientId);
    await _db.collection('clients').doc(clientId).update({
      'logoImgUrl': newLogoUrl,
    });
  }

  Future<void> deleteClient(String clientId) async {
    await _db.collection('clients').doc(clientId).delete();
  }

  Stream<List<Client>> clientsStream() {
    return _db.collection('clients').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Client.fromSnapshot(doc)).toList();
    });
  }

  Future<List<Client>> fetchClients() async {
    try {
      QuerySnapshot snapshot = await _db.collection('clients').get();
      List<Client> clients = snapshot.docs.map((doc) {
        return Client.fromSnapshot(doc);
      }).toList();
      return clients;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
