import 'package:catas_univalle/models/client.dart';
import 'package:catas_univalle/view_models/client_list_viewmodel.dart';
import 'package:catas_univalle/widgets/clients/client_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_client_view.dart';

class ClientListView extends StatelessWidget {
  const ClientListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Clientes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ChangeNotifierProvider<ClientListViewModel>(
        create: (context) => ClientListViewModel(),
        child: Consumer<ClientListViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isBusy) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: viewModel.clients.length,
              itemBuilder: (context, index) {
                Client client = viewModel.clients[index];
                return ClientCard(client: client);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ClientListViewModel().navigateToAddClient(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}