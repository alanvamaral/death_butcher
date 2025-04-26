import 'package:death_butcher/src/modules/freezer/domain/entities/freezer.dart';
import 'package:death_butcher/src/modules/freezer/domain/state/freezer_state.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/meat.dart';
import '../../domain/state/meat_state.dart';
import '../../domain/viewmodels/freezer_view_model.dart';
import '../../domain/viewmodels/meat_view_model.dart';

class FreezersPage extends StatefulWidget {
  const FreezersPage({
    super.key,
    required this.freezerViewModel,
    required this.meatViewModel,
  });

  final FreezerViewModel freezerViewModel;
  final MeatViewModel meatViewModel;

  @override
  State<FreezersPage> createState() => _FreezersPageState();
}

class _FreezersPageState extends State<FreezersPage> {
  FreezerViewModel get freezerViewModel => widget.freezerViewModel;
  MeatViewModel get meatViewModel => widget.meatViewModel;

  @override
  void initState() {
    super.initState();
    freezerViewModel.getFreezers();
    meatViewModel.getMeats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Freezers'),
      ),
      body: ValueListenableBuilder(
          valueListenable: freezerViewModel,
          builder: (context, state, _) {
            return switch (state) {
              SuccessFreezerState(:final freezers) => _SuccessFreezerWidget(
                  meatViewModel: meatViewModel,
                  freezers: freezers,
                  freezerViewModel: freezerViewModel,
                ),
              _ => Center(
                  child: CircularProgressIndicator(),
                )
            };
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          if (freezerViewModel.value is SuccessFreezerState) {
            final view = freezerViewModel.value as SuccessFreezerState;
            int id;
            if (view.freezers.isNotEmpty) {
              id = view.freezers.last.id + 1;
            } else {
              id = 1;
            }

            Navigator.pushNamed(context, '/add_freezer', arguments: {int: id});
          }
        },
      ),
    );
  }
}

class _SuccessFreezerWidget extends StatelessWidget {
  const _SuccessFreezerWidget({
    required this.freezers,
    required this.freezerViewModel,
    required this.meatViewModel,
  });

  final List<Freezer> freezers;
  final FreezerViewModel freezerViewModel;
  final MeatViewModel meatViewModel;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: meatViewModel,
        builder: (context, state, _) {
          List<Meat> meatsFreezer = [];
          if (state is SuccessMeatState) {
            meatsFreezer = state.meats;
          }
          return ListView.builder(
            itemCount: freezers.length,
            itemBuilder: (context, index) {
              final freezer = freezers[index];
              var meatsInFreezer =
                  meatsFreezer.where((m) => m.placedIn == freezer.id).toList();

              return _FreezerInfoWidget(
                freezer: freezer,
                meats: meatsInFreezer,
                onTap: () => Navigator.of(context).pushNamed(
                  '/meats',
                  arguments: {Freezer: freezer, List<Meat>: meatsInFreezer},
                ),
                onLongPress: () async {
                  await freezerViewModel.removeFreezer(freezer);
                },
              );
            },
          );
        });
  }
}

class _FreezerInfoWidget extends StatelessWidget {
  const _FreezerInfoWidget({
    required this.freezer,
    required this.meats,
    required this.onTap,
    required this.onLongPress,
  });

  final Freezer freezer;
  final List<Meat> meats;
  final void Function() onTap;
  final void Function() onLongPress;

  Color _getIconColor(List<Meat> meatsInFreezer) {
    if (meatsInFreezer.any((m) => m.state == MeatState.expired)) {
      return Colors.red[700]!;
    } else if (meatsInFreezer.any((m) => m.state == MeatState.almostExpired)) {
      return Colors.orange[700]!;
    } else {
      return Colors.green[700]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          leading: Icon(Icons.ac_unit, color: _getIconColor(meats), size: 36),
          title: Text(
            freezer.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Local: ${freezer.location}'),
              SizedBox(height: 4),
              Text('Carnes armazenadas: ${meats.length}'),
            ],
          ),
          trailing: Text(
            'ID: ${freezer.id}',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}
