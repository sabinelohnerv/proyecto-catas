import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/judge.dart';
import '../view_models/judge_viewmodel.dart';
import '../views/judge_detail_screen.dart';
import '../widgets/Judge/judge_card.dart';
import 'package:catas_univalle/services/judge_service.dart';

class JudgeListScreen extends StatefulWidget {
  const JudgeListScreen({Key? key}) : super(key: key);

  @override
  State<JudgeListScreen> createState() => _JudgeListScreenState();
}

class _JudgeListScreenState extends State<JudgeListScreen> {
  final JudgeService _judgeService = JudgeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jueces'),
      ),
      body: FutureBuilder<List<Judge>>(
        future: _judgeService.getJudges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error.toString()}");
          } else if (snapshot.hasData) {
            return GridView.builder(
              padding: const EdgeInsets.all(4),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: (1 / 1.2),
              ),
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                Judge judge = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (_) => JudgeViewModel(),
                          child: JudgeDetailScreen(judge: judge),
                        ),
                      ),
                    );
                  },
                  child: JudgeCard(judge: judge),
                );
              },
            );
          } else {
            return const Center(child: Text('No se encontraron datos.'));
          }
        },
      ),
    );
  }
}
