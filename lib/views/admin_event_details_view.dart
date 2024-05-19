import 'package:catas_univalle/widgets/event_details/event_actions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/view_models/admin_event_details_viewmodel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../functions/util.dart';
import '../widgets/event_details/event_about.dart';
import '../widgets/event_details/event_details.dart';
import '../widgets/event_details/event_form_button.dart';
import '../widgets/event_details/event_header.dart';
import '../widgets/event_details/event_judge.dart';
import '../widgets/event_details/event_restrictions.dart';

class AdminEventDetailsView extends StatefulWidget {
  final Event event;
  final bool isAdmin;

  const AdminEventDetailsView({
    super.key,
    required this.event,
    required this.isAdmin,
  });

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
            icon: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.arrow_back, color: Colors.white)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        persistentFooterButtons: widget.isAdmin
            ? [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SelectJudgesButton(
                        onPressed: () => AdminEventDetailsViewModel()
                            .navigateToSelectedJudges(context, widget.event),
                      ),
                      EventActionButtons(eventId: widget.event.id),
                    ],
                  ),
                ),
              ]
            : [
                TakeFormButton(
                  onPressed: () => AdminEventDetailsViewModel()
                      .navigateToForm(context, widget.event.formUrl),
                ),
              ],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EventImage(imageUrl: widget.event.imageUrl),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.event.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      'Evento',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: EventDetail(
                              icon: Icons.calendar_today,
                              text: formatDateToWrittenDate(widget.event.date)),
                        ),
                        Expanded(
                          child: EventDetail(
                              icon: Icons.timer_sharp,
                              text:
                                  '${widget.event.start} - ${widget.event.end}'),
                        ),
                      ],
                    ),
                    EventDetail(
                        icon: Icons.location_on, text: widget.event.location),
                    EventDetail(
                        imageUrl: widget.event.client.logoImgUrl,
                        text: widget.event.client.name),
                    const Divider(),
                    SizedBox(
                      height: 180,
                      child: PageView(
                          controller: _pageController,
                          children: [
                            SingleChildScrollView(
                              child: AboutSection(about: widget.event.about),
                            ),
                            SingleChildScrollView(
                              child: RestrictionsSection(
                                title: 'ALERGIAS',
                                restrictions: widget.event.allergyRestrictions,
                              ),
                            ),
                            SingleChildScrollView(
                              child: RestrictionsSection(
                                title: 'SINTOMAS',
                                restrictions: widget.event.symptomRestrictions,
                              ),
                            ),
                          ],
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          }),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
