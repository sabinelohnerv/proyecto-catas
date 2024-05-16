import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../models/event.dart';
import '../../widgets/events/event_card.dart';
import '../../views/admin_event_details_view.dart';

class HomeEventsCarousel extends StatelessWidget {
  final List<Event> events;
  final bool isAdmin;
  final String defaultImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/catas-univalle.appspot.com/o/event_images%2Fdefault.png?alt=media&token=3e4647f4-7d61-47f5-8aa8-1a4911b2fe24';

  const HomeEventsCarousel({
    super.key,
    required this.events,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> carouselItems = [];

    if (events.isEmpty) {
      carouselItems.add(EventCard(
        imageUrl: defaultImageUrl,
        title: "No hay eventos disponibles",
      ));
    } else {
      carouselItems.add(EventCard(
        imageUrl: defaultImageUrl,
        title: "¡Hola Usuario!",
      ));
      carouselItems.addAll(events.map((event) {
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
            imageUrl:
                event.imageUrl.isNotEmpty ? event.imageUrl : defaultImageUrl,
            title: event.name,
          ),
        );
      }).toList());
    }

    return CarouselSlider(
      items: carouselItems,
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.95,
        aspectRatio: 1.2,
        initialPage: 0,
        autoPlayInterval: const Duration(seconds: 12),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
      ),
    );
  }
}
