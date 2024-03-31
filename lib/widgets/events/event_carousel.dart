import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../models/event.dart';
import '../../widgets/events/event_card.dart';
import '../../views/admin_event_details_view.dart';

class HomeEventsCarousel extends StatelessWidget {
  final List<Event> events;
  final bool isAdmin;

  const HomeEventsCarousel({
    super.key,
    required this.events,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: events.length,
      itemBuilder: (context, index, realIndex) {
        final event = events[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminEventDetailsView(
                  event: event,
                  isAdmin: isAdmin,
                ),
              ),
            );
          },
          child: EventCard(
            imageUrl: event.imageUrl,
            title: event.name,
          ),
        );
      },
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.95,
        aspectRatio: 1.2,
        initialPage: 0,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
      ),
    );
  }
}
