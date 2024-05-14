import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/view_models/judge_events_viewmodel.dart';
import 'package:catas_univalle/views/admin_event_details_view.dart';

import '../widgets/events/admin_event_card.dart';

class JudgeSelectedEventsView extends StatefulWidget {
  final String judgeId;
  const JudgeSelectedEventsView({super.key, required this.judgeId});

  @override
  State<JudgeSelectedEventsView> createState() =>
      _JudgeSelectedEventsViewState();
}

class _JudgeSelectedEventsViewState extends State<JudgeSelectedEventsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    Provider.of<JudgeEventsViewModel>(context, listen: false)
        .loadEventsForJudge();
  }

  void _onSearchChanged() {
    Provider.of<JudgeEventsViewModel>(context, listen: false)
        .setSearchQuery(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _goBack(BuildContext context) {
    _searchController.text = '';
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => JudgeEventsViewModel(widget.judgeId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Eventos Aceptados',
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
                    child: Icon(
                      Icons.search,
                      size: 22,
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
              child: Consumer<JudgeEventsViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (viewModel.events.isEmpty) {
                    return const Center(
                        child: Text('No has aceptado eventos aún.'));
                  }
                  return ListView.builder(
                    itemCount: viewModel.events.length,
                    itemBuilder: (context, index) {
                      Event event = viewModel.events[index];
                      return AdminEventCard(
                          event: event,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AdminEventDetailsView(
                                    event: event, isAdmin: false),
                              ),
                            );
                          });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
