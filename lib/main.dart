import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, String?> dados = {};
  var maskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  var phoneMaskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void initState() {
    super.initState();

    loadSavedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BIBLIOTECA",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.menu_book_sharp,
                color: Colors.white,
              ),
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: const Color(0xFF0a3a66),
        elevation: 0,
        toolbarHeight: 50,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(60)),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          onChanged: () {
            Form.of(primaryFocus!.context!).save();
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  height: 150,
                  width: 150,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Nome do livro",
                      floatingLabelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => dados['nomeDoLivro'] = value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      maskFormatter,
                    ],
                    decoration: const InputDecoration(
                      labelText: "Data de Aquisição",
                      floatingLabelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => dados['dataDeAquisicao'] = value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      maskFormatter,
                    ],
                    decoration: const InputDecoration(
                      labelText: "Data de entrega",
                      floatingLabelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => dados['dataDeEntrega'] = value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Nome do Integrante",
                      floatingLabelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => dados['nomeDoIntegrante'] = value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Endereço",
                      floatingLabelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => dados['endereco'] = value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Telefone",
                      floatingLabelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => dados['telefone'] = value,
                    inputFormatters: [phoneMaskFormatter],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    saveData();
                    share();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF0a3a66)), // Cor de fundo
                  ),
                  child: const Text(
                    "ENVIAR",
                    style: TextStyle(
                      color: Colors.white, // Cor do texto
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('nomeDoLivro', dados['nomeDoLivro'] ?? '');
    prefs.setString('dataDeAquisicao', dados['dataDeAquisicao'] ?? '');
    prefs.setString('dataDeEntrega', dados['dataDeEntrega'] ?? '');
    prefs.setString('nomeDoIntegrante', dados['nomeDoIntegrante'] ?? '');
    prefs.setString('endereco', dados['endereco'] ?? '');
    prefs.setString('telefone', dados['telefone'] ?? '');
  }

  void loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dados['nomeDoLivro'] = prefs.getString('nomeDoLivro') ?? '';
      dados['dataDeAquisicao'] = prefs.getString('dataDeAquisicao') ?? '';
      dados['dataDeEntrega'] = prefs.getString('dataDeEntrega') ?? '';
      dados['nomeDoIntegrante'] = prefs.getString('nomeDoIntegrante') ?? '';
      dados['endereco'] = prefs.getString('endereco') ?? '';
      dados['telefone'] = prefs.getString('telefone') ?? '';
    });
  }

  void share() {
    var msg = '''
Nome do Livro: ${dados['nomeDoLivro']}

Data de Aquisição: ${dados['dataDeAquisicao']}

Data de Entrega: ${dados['dataDeEntrega']}

Nome do Integrante: ${dados['nomeDoIntegrante']}

Endereço: ${dados['endereco']}

Telefone: ${dados['telefone']}
''';

    Share.share(msg);
  }
}
