class AppConstants {
  AppConstants._();

  static const String appName = 'LankaPulse';
  static const String appTagline = 'Sri Lanka\'s Ultimate Multi-Utility Super-App';

  // --- EMERGENCY HOTLINES ---
  static const List<EmergencyHotline> emergencyHotlines = [
    EmergencyHotline(
      name: 'Police Emergency',
      number: '119',
      category: 'Security',
      description: 'National Police Emergency Command Center',
      iconName: 'local_police',
    ),
    EmergencyHotline(
      name: 'Suwa Seriya Ambulance',
      number: '1990',
      category: 'Medical',
      description: 'Free 24/7 Emergency Ambulance Service across Sri Lanka',
      iconName: 'medical_services',
    ),
    EmergencyHotline(
      name: 'Fire & Rescue Service',
      number: '110',
      category: 'Fire',
      description: 'Municipal Fire Brigade and Disaster Rescue',
      iconName: 'local_fire_department',
    ),
    EmergencyHotline(
      name: 'Tourist Police Hotline',
      number: '1989',
      category: 'Tourism',
      description: 'Dedicated assistance for international visitors and tourists',
      iconName: 'support_agent',
    ),
    EmergencyHotline(
      name: 'Child Protection Authority',
      number: '1929',
      category: 'Social',
      description: 'National Child Protection Authority Help Line',
      iconName: 'child_care',
    ),
    EmergencyHotline(
      name: 'Disaster Management Centre',
      number: '117',
      category: 'Disaster',
      description: 'Weather alerts, floods, and natural disaster emergency reporting',
      iconName: 'warning_amber',
    ),
  ];

  // --- SRI LANKAN HOLIDAYS (POYA & BANK HOLIDAYS 2026) ---
  static const List<SriLankanHoliday> upcomingHolidays = [
    SriLankanHoliday(
      name: 'Duruthu Full Moon Poya Day',
      date: 'January 03, 2026',
      type: 'Public, Bank & Mercantile',
      description: 'Commemorates the first visit of Lord Buddha to Sri Lanka.',
    ),
    SriLankanHoliday(
      name: 'Tamil Thai Pongal Day',
      date: 'January 15, 2026',
      type: 'Public, Bank & Mercantile',
      description: 'Harvest festival celebrated by Sri Lankan Tamils.',
    ),
    SriLankanHoliday(
      name: 'National Independence Day',
      date: 'February 04, 2026',
      type: 'Public, Bank & Mercantile',
      description: 'Celebrating 78 years of Sri Lankan Independence.',
    ),
    SriLankanHoliday(
      name: 'Navam Full Moon Poya Day',
      date: 'February 01, 2026',
      type: 'Public, Bank & Mercantile',
      description: 'Marks the appointment of Chief Disciples of Lord Buddha.',
    ),
    SriLankanHoliday(
      name: 'Maha Shivaratri Day',
      date: 'February 15, 2026',
      type: 'Public & Bank',
      description: 'Major Hindu festival solemnized in honor of Lord Shiva.',
    ),
    SriLankanHoliday(
      name: 'Medin Full Moon Poya Day',
      date: 'March 03, 2026',
      type: 'Public, Bank & Mercantile',
      description: 'Commemorates Lord Buddha\'s first visit to his parental home.',
    ),
    SriLankanHoliday(
      name: 'Sinhala & Tamil New Year Eve',
      date: 'April 13, 2026',
      type: 'Public, Bank & Mercantile',
      description: 'Traditional Sri Lankan Avurudu celebrations begin.',
    ),
    SriLankanHoliday(
      name: 'Sinhala & Tamil New Year Day',
      date: 'April 14, 2026',
      type: 'Public, Bank & Mercantile',
      description: 'Main Avurudu holiday with auspicious nona gathe timing.',
    ),
    SriLankanHoliday(
      name: 'Vesak Full Moon Poya Day',
      date: 'May 01, 2026',
      type: 'Public, Bank & Mercantile',
      description: 'Celebrates the Birth, Enlightenment, and Passing of Lord Buddha.',
    ),
    SriLankanHoliday(
      name: 'Poson Full Moon Poya Day',
      date: 'May 31, 2026',
      type: 'Public, Bank & Mercantile',
      description: 'Marks the arrival of Buddhism in Sri Lanka at Mihintale.',
    ),
  ];
}

class EmergencyHotline {
  final String name;
  final String number;
  final String category;
  final String description;
  final String iconName;

  const EmergencyHotline({
    required this.name,
    required this.number,
    required this.category,
    required this.description,
    required this.iconName,
  });
}

class SriLankanHoliday {
  final String name;
  final String date;
  final String type;
  final String description;

  const SriLankanHoliday({
    required this.name,
    required this.date,
    required this.type,
    required this.description,
  });
}
