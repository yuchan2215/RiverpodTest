import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

///Provider
final doubleCountProvider = Provider<int>((ref) {
  final count = ref.watch(countStateNotifierProvider);
  return count * 2;
});

///StateProvider
final countStateProvider = StateProvider<int>((ref) => 0);

///StateNotifierProvider
class CountStateNotifier extends StateNotifier<int> {
  CountStateNotifier() : super(0);

  void increment() => state++;
}

final countStateNotifierProvider =
    StateNotifierProvider<CountStateNotifier, int>((ref) {
  return CountStateNotifier();
});

///FutureProvider
final countFutureProvider = FutureProvider<String>((ref) async {
  await Future.delayed(const Duration(seconds: 5));
  return "5秒経過しました！";
});

///StreamProvider
Stream<int> randomValueStream() async* {
  final random = Random();
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    yield random.nextInt(100);
  }
}

final countStreamProvider = StreamProvider<int>((ref) => randomValueStream());

///ChangeNotifierProvider
class CountChangeNotifier extends ChangeNotifier {
  int count = 0;

  void increment() => count++;
}

final countChangeNotifierProvider =
    ChangeNotifierProvider<CountChangeNotifier>((ref) {
  return CountChangeNotifier();
});

class MyHomePage extends ConsumerWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Provider
    int doubleCount = ref.watch(doubleCountProvider);

    //StateProvider
    int countState = ref.watch(countStateProvider);

    //StateNotifierProvider,StateNotifier
    int countStateNotifier = ref.watch(countStateNotifierProvider);

    //FutureProvider
    AsyncValue<String> countFuture = ref.watch(countFutureProvider);

    //SteamProvider
    AsyncValue<int> countStream = ref.watch(countStreamProvider);

    //ChangeNotifierProvider
    int countChangeNotifier = ref.watch(countChangeNotifierProvider).count;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(0.5),
            1: FlexColumnWidth(0.5),
          },
          children: [
            TableRow(children: [
              const Text("Provider"),
              Text("$doubleCount"),
            ]),
            TableRow(children: [
              const Text("StateProvider"),
              Text("$countState"),
            ]),
            TableRow(children: [
              const Text("StateNotifierProvider"),
              Text("$countStateNotifier"),
            ]),
            TableRow(children: [
              const Text("FutureProvider"),
              Text(countFuture.when(
                  data: (String data) => data,
                  error: (_, __) => "error",
                  loading: () => "loading")),
            ]),
            TableRow(children: [
              const Text("StreamProvider"),
              Text(countStream.when(
                  data: (int data) => "$data",
                  error: (_, __) => "error",
                  loading: () => "loading")),
            ]),
            TableRow(children: [
              const Text("ChangeNotifierProvider"),
              Text("$countChangeNotifier"),
            ]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(countStateNotifierProvider.notifier).increment();
          ref.read(countStateProvider.notifier).update((state) => state + 1);
          ref.read(countChangeNotifierProvider).count++;
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
