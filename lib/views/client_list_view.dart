import 'package:catas_univalle/view_models/client_list_viewmodel.dart';
import 'package:catas_univalle/widgets/clients/client_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientListView extends StatelessWidget {
  const ClientListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Anfitriones',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => ClientListViewModel().navigateToAddClient(context),
          ),
        ],
      ),
      body: ChangeNotifierProvider<ClientListViewModel>(
        create: (context) => ClientListViewModel(),
        child: Consumer<ClientListViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.clients.isEmpty) {
              return const Center(child: Text('No has registrado anfitriones aún.'));
            }
            return ListView.builder(
              itemCount: viewModel.clients.length,
              itemBuilder: (context, index) {
                final client = viewModel.clients[index];
                return ClientCard(
                  client: client,
                  onDelete: () {
                    viewModel.deleteClient(client.id);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
