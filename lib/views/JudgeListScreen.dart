import 'package:flutter/material.dart';
import 'package:catas_univalle/services/judge_service.dart';
import 'package:catas_univalle/models/judge.dart';
import 'package:catas_univalle/widgets/Judge/judge_card.dart'; 

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
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return GridView.builder(
              padding: const EdgeInsets.all(4), 
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4, 
                mainAxisSpacing: 4, 
                childAspectRatio: (1 / 1.2), 
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Judge judge = snapshot.data![index];
                return JudgeCard(judge: judge);
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
