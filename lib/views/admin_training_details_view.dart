import 'package:catas_univalle/models/training.dart';
import 'package:catas_univalle/view_models/judge_training_details_viewmodel.dart';
import 'package:catas_univalle/view_models/pdf_viewmodel.dart';
import 'package:catas_univalle/widgets/trainings/training_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AdminTrainingDetailsView extends StatelessWidget {
  final Training training;

  const AdminTrainingDetailsView({super.key, required this.training});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('es_ES', null);

    DateTime date = DateTime.parse(training.date);
    String dayNumber = DateFormat('d', 'es_ES').format(date);
    String abbreviatedMonth =
        DateFormat('MMM', 'es_ES').format(date).toUpperCase();

    return ChangeNotifierProvider(
      create: (_) => JudgeTrainingDetailsViewModel(training),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Consumer<JudgeTrainingDetailsViewModel>(
          builder: (context, viewModel, child) {
            return Stack(
              children: <Widget>[
                Column(
                  children: [
                    const Image(
                      height: 275,
                      image: AssetImage(
                        'assets/images/training_details_background.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                  ],
                ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TrainingDetailsCard(
                            training: training,
                            dayNumber: dayNumber,
                            abbreviatedMonth: abbreviatedMonth),
                      ),
                      const SizedBox(height: 30),
                      Divider(
                        thickness: 2,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Detalles',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Text(training.description,
                            style: const TextStyle(fontSize: 14)),
                      ),
                      const SizedBox(height: 20),
                      Divider(
                        thickness: 2,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Documentación Complementaria',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Text(
                            'Para facilitar su comprensión y seguimiento en la capacitación, se le ha proporcionado un PDF con la información más relevante.',
                            style: TextStyle(fontSize: 14)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 26),
                        child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.picture_as_pdf),
                            onPressed: () {
                              PDFViewModel pdfViewModel =
                                  PDFViewModel();
                              pdfViewModel.viewPDF(training.pdfUrl).then((_) {
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Failed to open the PDF: $error")));
                              });
                            },
                            label: const Text('VISUALIZAR PDF')),
                      )
                    ],
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
