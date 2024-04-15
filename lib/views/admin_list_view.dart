import 'package:catas_univalle/view_models/admin_list_viewmodel.dart';
import 'package:catas_univalle/widgets/admins/admin_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminListView extends StatelessWidget {
  const AdminListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Administradores',
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () =>
                AdminListViewModel().navigateToRegisterAdmin(context),
          ),
        ],
      ),
      body: ChangeNotifierProvider<AdminListViewModel>(
        create: (context) => AdminListViewModel(),
        child: Consumer<AdminListViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return viewModel.admins.isNotEmpty
                ? ListView.builder(
                    itemCount: viewModel.admins.length,
                    itemBuilder: (context, index) {
                      final admin = viewModel.admins[index];
                      return AdminCard(
                        admin: admin,
                        isCurrentAdmin: viewModel.isAdminCurrentUser(admin),
                      );
                    },
                  )
                : const Center(child: Text('No se encontraron datos.'));
          },
        ),
      ),
    );
  }
}
