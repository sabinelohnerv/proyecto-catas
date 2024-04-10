import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/judge.dart';
import 'package:catas_univalle/view_models/judge_viewmodel.dart';
import 'package:catas_univalle/widgets/judge/judge_card.dart';

class JudgeListView extends StatefulWidget {
  const JudgeListView({super.key});

  @override
  State<JudgeListView> createState() => _JudgeListViewState();
}

class _JudgeListViewState extends State<JudgeListView> {
  String searchQuery = "";
  String filterStatus = "Todos";

  @override
  void initState() {
    super.initState();
    Provider.of<JudgeViewModel>(context, listen: false).fetchJudges();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filtrar por Estado"),
          content: DropdownButton<String>(
            value: filterStatus,
            onChanged: (value) {
              setState(() {
                filterStatus = value!;
                Navigator.pop(context);
              });
            },
            items: <String>["Todos", "Pendiente", "Aprobado", "Rechazado"]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jueces', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
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
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Consumer<JudgeViewModel>(
        builder: (context, judgeViewModel, child) {
          List<Judge> filteredJudges = judgeViewModel.judges.where((judge) {
            switch (filterStatus) {
              case "Pendiente":
                return judge.applicationState == "" ||
                    judge.applicationState == "pendiente";
              case "Aprobado":
                return judge.applicationState == "aprobado";
              case "Rechazado":
                return judge.applicationState == "rechazado";
              case "Todos":
              default:
                return true;
            }
          }).toList();

          final judges = searchQuery.isEmpty
              ? filteredJudges
              : filteredJudges.where((judge) {
                  return judge.fullName.toLowerCase().contains(searchQuery) ||
                      judge.email.toLowerCase().contains(searchQuery);
                }).toList();

          return judges.isNotEmpty
              ? GridView.builder(
                  padding: const EdgeInsets.all(15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
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
