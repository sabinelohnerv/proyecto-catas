import 'package:catas_univalle/services/judge_service.dart';
import 'package:flutter/material.dart';
import '../models/judge.dart';

class JudgeListScreen extends StatefulWidget {
  const JudgeListScreen({Key? key}) : super(key: key);

  @override
  _JudgeListScreenState createState() => _JudgeListScreenState();
}

class _JudgeListScreenState extends State<JudgeListScreen> {
  final JudgeService _judgeService = JudgeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Jueces'),
      ),
      body: FutureBuilder<List<Judge>>(
        future: _judgeService.getJudges(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            // Construir la lista de jueces
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final Judge judge = snapshot.data![index];
                return ListTile(
                  // Campos que se muestran
                  title: Text(judge.fullName),
                  subtitle: Text(judge.email),
                );
              },
            );
          }
        },
      ),
    );
  }
}
