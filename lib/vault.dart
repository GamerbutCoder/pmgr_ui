import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:pgmr_ui/common.dart';
import 'package:pgmr_ui/vault_item.dart';

class Vault extends StatefulWidget {
  const Vault({super.key});

  @override
  State<Vault> createState() => _VaultState();
}

class _VaultState extends State<Vault> {
  List<dynamic> vaultData = [];

  void fetchVaultData() async {
    var url = Uri.parse("http://localhost:3000/vault");
    var token = await getToken();
    var headers = {'Authorization': "Bearer $token"};
    debugPrint("$headers");
    var response = await http.get(url, headers: headers);
    debugPrint("vault data ==> ${response.statusCode} ${response.body}");
    //TODO: handler 401 seperately and error later
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        vaultData = data;
      });
    } else if (response.statusCode == 401) {
      //just a hack
      clearToken();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchVaultData();
  }

  @override
  Widget build(BuildContext context) {
    List<VaultItem> listItems = vaultData
        .map((e) => VaultItem(
              data: e,
            ))
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text('Vault')),
      body: ListView(
        children: listItems,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
