import 'package:catas_univalle/view_models/pdf_viewmodel.dart';
import 'package:catas_univalle/views/admin_training_details_view.dart';
import 'package:flutter/material.dart';

class PdfSection extends StatelessWidget {
  const PdfSection({
    super.key,
    required this.widget,
  });

  final AdminTrainingDetailsView widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "DOCUMENTACIÓN",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
                'Para facilitar la comprensión y seguimiento de los jueces en la capacitación, se les ha proporcionado un PDF con la información más relevante.',
                style: TextStyle(fontSize: 16)),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.picture_as_pdf),
                  onPressed: widget.training.pdfUrl != null
                      ? () {
                          PDFViewModel pdfViewModel = PDFViewModel();
                          pdfViewModel
                              .viewPDF(widget.training.pdfUrl!)
                              .then((_) {})
                              .catchError((error) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Error al abrir el pdf."),
                              backgroundColor: Color.fromARGB(255, 197, 91, 88),
                            ));
                          });
                        }
                      : null,
                  label: const Text(
                    'Visualizar PDF',
                    style: TextStyle(fontSize: 16),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
