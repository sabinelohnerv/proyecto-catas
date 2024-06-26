import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/widgets/trainings/training_event_card.dart';
import 'package:catas_univalle/view_models/admin_training_events_viewmodel.dart';

class AdminTrainingEventsView extends StatefulWidget {
  const AdminTrainingEventsView({super.key});

  @override
  State<AdminTrainingEventsView> createState() =>
      _AdminTrainingEventsViewState();
}

class _AdminTrainingEventsViewState extends State<AdminTrainingEventsView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _filterState = 'active';
  AdminTrainingEventsViewModel? viewModel;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel =
        Provider.of<AdminTrainingEventsViewModel>(context, listen: false);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      viewModel?.setSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    viewModel?.setSearchQuery('');
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _goBack(BuildContext context) {
    _searchController.text = '';
    Navigator.of(context).pop();
  }

  void _changeFilter(String choice) {
    setState(() {
      _filterState = choice;
      viewModel?.setFilterState(choice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todas las Capacitaciones',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => _goBack(context),
        ),
      ),
      body: Consumer<AdminTrainingEventsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.filteredEvents.isEmpty) {
            return const Center(
                child: Text('No hay capacitaciones disponibles.'));
          }
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
                        icon: const Icon(Icons.filter_list, size: 20),
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                              value: 'active', child: Text('Activos')),
                          const PopupMenuItem<String>(
                              value: 'archived', child: Text('Pasados')),
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
                child: ListView.builder(
                  itemCount: viewModel.filteredEvents.length,
                  itemBuilder: (context, index) {
                    Event event = viewModel.filteredEvents[index];
                    int numberOfTrainings =
                        viewModel.trainingCounts[event.id] ?? 0;
                    return TrainingEventCard(
                      event: event,
                      numberOfTrainings: numberOfTrainings,
                      onTap: () =>
                          viewModel.goToTrainingsListView(context, event),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
