import 'dart:io';
import 'package:catas_univalle/models/client.dart';
import 'package:catas_univalle/services/client_service.dart';
import 'package:flutter/foundation.dart';

class AddClientViewModel extends ChangeNotifier {
  final ClientService _clientService = ClientService();
  bool _isUploading = false;
  String name = '';
  String email = '';

  bool get isUploading => _isUploading;

  Future<void> addClient(String name, String email, File logo) async {
    _isUploading = true;
    notifyListeners();
    String clientId = DateTime.now().millisecondsSinceEpoch.toString();
    String logoUrl = await _clientService.uploadClientLogo(logo, clientId);
    Client client = Client(id: clientId, name: name, logoImgUrl: logoUrl, email: email);
    await _clientService.addClient(client);
    _isUploading = false;
    notifyListeners();
  }
}
