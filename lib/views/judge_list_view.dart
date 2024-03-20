import 'package:catas_univalle/widgets/judge/judge_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/judge.dart';
import 'package:catas_univalle/view_models/judge_viewmodel.dart';

class JudgeListView extends StatefulWidget {
  const JudgeListView({Key? key}) : super(key: key);

  @override
  _JudgeListViewState createState() => _JudgeListViewState();
}

class _JudgeListViewState extends State<JudgeListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      Provider.of<JudgeViewModel>(context, listen: false).fetchJudges()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jueces'),
      ),
      body: Consumer<JudgeViewModel>(
        builder: (context, judgeViewModel, child) {
          final judges = judgeViewModel.judges;
          return judges.isNotEmpty
              ? GridView.builder(
                  padding: const EdgeInsets.all(4),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: (1 / 1.2),
                  ),
                  itemCount: judges.length,
                  itemBuilder: (context, index) {
                    final judge = judges[index];
                    return JudgeCard(judge: judge);
                  },
                )
              : const Center(child: Text('No se encontraron datos.'));
        },
      ),
    );
  }
}
