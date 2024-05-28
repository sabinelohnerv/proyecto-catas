import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/view_models/judge_training_events_viewmodel.dart';
import 'package:catas_univalle/widgets/trainings/training_event_card.dart';

class JudgeTrainingEventsView extends StatefulWidget {
  final String judgeId;
  const JudgeTrainingEventsView({super.key, required this.judgeId});

  @override
  State<JudgeTrainingEventsView> createState() =>
      _JudgeTrainingEventsViewState();
}

class _JudgeTrainingEventsViewState extends State<JudgeTrainingEventsView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterState = 'active';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JudgeTrainingEventsViewModel>(context, listen: false)
          .loadTrainingEventsForJudge();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _goBack(BuildContext context) {
    _searchController.text = '';
    Navigator.of(context).pop();
  }

  void _changeFilter(String choice) {
    setState(() {
      _filterState = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<JudgeTrainingEventsViewModel>(
      create: (context) => JudgeTrainingEventsViewModel(widget.judgeId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Capacitaciones Por Evento',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => _goBack(context),
          ),
        ),
        body: Consumer<JudgeTrainingEventsViewModel>(
          builder: (context, viewModel, child) {
            List<Event> filteredEvents = viewModel.events.where((event) {
              final matchesSearch = event.name
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()) ||
                  event.about
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase());
              final matchesFilter = _filterState == 'all' ||
                  event.state.trim().toLowerCase() ==
                      _filterState.toLowerCase();
              return matchesSearch && matchesFilter;
            }).toList();

            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
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
                  child: viewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredEvents.isEmpty
                          ? const Center(
                              child: Text('No se encontraron eventos.'))
                          : ListView.builder(
                              itemCount: filteredEvents.length,
                              itemBuilder: (context, index) {
                                Event event = filteredEvents[index];
                                int numberOfTrainings =
                                    viewModel.trainingCounts[event.id] ?? 0;
                                return TrainingEventCard(
                                  event: event,
                                  numberOfTrainings: numberOfTrainings,
                                  onTap: () => viewModel.goToTrainingsListView(
                                      context, event),
                                );
                              },
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
