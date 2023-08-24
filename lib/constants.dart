import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

//Font
final kFontPoppins = GoogleFonts.poppins();
final kFontPoppins20 = GoogleFonts.poppins(fontSize: 20);
final kFontPoppins30 = GoogleFonts.poppins(fontSize: 30);

//DateTime
final DateTime now = DateTime.now();
final dateTime = DateFormat('dd - MM - yyyy').format(now);
final hour = DateFormat('kk:mm').format(now);
