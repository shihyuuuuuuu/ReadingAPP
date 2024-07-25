import 'package:flutter/material.dart';

Color seedColor = const Color.fromARGB(255, 249, 146, 30);
ThemeData lightTheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor)  
          .copyWith(primary: seedColor,),
        useMaterial3: true,

        // textTheme: TextTheme(
        //   titleLarge: const TextStyle(
        //     fontSize: 30,
        //   ),
          
        //   bodyMedium: GoogleFonts.merriweather(
        //     fontSize: 20,
        //     fontStyle: FontStyle.normal
        //   ),
        //   labelSmall: GoogleFonts.merriweather(
        //     fontSize: 12,
        //     // fontWeight: FontWeight.bold
        //   ),
          
        // ),
      );