import 'package:iconify_flutter/icons/bi.dart';

String iconFromName(String name) {
  const Map<String, String> nameToIcon = {
    'Bi.dribbble': Bi.dribbble,
    'Bi.calendar_heart': Bi.calendar_heart,
    'Bi.geo_alt': Bi.geo_alt,
    'Bi.person': Bi.person,
    'Bi.bicycle': Bi.bicycle,
    'Bi.yin_yang': Bi.yin_yang,
    'Bi.cup_hot': Bi.cup_hot,
    'Bi.train_lightrail_front': Bi.train_lightrail_front,
    'Bi.dpad': Bi.dpad,
    'Bi.book': Bi.book,
    'Bi.heart': Bi.heart,
    'Bi.house_heart': Bi.house_heart,
    'Bi.stars': Bi.stars,
    'Bi.hammer': Bi.hammer,
    'Bi.heart_pulse': Bi.heart_pulse,
  };

  return nameToIcon[name] ?? Bi.question_circle;
}
