import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:catas_univalle/view_models/selected_judges_viewmodel.dart';
import 'package:catas_univalle/widgets/select_judges/selected_judge_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event_judge.dart';

class SelectedJudgesView extends StatelessWidget {
  final Event event;

  const SelectedJudgesView({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SelectedJudgesViewModel(event),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Jueces Seleccionados',
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
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () => SelectedJudgesViewModel(event).navigateToSelectJudges(context),
            ),
          ],
        ),
        body: Consumer<SelectedJudgesViewModel>(
          builder: (context, viewModel, child) {
            return StreamBuilder<List<EventJudge>>(
              stream: viewModel.selectedJudgesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("Aún no se han seleccionado jueces."));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    EventJudge judge = snapshot.data![index];
                    return SelectedJudgeCard(
                      judge: judge,
                    );
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
