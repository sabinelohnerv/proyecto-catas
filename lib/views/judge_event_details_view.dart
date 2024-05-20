import 'package:catas_univalle/services/event_service.dart';
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

class JudgeEventDetailsView extends StatefulWidget {
  final Event event;
  final String judgeId;

  const JudgeEventDetailsView({
    super.key,
    required this.event,
    required this.judgeId,
  });

  @override
  State<JudgeEventDetailsView> createState() => _JudgeEventDetailsViewState();
}

class _JudgeEventDetailsViewState extends State<JudgeEventDetailsView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Stream<Event> _eventStream;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_updatePageIndex);
    final viewModel =
        Provider.of<AdminEventDetailsViewModel>(context, listen: false);
    _eventStream = viewModel.getEventStream(widget.event.id);
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
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    void acceptInvitation() async {
      try {
        final eventService = Provider.of<EventService>(context, listen: false);
        await eventService.updateJudgeStatus(
            widget.event.id, widget.judgeId, 'accepted');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invitación aceptada'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al aceptar la invitación: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    void rejectInvitation() async {
      try {
        final eventService = Provider.of<EventService>(context, listen: false);
        await eventService.updateJudgeStatus(
            widget.event.id, widget.judgeId, 'rejected');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invitación rechazada'),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al rechazar la invitación: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: CircleAvatar(
            backgroundColor: theme.colorScheme.primary,
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StreamBuilder<Event>(
        stream: _eventStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error loading event data'));
          }

          final event = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EventImage(imageUrl: event.imageUrl),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            event.name,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.onInverseSurface,
                            child: Icon(
                              Icons.mail,
                              size: 30,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        ],
                      ),
                      const Text(
                        'Has sido invitado a este evento',
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
                              text: formatDateToWrittenDate(event.date),
                            ),
                          ),
                          Expanded(
                            child: EventDetail(
                              icon: Icons.timer_sharp,
                              text: '${event.start} - ${event.end}',
                            ),
                          ),
                        ],
                      ),
                      EventDetail(
                          icon: Icons.location_on, text: event.location),
                      EventDetail(
                          imageUrl: event.client.logoImgUrl,
                          text: event.client.name),
                      const Divider(),
                      SizedBox(
                        height: 180,
                        child: PageView(
                          controller: _pageController,
                          children: [
                            SingleChildScrollView(
                              child: AboutSection(about: event.about),
                            ),
                            SingleChildScrollView(
                              child: RestrictionsSection(
                                title: 'ALERGIAS',
                                restrictions: event.allergyRestrictions,
                              ),
                            ),
                            SingleChildScrollView(
                              child: RestrictionsSection(
                                title: 'SINTOMAS',
                                restrictions: event.symptomRestrictions,
                              ),
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
                            activeDotColor: theme.colorScheme.primary,
                            dotColor: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
            vertical: size.height * 0.02, horizontal: size.width * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: acceptInvitation,
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text(
                'ACEPTAR',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.015),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: rejectInvitation,
              icon: const Icon(Icons.close, color: Colors.white),
              label: const Text(
                'RECHAZAR',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.015),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
