import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../models/event.dart';
import '../../widgets/events/event_card.dart';
import '../../views/admin_event_details_view.dart';

class HomeEventsCarousel extends StatelessWidget {
  final List<Event> events;
  final bool isAdmin;
  final String? userName;
  final String defaultImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/catas-univalle.appspot.com/o/defaults%2FCartoon_With_Type_World_Food_Day_Instagram_Post-jGie-IqzQ-transformed.png?alt=media&token=46947a51-71cf-4c6f-afad-90332b83178f';

  const HomeEventsCarousel({
    super.key,
    required this.events,
    this.isAdmin = false,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> carouselItems = [];
    String displayUserName =
        (userName?.isNotEmpty ?? false) ? userName! : "Usuario";

    if (events.isEmpty) {
      carouselItems.add(EventCard(
        imageUrl: defaultImageUrl,
        title: "¡Hola $displayUserName!",
      ));
    } else {
      carouselItems.add(EventCard(
        imageUrl: defaultImageUrl,
        title: "¡Hola $displayUserName!",
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
