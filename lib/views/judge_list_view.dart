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
  final TextEditingController _searchController = TextEditingController();
  String filterStatus = "Todos";
  String filterGender = "Todos";
  int ageFilterMin = 18;
  int ageFilterMax = 65;

  @override
  void initState() {
    super.initState();
    Provider.of<JudgeViewModel>(context, listen: false).fetchJudges();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterDialog() {
    int localMinAge = ageFilterMin;
    int localMaxAge = ageFilterMax;
    String localFilterGender = filterGender;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Filtrado de Jueces"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Estado"),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ToggleButtons(
                        isSelected: [
                          filterStatus == "Todos",
                          filterStatus == "Pendiente",
                          filterStatus == "Aprobado",
                          filterStatus == "Rechazado",
                        ],
                        onPressed: (int index) {
                          setDialogState(() {
                            filterStatus = [
                              "Todos",
                              "Pendiente",
                              "Aprobado",
                              "Rechazado"
                            ][index];
                          });
                        },
                        children: const <Widget>[
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text("Todos")),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text("Pendiente")),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text("Aprobado")),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text("Rechazado")),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Género"),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ToggleButtons(
                        isSelected: [
                          localFilterGender == "Todos",
                          localFilterGender == "M",
                          localFilterGender == "F",
                        ],
                        onPressed: (int index) {
                          setDialogState(() {
                            localFilterGender = ["Todos", "M", "F"][index];
                          });
                        },
                        children: const <Widget>[
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text("Todos")),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text("Masculino")),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text("Femenino")),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Rango de Edad"),
                    RangeSlider(
                      values: RangeValues(
                          localMinAge.toDouble(), localMaxAge.toDouble()),
                      min: 18,
                      max: 100,
                      divisions: 82,
                      labels: RangeLabels(
                          localMinAge.toString(), localMaxAge.toString()),
                      onChanged: (RangeValues values) {
                        setDialogState(() {
                          localMinAge = values.start.round();
                          localMaxAge = values.end.round();
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Resetear'),
              onPressed: () {
                setState(() {
                  filterStatus = "Todos";
                  filterGender = "Todos";
                  ageFilterMin = 18;
                  ageFilterMax = 65;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                setState(() {
                  ageFilterMin = localMinAge;
                  ageFilterMax = localMaxAge;
                  filterGender = localFilterGender;
                });
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jueces', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 15, 20, 0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Buscar jueces",
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.search,
                    size: 22,
                  ),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  // Triggering state update on text change
                });
              },
            ),
          ),
          Expanded(
            child: Consumer<JudgeViewModel>(
              builder: (context, judgeViewModel, child) {
                List<Judge> filteredJudges =
                    judgeViewModel.judges.where((judge) {
                  final int age = judge.getAge();
                  bool matchesAge = age >= ageFilterMin && age <= ageFilterMax;
                  bool matchesStatus = filterStatus == "Todos" ||
                      judge.applicationState.toLowerCase() ==
                          filterStatus.toLowerCase();
                  bool matchesGender =
                      filterGender == "Todos" || judge.gender == filterGender;
                  bool matchesQuery = judge.fullName
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()) ||
                      judge.email
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase());

                  return matchesAge &&
                      matchesStatus &&
                      matchesGender &&
                      matchesQuery;
                }).toList();

                return filteredJudges.isNotEmpty
                    ? GridView.builder(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: (1 / 1.2),
                        ),
                        itemCount: filteredJudges.length,
                        itemBuilder: (context, index) {
                          final judge = filteredJudges[index];
                          return JudgeCard(judge: judge);
                        },
                      )
                    : const Center(child: Text('No se encontraron datos.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
