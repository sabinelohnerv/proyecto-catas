import 'package:catas_univalle/models/judge.dart';
import 'package:catas_univalle/widgets/select_judges/select_judge_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/view_models/select_judges_viewmodel.dart';

class SelectJudgesView extends StatelessWidget {
  final Event event;

  const SelectJudgesView({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectJudgesViewModel>(
      create: (_) => SelectJudgesViewModel(event),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Seleccionar Jueces',
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
        body: Consumer<SelectJudgesViewModel>(
          builder: (context, viewModel, child) {
            return ListView.builder(
              itemCount: viewModel.judges.length,
              itemBuilder: (context, index) {
                final judge = viewModel.judges[index];
                final isSelected =
                    viewModel.selectedJudges.any((j) => j.id == judge.id);

                return SelectJudgeCard(judge: judge, isSelected: isSelected, viewModel: viewModel,);
              },
            );
          },
        ),
      ),
    );
  }
}

