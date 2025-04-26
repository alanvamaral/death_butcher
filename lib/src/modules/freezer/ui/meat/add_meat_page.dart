import 'package:death_butcher/src/modules/freezer/domain/viewmodels/meat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/freezer.dart';
import '../../domain/entities/meat.dart';

class AddMeatPage extends StatefulWidget {
  final MeatViewModel viewModel;
  final int id;
  final Freezer freezer;

  const AddMeatPage({
    super.key,
    required this.viewModel,
    required this.id,
    required this.freezer,
  });

  @override
  State<AddMeatPage> createState() => _AddMeatPageState();
}

class _AddMeatPageState extends State<AddMeatPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _placedByController = TextEditingController();
  final _notesController = TextEditingController();

  MeatType? _selectedType;
  DateTime? _entryDate;
  DateTime? _expirationDate;

  Future<void> _selectDate(BuildContext context, bool isEntry) async {
    final initialDate = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isEntry) {
          _entryDate = picked;
        } else {
          _expirationDate = picked;
        }
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate() &&
        _selectedType != null &&
        _entryDate != null &&
        _expirationDate != null) {
      final meat = Meat(
        id: widget.id,
        name: _nameController.text,
        type: _selectedType!,
        quantity: double.parse(_quantityController.text),
        entryDate: _entryDate!,
        expirationDate: _expirationDate!,
        placedBy: int.parse(_placedByController.text),
        placedIn: widget.freezer.id,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      widget.viewModel.addMeat(meat);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Carne')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              DropdownButtonFormField<MeatType>(
                value: _selectedType,
                items: MeatType.values
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.name),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedType = val),
                decoration: const InputDecoration(labelText: 'Tipo'),
                validator: (v) => v == null ? 'Selecione o tipo' : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantidade (kg)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe a quantidade' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(_entryDate == null
                        ? 'Data de entrada:'
                        : 'Entrada: ${dateFormat.format(_entryDate!)}'),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context, true),
                    child: const Text('Selecionar'),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(_expirationDate == null
                        ? 'Data de validade:'
                        : 'Validade: ${dateFormat.format(_expirationDate!)}'),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context, false),
                    child: const Text('Selecionar'),
                  ),
                ],
              ),
              TextFormField(
                controller: _placedByController,
                decoration: const InputDecoration(
                    labelText: 'Colocado por (ID do usuário)'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o usuário' : null,
              ),
              TextFormField(
                controller: _notesController,
                decoration:
                    const InputDecoration(labelText: 'Observações (opcional)'),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
