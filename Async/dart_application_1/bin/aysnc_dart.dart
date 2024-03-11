void main(List<String> arguments) async {
  print('Hello world:!');
  getDataFormDatabase().then((value) {
    print(value);
  });
  print('Done');
}


// Future: Future<List<String>>
// async
// await
// then

Future<String> getDataFormDatabase() async {
  print('Start!');

  // Handing data from database
  final result = await Future.delayed(
    Duration(seconds: 5),
    (){
      return 'Data';
    }
  );

  return result;
}