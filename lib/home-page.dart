import 'package:flutter/material.dart';
import 'package:velhaFlutter/core/services/game.service.dart';
import 'package:velhaFlutter/shared/widgets/game-dialog.dart';

class GameButton {
  final id;
  String text;
  Color bg;
  bool enabled;

  GameButton(
      {this.id, this.text = "", this.bg = Colors.grey, this.enabled = true});
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GameButton> buttonsList;
  GameService game;

  @override
  void initState() {
    super.initState();
    buttonsList = doInit();
  }

  List<GameButton> doInit() {
    game = GameService(player1: new List(), player2: new List());

    var gameButtons = <GameButton>[
      new GameButton(id: 1),
      new GameButton(id: 2),
      new GameButton(id: 3),
      new GameButton(id: 4),
      new GameButton(id: 5),
      new GameButton(id: 6),
      new GameButton(id: 7),
      new GameButton(id: 8),
      new GameButton(id: 9),
    ];
    return gameButtons;
  }

  void playGame(GameButton gb) {
    setState(() {
      if (game.activePlayer == 1) {
        gb.text = "X";
        gb.bg = Colors.red;
        game.mark(gb.id);
      } else {
        gb.text = "0";
        gb.bg = Colors.black;
        game.mark(gb.id);
      }
      gb.enabled = false;
      int winner = game.checkWinner();
      if (winner == -1) {
        if (buttonsList.every((p) => p.text != "")) {
          showDialog(
              context: context,
              builder: (_) => new GameDialog(
                  "Empate!",
                  "Pressione o botão \"Reiniciar\" para jogar novamente.",
                  resetGame));
        }
      } else {
        game.nextPlayer();
        int winnerPlayer = game.activePlayer;
        showDialog(
            context: context,
            builder: (_) => new GameDialog("Vencedor!",
                "O jogador $winnerPlayer venceu a partida.", resetGame));
      }
    });
  }

  void resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    setState(() {
      buttonsList = doInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    int activePlayer = game.activePlayer;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Jogo da Velha"),
        ),
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: Center(
                child: Text(
                  'É a vez do Jogador $activePlayer',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            new Expanded(
              child: new GridView.builder(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5),
                itemCount: 9,
                itemBuilder: (context, i) => new SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: new RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    onPressed: buttonsList[i].enabled
                        ? () => playGame(buttonsList[i])
                        : null,
                    child: new Text(
                      buttonsList[i].text,
                      style: new TextStyle(color: Colors.white, fontSize: 25.0),
                    ),
                    color: buttonsList[i].bg,
                    disabledColor: buttonsList[i].bg,
                  ),
                ),
              ),
            ),
            new RaisedButton(
              child: new Text(
                "Reiniciar",
                style: new TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              color: Colors.redAccent,
              padding: const EdgeInsets.all(20.0),
              onPressed: resetGame,
            )
          ],
        ));
  }
}
