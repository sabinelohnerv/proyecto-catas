import 'package:catas_univalle/models/client.dart';
import 'package:catas_univalle/services/client_service.dart';
import 'package:flutter/material.dart';


class ClientListViewModel extends ChangeNotifier {
  final ClientService _clientService = ClientService();
  List<Client> _clients = [];
  bool _isBusy = false;

  List<Client> get clients => _clients;
  bool get isBusy => _isBusy;

  ClientListViewModel() {
    listenToClients();
  }

  void listenToClients() {
    _isBusy = true;
    notifyListeners();

    _clientService.clientsStream().listen((clientData) {
      _clients = clientData;
      _isBusy = false;
      notifyListeners();
    });
  }
}
