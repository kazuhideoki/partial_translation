import 'package:provider/provider.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:flutter/material.dart';


class CounterNotifer extends StateNotifier<int> {
  CounterNotifer() : super(0);
  void incrementCounter() {
    state++;
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateNotifierProvider<CounterNotifer, int>(
      create: (_) => CounterNotifer(),
      child: CounterPage(),
    );
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          context.watch<int>().toString(),
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: Provider.of<CounterNotifer>(context, listen: false)
            .incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}