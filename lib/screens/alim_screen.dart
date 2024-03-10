import 'package:flutter/material.dart';

class AlimScreen extends StatelessWidget {
  const AlimScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alışveriş Listesi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Container(
          width: 200,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const SimpleDialog(
                    title: Text('Market'),
                    children: <Widget>[
                      SimpleDialogOption(
                        child: Text('4 Süt'),
                      ),
                      SimpleDialogOption(
                        child: Text('2 Kola'),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
            child: const Text(
              'Market',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          width: 200,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const SimpleDialog(
                    title: Text('Fırın'),
                    children: <Widget>[
                      SimpleDialogOption(
                        child: Text('4 Ekmek'),
                      ),
                      SimpleDialogOption(
                        child: Text('2 Simit'),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
            child: const Text(
              'Fırın',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          width: 200,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const SimpleDialog(
                    title: Text('Manav'),
                    children: <Widget>[
                      SimpleDialogOption(
                        child: Text('4 Kilo Domates'),
                      ),
                      SimpleDialogOption(
                        child: Text('2 Kilo Elma'),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
            child: const Text(
              'Manav',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          width: 200,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // Handle Dağıtım button tap
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
              child: const Text(
                'Diğer',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ),
          ],
        ),
      ),
    );
  }
}