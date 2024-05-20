import 'package:catas_univalle/view_models/pdf_viewmodel.dart';
import 'package:catas_univalle/views/judge_training_details_view.dart';
import 'package:flutter/material.dart';

class PdfSection extends StatelessWidget {
  const PdfSection({
    super.key,
    required this.widget,
  });

  final JudgeTrainingDetailsView widget;

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
                'Para facilitar su comprensión y seguimiento en la capacitación, se le ha proporcionado un PDF con la información más relevante.',
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
                              backgroundColor: Colors.red,
                            ));
                          });
                        }
                      : null,
                  label: const Text('VISUALIZAR PDF')),
            ),
          ),
        ],
      ),
    );
  }
}
