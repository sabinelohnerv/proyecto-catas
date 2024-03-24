import 'package:catas_univalle/widgets/view_events/admin_event_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/view_models/admin_event_list_viewmodel.dart';
import 'package:catas_univalle/views/admin_event_details_view.dart';

class AdminEventListView extends StatelessWidget {
  const AdminEventListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos de Cata'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        foregroundColor: Colors.white,
      ),
      body: ChangeNotifierProvider<AdminEventListViewModel>(
        create: (context) => AdminEventListViewModel(),
        child: Consumer<AdminEventListViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: viewModel.events.length,
              itemBuilder: (context, index) {
                Event event = viewModel.events[index];
                return AdminEventCard(
                  event: event,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminEventDetailsView(event: event),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AdminEventListViewModel().navigateToAddEvent(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
