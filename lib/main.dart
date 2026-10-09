import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Лабораторная работа'),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _v0 = TextEditingController();
  final TextEditingController _v = TextEditingController();
  final TextEditingController _t = TextEditingController();

  bool _agree = false;
  bool _agreeError = false;

  @override
  void dispose() {
    _v0.dispose();
    _v.dispose();
    _t.dispose();
    super.dispose();
  }

  void _goToResult() {
    final formOk = _formKey.currentState!.validate();
    setState(() {
      _agreeError = !_agree;
    });

    if (!formOk || !_agree) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          v0: double.parse(_v0.text),
          v: double.parse(_v.text),
          t: double.parse(_t.text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _v0,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Начальная скорость v0 (м/с)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите начальную скорость';
                }
                if (double.tryParse(value) == null) {
                  return 'Введите число';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            TextFormField(
              controller: _v,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Конечная скорость v (м/с)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите конечную скорость';
                }
                if (double.tryParse(value) == null) {
                  return 'Введите число';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            TextFormField(
              controller: _t,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Время t (с)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите время';
                }
                final t = double.tryParse(value);
                if (t == null) return 'Введите число';
                if (t <= 0) return 'Время должно быть больше 0';
                return null;
              },
            ),
            SizedBox(height: 16),

            CheckboxListTile(
              title: Text('Согласен на обработку данных'),
              value: _agree,
              onChanged: (val) {
                setState(() {
                  _agree = val ?? false;
                  _agreeError = false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            if (_agreeError)
              Text(
                'Необходимо согласие на обработку данных',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),

            SizedBox(height: 16),

            ElevatedButton(
              onPressed: _goToResult,
              child: Text('Рассчитать'),
            ),
          ],
        ),
      ),
    );
  }
}

// второй экран
class ResultScreen extends StatelessWidget {
  final double v0;
  final double v;
  final double t;

  ResultScreen({required this.v0, required this.v, required this.t});

  @override
  Widget build(BuildContext context) {
    final a = (v - v0) / t;

    return Scaffold(
      appBar: AppBar(
        title: Text('Результат'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('v0 = $v0 м/с'),
            Text('v  = $v м/с'),
            Text('t  = $t с'),
            SizedBox(height: 16),
            Text(
              'Ускорение a = ${a.toStringAsFixed(2)} м/с²',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}