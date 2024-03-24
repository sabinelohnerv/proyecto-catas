import 'package:catas_univalle/models/client.dart';
import 'package:catas_univalle/services/client_service.dart';
import 'package:catas_univalle/views/add_client_view.dart';
import 'package:flutter/material.dart';


class ClientListViewModel extends ChangeNotifier {
  final ClientService _clientService = ClientService();
  
  List<Client> _clients = [];
  List<Client> get clients => _clients;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ClientListViewModel() {
    listenToClients();
  }

  void listenToClients() {
    _isLoading = true;
    notifyListeners();

    _clientService.clientsStream().listen((clientData) {
      _clients = clientData;
      _isLoading = false;
      notifyListeners();
    });
  }

  void navigateToAddClient(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddClientView()),
    );
  }
}
