import 'package:catas_univalle/widgets/event_details/page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/view_models/admin_event_details_viewmodel.dart';
import '../functions/util.dart';
import '../widgets/event_details/event_about.dart';
import '../widgets/event_details/event_details.dart';
import '../widgets/event_details/event_header.dart';
import '../widgets/event_details/event_judge.dart';
import '../widgets/event_details/event_restrictions.dart';
import '../widgets/event_details/judges_section.dart';

class AdminEventDetailsView extends StatefulWidget {
  final Event event;

  const AdminEventDetailsView({Key? key, required this.event})
      : super(key: key);

  @override
  State<AdminEventDetailsView> createState() => _AdminEventDetailsViewState();
}

class _AdminEventDetailsViewState extends State<AdminEventDetailsView> {
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
    return ChangeNotifierProvider<AdminEventDetailsViewModel>(
      create: (_) => AdminEventDetailsViewModel(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EventImage(imageUrl: widget.event.imageUrl),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Text(
                  widget.event.name,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EventDetail(
                        icon: Icons.calendar_today,
                        text: formatDateToWrittenDate(widget.event.date)),
                    EventDetail(
                        icon: Icons.timer_sharp,
                        text: '${widget.event.start} - ${widget.event.end}'),
                    EventDetail(
                        icon: Icons.location_on, text: widget.event.location),
                    EventDetail(
                        icon: Icons.business, text: widget.event.client.name),
                    SizedBox(
                      height: 250,
                      child: PageView(
                          controller: _pageController,
                          children: [
                            AboutSection(about: widget.event.about),
                            RestrictionsSection(
                              title: 'ALERGIAS',
                              restrictions: widget.event.allergyRestrictions,
                            ),
                            RestrictionsSection(
                              title: 'SINTOMAS',
                              restrictions: widget.event.symptomRestrictions,
                            ),
                          ],
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          }),
                    ),
                    PageIndicator(
                      controller: _pageController,
                      itemCount: 3,
                    ),
                    SelectJudgesButton(
                      onPressed: () => AdminEventDetailsViewModel()
                          .navigateToSelectedJudges(context, widget.event),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
