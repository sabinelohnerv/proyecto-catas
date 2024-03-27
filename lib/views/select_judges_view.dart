import 'package:catas_univalle/view_models/select_judges_viewmodel.dart';
import 'package:catas_univalle/widgets/select_judges/select_judge_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectJudgesView extends StatelessWidget {
  final String eventId;

  const SelectJudgesView({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectJudgesViewModel>(
      create: (_) {
        var viewModel = SelectJudgesViewModel(eventId);
        viewModel.initialize(); 
        return viewModel; 
      },
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
              context.read<SelectJudgesViewModel>().resetData();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Consumer<SelectJudgesViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.judges.length,
                    itemBuilder: (context, index) {
                      final judge = viewModel.judges[index];
                      final isSelected =
                          viewModel.selectedJudges.any((j) => j.id == judge.id);

                      return SelectJudgeCard(
                        judge: judge,
                        isSelected: isSelected,
                        viewModel: viewModel,
                        context: context,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      viewModel.saveSelectedJudges();

                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('Guardar'),
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
