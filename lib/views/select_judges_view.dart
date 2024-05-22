import 'package:catas_univalle/view_models/select_judges_viewmodel.dart';
import 'package:catas_univalle/widgets/select_judges/select_judge_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
                  const Text(
                    'Seleccionar Jueces',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    '$selectedCount de $totalCount jueces seleccionados',
                    style: const TextStyle(fontSize: 14),
                  ),
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
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _showNumJudgesDialog(context, viewModel),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.onInverseSurface,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            minimumSize: const Size.fromHeight(42.5),
                          ),
                          icon: const Icon(Icons.shuffle),
                          label: const Text('Randomizar'),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => viewModel.deselectAllJudges(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.onInverseSurface,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            minimumSize: const Size.fromHeight(42.5),
                          ),
                          icon: const Icon(Icons.clear_all),
                          label: const Text('Limpiar'),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      viewModel.saveSelectedJudges();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(42.5),
                    ),
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showNumJudgesDialog(
      BuildContext context, SelectJudgesViewModel viewModel) {
    final _numJudgesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Randomizar Jueces',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  viewModel.randomSelectJudges(viewModel.event!.numberOfJudges);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Todos los restantes'),
              ),
            ),
            const Center(child: Text('O')),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _numJudgesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    final value = int.tryParse(_numJudgesController.text);
                    if (value != null && value > 0) {
                      viewModel.randomSelectJudges(value);
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Aplicar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
