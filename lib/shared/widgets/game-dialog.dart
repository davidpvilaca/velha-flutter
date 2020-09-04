import 'package:flutter/material.dart';

class GameDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback callback;
  final String actionText;

  GameDialog(this.title, this.content, this.callback,
      [this.actionText = "Reiniciar"]);

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text(title),
      content: new Text(content),
      actions: <Widget>[
        new FlatButton(
          onPressed: callback,
          color: Colors.white,
          child: new Text(actionText),
        )
      ],
    );
  }
}
