import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VaultItem extends StatefulWidget {
  final dynamic data;

  const VaultItem({super.key, required this.data});

  @override
  State<VaultItem> createState() => _VaultItemState();
}

class _VaultItemState extends State<VaultItem> {
  bool passwordReveal = false;
  bool hoveringOnPassword = false;

  void revealPassword() {
    setState(() {
      passwordReveal = !passwordReveal;
    });
  }

  Future<void> setDataToClipboard(data) async {
    await Clipboard.setData(ClipboardData(text: data));
  }

  void setHoveringStatus(torf) {
    debugPrint(torf);
    setState(() {
      hoveringOnPassword = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.0,
      width: 50.0,
      child: Column(children: [
        Text(
          widget.data['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          widget.data['url'],
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        Text(widget.data['userName']),
        MouseRegion(
          onEnter: (event) => hoveringOnPassword,
          onExit: (event) => hoveringOnPassword,
          child: Container(
            color: Theme.of(context).backgroundColor,
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onLongPress: () {
                setDataToClipboard(widget.data['password']);
              },
              onPressed: () {
                setDataToClipboard(widget.data['password']);
              },
              child: const Text('Copy Password',
                  style: TextStyle(color: Colors.black)),
            ),
          ),
        ),
        const Divider(
          thickness: 2.0,
        )
      ]),
    );
  }
}
