import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/meat.dart';
import '../../domain/entities/freezer.dart';
import '../../domain/state/meat_state.dart';
import '../../domain/viewmodels/meat_view_model.dart';

class FreezerDetailsPage extends StatelessWidget {
  const FreezerDetailsPage({
    super.key,
    required this.meatViewModel,
    required this.freezer,
  });

  final Freezer freezer;
  final MeatViewModel meatViewModel;

  @override
  Widget build(BuildContext context) {
    List<Meat> filteredMeats = [];
    return Scaffold(
      appBar: AppBar(
        title: Text(freezer.name),
      ),
      body: ValueListenableBuilder<MeatStates>(
          valueListenable: meatViewModel,
          builder: (context, state, _) {
            if (state is SuccessMeatState) {
              filteredMeats =
                  state.meats.where((m) => m.placedIn == freezer.id).toList();
            }

            return ListView.builder(
              itemCount: filteredMeats.length,
              itemBuilder: (context, index) {
                Meat meat = filteredMeats[index];
                return _MeatCard(
                    meat: meat,
                    onLongPress: () async {
                      await meatViewModel.removeMeat(meat);
                    });
              },
            );
          }),
      floatingActionButton: _FloatingButtonWidget(meatViewModel, freezer),
    );
  }
}

class _FloatingButtonWidget extends StatelessWidget {
  const _FloatingButtonWidget(this.viewModel, this.freezer);

  final MeatViewModel viewModel;
  final Freezer freezer;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: SvgPicture.asset(
          height: 30,
          width: 30,
          'assets/icons/meat.svg',
          colorFilter: ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
        onPressed: () {
          if (viewModel.value is SuccessMeatState) {
            final view = viewModel.value as SuccessMeatState;
            int id;
            if (view.meats.isNotEmpty) {
              id = view.meats.last.id + 1;
            } else {
              id = 1;
            }
            Navigator.pushNamed(context, '/add_meat', arguments: {
              int: id,
              Freezer: freezer,
            });
          }
        });
  }
}

class _MeatCard extends StatelessWidget {
  const _MeatCard({required this.meat, required this.onLongPress});

  final Meat meat;
  final void Function() onLongPress;

  Color _getStateColor() {
    switch (meat.state) {
      case MeatState.expired:
        return Colors.red[700]!;
      case MeatState.almostExpired:
        return Colors.orange[700]!;
      case MeatState.good:
        return Colors.green[700]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return InkWell(
      onLongPress: onLongPress,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          leading: SvgPicture.asset(
            height: 46,
            width: 46,
            'assets/icons/meat.svg',
            colorFilter: ColorFilter.mode(
              _getStateColor(),
              BlendMode.srcIn,
            ),
          ),
          title: Text(
            meat.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tipo: ${meat.getTypeString()}'),
              Text('Quantidade: ${meat.quantity} kg'),
              Text('Validade: ${dateFormat.format(meat.expirationDate)}'),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    const TextSpan(text: 'Estado: '),
                    TextSpan(
                      text: meat.getStateString(),
                      style: TextStyle(
                          color: _getStateColor(), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Freezer: ${meat.placedIn}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text('User: ${meat.placedBy}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text('ID: ${meat.id}', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }
}
