import 'package:flutter/material.dart';
import 'package:stashi/models/account.dart';

class SettingsScreen extends StatelessWidget {
  final Account account;
  final _editController = TextEditingController();

  SettingsScreen({Key? key, required this.account}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _editController.text = account.settings.walletAddress;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _editController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'My Collection\'s Ethereum Address',
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (_editController.text.isNotEmpty) {
                account.updateAddress(_editController.text);
              }
              // showDialog(
              //   context: context,
              //   builder: (context) {
              //     return AlertDialog(
              //       content: Text('Go ${_editController.text}'),
              //     );
              //   }
              // );
            },
            child: const Text('Update'),
          ),
          // Row(
          //   children: [
          //     const TextField(
          //       decoration: InputDecoration(
          //         border: OutlineInputBorder(),
          //         hintText: 'an Ethereum address',
          //       ),
          //     ),
          //     // TextButton(
          //     //   onPressed: () { },
          //     //   child: const Text('Update'),
          //     // ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
