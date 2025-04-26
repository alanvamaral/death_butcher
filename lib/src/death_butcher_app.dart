import 'package:death_butcher/src/injector.dart';
import 'package:death_butcher/src/modules/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

import 'modules/freezer/domain/entities/freezer.dart';
import 'modules/freezer/domain/viewmodels/freezer_view_model.dart';
import 'modules/freezer/domain/viewmodels/meat_view_model.dart';
import 'modules/freezer/ui/freezer/add_freezer_page.dart';
import 'modules/freezer/ui/meat/add_meat_page.dart';
import 'modules/freezer/ui/freezer/freezer_details._page.dart';
import 'modules/freezer/ui/freezer/freezers_page.dart';

class DeathButcherApp extends StatelessWidget {
  const DeathButcherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          appBarTheme: AppBarTheme(centerTitle: true),
          primaryColor: Colors.red,
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.red[700]!)),
      debugShowCheckedModeBanner: false,
      title: 'Sabor da Morte',
      routes: {
        '/': (context) => FreezersPage(
              meatViewModel: injector<MeatViewModel>(),
              freezerViewModel: injector<FreezerViewModel>(),
            ),
        '/meats': (context) => FreezerDetailsPage(
              meatViewModel: injector<MeatViewModel>(),
              freezer: context.arg<Freezer>(),
            ),
        '/add_freezer': (context) => AddFreezerPage(
              viewModel: injector<FreezerViewModel>(),
              id: context.arg<int>(),
            ),
        '/add_meat': (context) => AddMeatPage(
              viewModel: injector<MeatViewModel>(),
              id: context.arg<int>(),
              freezer: context.arg<Freezer>(),
            ),
      },
    );
  }
}
