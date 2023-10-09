import 'package:flutter/material.dart';

void main() => runApp(NimGameApp());

class NimGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo NIM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey[900],
        primaryColor: Colors.purple,
        accentColor: Colors.purpleAccent,
      ),
      home: NimGameScreen(),
    );
  }
}

class NimGameScreen extends StatefulWidget {
  @override
  _NimGameScreenState createState() => _NimGameScreenState();
}

class _NimGameScreenState extends State<NimGameScreen> {
  String playerName = "Samuel Henrique Ricomini Souza";
  String playerID = "1431432312002";
  int totalSticks = 0;
  int maxSticksToRemove = 0;
  int remainingSticks = 0;
  bool playerTurn = true;
  String message = "";
  List<int> sticksRemovedByPlayer = [];
  List<String> moveHistory = [];
  int sticksToRemoveByUser = 0;

  TextEditingController totalSticksController = TextEditingController();
  TextEditingController maxSticksToRemoveController = TextEditingController();

  void startGame() {
    totalSticks = int.tryParse(totalSticksController.text) ?? 0;
    maxSticksToRemove = int.tryParse(maxSticksToRemoveController.text) ?? 0;

    if (totalSticks >= 2 && maxSticksToRemove >= 1) {
      remainingSticks = totalSticks;
      moveHistory.clear();

      if (remainingSticks % (maxSticksToRemove + 1) == 0) {
        playerTurn = true;
        message = "Você começa!";
      } else {
        playerTurn = false;
        message = "Computador começa!";
        int initialSticks = remainingSticks;
        int sticksToTake = 1;

        while ((initialSticks - sticksToTake) % (maxSticksToRemove + 1) != 0) {
          sticksToTake++;
        }

        remainingSticks -= sticksToTake;
        moveHistory.add('Computador removeu $sticksToTake palito(s).');
        message = "Computador removeu $sticksToTake palito(s).";

        if (remainingSticks == 0) {
          message = "Fim do Jogo: Computador Venceu!";
          moveHistory.add(message);
        }

        playerTurn = true;
      }
    } else {
      message = "Preencha todos os campos corretamente.";
    }
    setState(() {});
  }

  void restartGame() {
    totalSticksController.clear();
    maxSticksToRemoveController.clear();
    startGame();
  }

  void removeSticks(int quantity) {
    if (remainingSticks <= 0) {
      return;
    }

    if (quantity >= 1 &&
        quantity <= maxSticksToRemove &&
        quantity <= remainingSticks) {
      sticksRemovedByPlayer.add(quantity);
      remainingSticks -= quantity;
      moveHistory.add('$playerName removeu $quantity palito(s).');

      if (remainingSticks <= 0) {
        if (playerTurn) {
          message = "Fim do Jogo: Você Perdeu!";
        } else {
          message = "Fim do Jogo: Computador Venceu!";
        }
        moveHistory.add(message);
      } else {
        playerTurn = !playerTurn;
        if (!playerTurn) {
          int initialSticks = remainingSticks;
          int sticksToTake = 1;

          while ((initialSticks - sticksToTake) % (maxSticksToRemove + 1) != 0) {
            sticksToTake++;
          }

          remainingSticks -= sticksToTake;
          moveHistory.add('Computador removeu $sticksToTake palito(s).');
          message = "O computador removeu $sticksToTake palito(s).";

          if (remainingSticks == 0) {
            message = "Fim do Jogo: Computador Venceu!";
            moveHistory.add(message);
          }

          playerTurn = true;
        }
      }
    } else {
      message = "Escolha uma quantidade válida de palitos.";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo NIM'),
      ),
      body: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Desenvolvido por $playerName\nRA: $playerID',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: totalSticksController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantidade de Palitos Total',
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: maxSticksToRemoveController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Máx. de Palitos a Retirar',
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: startGame,
                child: Text('Iniciar Jogo'),
              ),
              SizedBox(height: 20.0),
              Text(
                'Palitos Restantes: $remainingSticks',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 20.0),
              Text(
                'Mensagem: $message',
                style: TextStyle(fontSize: 20.0),
              ),
              if (message.contains("Fim do Jogo"))
                ElevatedButton(
                  onPressed: restartGame,
                  child: Text('Reiniciar Jogo'),
                ),
              SizedBox(height: 20.0),
              Text(
                'Jogadas:',
                style: TextStyle(fontSize: 20.0),
              ),
              Expanded(
                child: ListView(
                  children: moveHistory.map((move) => Text(move)).toList(),
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantidade de Palitos a Retirar',
                ),
                onChanged: (value) {
                  int inputQuantity = int.tryParse(value) ?? 0;
                  if (inputQuantity >= 1 &&
                      inputQuantity <= maxSticksToRemove &&
                      inputQuantity <= remainingSticks) {
                    sticksToRemoveByUser = inputQuantity;
                  } else {
                    sticksToRemoveByUser = 0;
                  }
                },
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  if (sticksToRemoveByUser > 0) {
                    removeSticks(sticksToRemoveByUser);
                  } else {
                    message = "Escolha uma quantidade válida de palitos.";
                    setState(() {});
                  }
                },
                child: Text('Retirar Palitos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
