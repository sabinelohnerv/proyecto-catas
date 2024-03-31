import 'dart:io';
import 'package:catas_univalle/models/client.dart';
import 'package:catas_univalle/services/client_service.dart';
import 'package:flutter/material.dart';

class EditClientViewModel extends ChangeNotifier {
  final ClientService _clientService = ClientService();
  late String id;
  late String name;
  late String email;
  String? logoImgUrl;

  void loadClient(Client client) {
    id = client.id;
    name = client.name;
    email = client.email;
    logoImgUrl = client.logoImgUrl;
    notifyListeners();
  }

  Future<void> updateClient(File? logo) async {
    if (logo != null) {
      logoImgUrl = await _clientService.uploadClientLogo(logo, id);
    }
    await _clientService.updateClient(Client(
      id: id,
      name: name,
      logoImgUrl: logoImgUrl ?? '',
      email: email,
    ));
  }
}
