import 'package:flutter/material.dart';

import '../../domain/entities/freezer.dart';
import '../../domain/viewmodels/freezer_view_model.dart';
import '../form/freezer_form.dart';

class AddFreezerPage extends StatefulWidget {
  const AddFreezerPage({
    super.key,
    required this.id,
    required this.viewModel,
  });

  final int id;
  final FreezerViewModel viewModel;

  @override
  State<AddFreezerPage> createState() => _AddFreezerPageState();
}

class _AddFreezerPageState extends State<AddFreezerPage> {
  final _formKey = GlobalKey<FormState>();
  final freezerForm = FreezerForm();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.viewModel.addFreezer(Freezer(
          id: widget.id,
          name: freezerForm.name.value,
          location: freezerForm.location.value));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Freezer adicionado com sucesso!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Freezer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) => freezerForm.name.validate(value ?? ''),
                onChanged: freezerForm.setName,
                decoration: const InputDecoration(labelText: 'Nome do Freezer'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                validator: (value) =>
                    freezerForm.location.validate(value ?? ''),
                onChanged: freezerForm.setLocation,
                decoration: const InputDecoration(labelText: 'Localização'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
