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
          title: Text("Filtrar por Estado"),
          content: DropdownButton<String>(
            value: filterStatus,
            onChanged: (value) {
              setState(() {
                filterStatus = value!;
                Navigator.pop(context);
              });
            },
            items: <String>["Todos", "Certificado", "No Certificado"]
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
        title: Text('Jueces',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Consumer<JudgeViewModel>(
        builder: (context, judgeViewModel, child) {
          List<Judge> filteredJudges = judgeViewModel.judges.where((judge) {
            if (filterStatus == "Certificado") {
              return judge.applicationState == "approved";
            } else if (filterStatus == "No Certificado") {
              return judge.applicationState != "approved";
            }
            return true;
          }).toList();

          final judges = searchQuery.isEmpty
              ? filteredJudges
              : filteredJudges.where((judge) {
                  return judge.fullName.toLowerCase().contains(searchQuery) ||
                      judge.email.toLowerCase().contains(searchQuery);
                }).toList();

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
              : Center(child: Text('No se encontraron datos.'));
        },
      ),
    );
  }
}
