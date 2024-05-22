import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/view_models/admin_event_list_viewmodel.dart';
import 'package:catas_univalle/widgets/events/admin_event_card.dart';
import 'package:catas_univalle/views/admin_event_details_view.dart';

class AdminEventListView extends StatefulWidget {
  final bool isAdmin;

  const AdminEventListView({super.key, required this.isAdmin});

  @override
  State<AdminEventListView> createState() => _AdminEventListViewState();
}

class _AdminEventListViewState extends State<AdminEventListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    Provider.of<AdminEventListViewModel>(context, listen: false)
        .listenToEvents();
  }

  void _onSearchChanged() {
    Provider.of<AdminEventListViewModel>(context, listen: false)
        .setSearchQuery(_searchController.text);
  }

  void _changeFilter(String value) {
    Provider.of<AdminEventListViewModel>(context, listen: false)
        .setFilterState(value);
  }

  void _goBack(BuildContext context) {
    _searchController.text = '';
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos', style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => _goBack(context),
        ),
        foregroundColor: Colors.white,
        actions: widget.isAdmin
            ? [
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => Provider.of<AdminEventListViewModel>(context,
                          listen: false)
                      .navigateToAddEvent(context),
                ),
              ]
            : [],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Buscar eventos",
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.search, size: 22),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: PopupMenuButton<String>(
                    onSelected: _changeFilter,
                    icon: const Icon(
                      Icons.filter_list,
                      size: 20,
                    ),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                          value: 'active', child: Text('Activos')),
                      const PopupMenuItem<String>(
                          value: 'archived', child: Text('Archivados')),
                      const PopupMenuItem<String>(
                          value: 'all', child: Text('Todos')),
                    ],
                  ),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<AdminEventListViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (viewModel.events.isEmpty) {
                  return const Center(
                    child: Text('No se encontraron eventos.'),
                  );
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
                          builder: (context) => AdminEventDetailsView(
                            event: event,
                            isAdmin: widget.isAdmin,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
