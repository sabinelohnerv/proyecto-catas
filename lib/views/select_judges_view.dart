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
          title: Consumer<SelectJudgesViewModel>(
            builder: (context, viewModel, child) {
              int selectedCount = viewModel.selectedJudges.length;
              int totalCount = viewModel.event?.numberOfJudges ?? 0;
              return Column(
                children: [
                  const Text('Seleccionar Jueces', style: TextStyle(fontSize: 22),),
                  const SizedBox(height: 2,),
                  Text('$selectedCount de $totalCount jueces seleccionados', style: const TextStyle(fontSize: 14),),
                ],
              );
            },
          ),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Provider.of<SelectJudgesViewModel>(context, listen: false)
                  .resetData();
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
                  child: ElevatedButton(
                    onPressed: () {
                      viewModel.saveSelectedJudges();

                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(42.5),
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
