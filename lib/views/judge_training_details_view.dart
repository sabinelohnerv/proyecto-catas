import 'package:catas_univalle/models/training.dart';
import 'package:catas_univalle/view_models/judge_training_details_viewmodel.dart';
import 'package:catas_univalle/widgets/event_details/event_about.dart';
import 'package:catas_univalle/widgets/event_details/event_details.dart';
import 'package:catas_univalle/widgets/training_assistances/attendance_stamp.dart';
import 'package:catas_univalle/widgets/trainings/pdf_section_judge.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class JudgeTrainingDetailsView extends StatefulWidget {
  final Training training;

  const JudgeTrainingDetailsView({super.key, required this.training});

  @override
  State<JudgeTrainingDetailsView> createState() =>
      _JudgeTrainingDetailsViewState();
}

class _JudgeTrainingDetailsViewState extends State<JudgeTrainingDetailsView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_updatePageIndex);
  }

  @override
  void dispose() {
    _pageController.removeListener(_updatePageIndex);
    _pageController.dispose();
    super.dispose();
  }

  void _updatePageIndex() {
    if (_pageController.page!.round() != _currentPage) {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('es_ES', null);

    DateTime date = DateTime.parse(widget.training.date);
    String dayNumber = DateFormat('d', 'es_ES').format(date);
    String abbreviatedMonth =
        DateFormat('MMM', 'es_ES').format(date).toUpperCase();

    return ChangeNotifierProvider(
      create: (_) => JudgeTrainingDetailsViewModel(widget.training),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.arrow_back_ios, color: Colors.white)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Consumer<JudgeTrainingDetailsViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(30)),
                    child: Container(
                      height: 320,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage('assets/images/food-background-2.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.training.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Text(
                          'Capacitación',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              padding: const EdgeInsets.all(8),
                              width: 60,
                              height: 70,
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: dayNumber,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n$abbreviatedMonth',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  EventDetail(
                                      icon: Icons.timer_sharp,
                                      text:
                                          '${widget.training.startTime} - ${widget.training.endTime}'),
                                  EventDetail(
                                      icon: Icons.location_on,
                                      text: widget.training.location),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        SizedBox(
                          height: 250,
                          child: PageView(
                              controller: _pageController,
                              children: [
                                SingleChildScrollView(
                                  child: AboutSection(
                                      about: widget.training.description),
                                ),
                                SingleChildScrollView(
                                    child: Expanded(
                                        child: PdfSection(widget: widget))),
                                SingleChildScrollView(
                                  child: AttendanceStamp(
                                      attendanceStatus:
                                          viewModel.attendanceStatus),
                                )
                              ],
                              onPageChanged: (int page) {
                                setState(() {
                                  _currentPage = page;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      effect: ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: Theme.of(context).colorScheme.primary,
                        dotColor: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
