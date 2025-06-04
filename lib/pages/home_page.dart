import 'package:firebase_auth/firebase_auth.dart';
//Componentes   -----------------------------------------------
import 'package:desafio/components/my_button.dart';
import 'package:desafio/components/my_header.dart';
//              -----------------------------------------------
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final int selectedIndex;

  const HomePage({super.key, this.selectedIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int selectedIndex = 0;
  late TextEditingController _brandController1;
  late TextEditingController _brandController2;
  late TextEditingController _modelController1;
  late TextEditingController _modelController2;

  //Variável para controlar CircularProgression do MyButton
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  //Controller para outros widgets conseguirem ler o texto escrito pela IA
  final TextEditingController _responseController = TextEditingController();

  //Controller para outros widgets conseguirem ler o texto nos campos AutoComplete

  User? get currentUser => FirebaseAuth.instance.currentUser;
  /*
  //Função para abrir menu bar
  void openNavigationRail() {
    showDialog(
      context: context,
      //Se clicar fora fecha
      barrierDismissible: true,
      builder: (context) => MyNavigator(selectedIndex: selectedIndex),
    );
  }
  */

  //endpoint da api de IA
  final String apiRequestUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyA5Rviqje5bNnAb1AsPcm_aird7Jp2evR8";
  String apiResponse = "";

  final Map<String, List<String>> carBrands = {
    'Toyota': ['Corolla', 'Camry', 'Yaris', 'Hilux', 'Etios', 'Prius'],
    'Honda': ['Civic', 'Accord', 'Fit', 'HR-V', 'CR-V', 'City'],
    'Ford': ['Focus', 'Fiesta', 'Mustang', 'Ranger', 'EcoSport', 'Ka'],
    'Volkswagen': ['Gol', 'Polo', 'Virtus', 'T-Cross', 'Nivus', 'Saveiro'],
    'Fiat': ['Uno', 'Mobi', 'Argo', 'Cronos', 'Toro', 'Strada'],
    'Chevrolet': ['Onix', 'Prisma', 'Cruze', ' Tracker', 'S10', 'Spin'],
  };

  String? selectedBrand1;
  String? selectedBrand2;
  String? selectedModel1;
  String? selectedModel2;

  Future<void> sendData() async {
    if (selectedBrand1 == null ||
        selectedBrand2 == null ||
        selectedModel1 == null ||
        selectedModel2 == null) {
      setState(() {
        apiResponse = "Por favor, selecione todas as opções.";
      });
      return;
    }

    String question =
        "Compare os dois carros e diga se vale a pena trocar um $selectedBrand1 $selectedModel1 por um $selectedBrand2 $selectedModel2. Diga os pontos positivos e negativos em relação à cada um deles e resuma os pontos importantes e deixe claro no final da resposta se vale a pena ou não";

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final response = await http.post(
        Uri.parse(apiRequestUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": question},
              ],
            },
          ],
        }),
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        setState(() {
          apiResponse =
              jsonResponse["candidates"][0]["content"]["parts"][0]["text"] ??
              "Nenhuma resposta recebida.";
          _responseController.text = apiResponse;
        });
      } else {
        setState(() {
          apiResponse = "Erro ao carregar dados: ${response.statusCode}";
        });
      }
    } catch (e) {
      Navigator.pop(context);
      setState(() {
        apiResponse = "Erro: $e";
      });
    }
  }

  //Função para apagar o texto e voltar os AutoComplete input ao padrão
  void _clearText() {
    setState(() {
      _responseController.clear();
      _brandController1.clear();
      _brandController2.clear();
      _modelController1.clear();
      _modelController2.clear();
      selectedBrand1 = null;
      selectedBrand2 = null;
      selectedModel1 = null;
      selectedModel2 = null;
      apiResponse = "";
    });
  }

  //=======================Aqui separa backend do frontend=======================================================
  //=======================Aqui separa backend do frontend=======================================================
  //=======================Aqui separa backend do frontend=======================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: MyHeader(selectedIndex: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Atual', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Futuro', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: buildBrandAutocomplete(1)),
                const SizedBox(width: 20), //Espaço entre os dois
                Expanded(child: buildBrandAutocomplete(2)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child:
                      selectedBrand1 != null
                          ? buildModelAutocomplete(1)
                          : const SizedBox(), //Espaço reservado
                ),
                const SizedBox(width: 20), //Espaço entre os dois
                Expanded(
                  child:
                      selectedBrand2 != null
                          ? buildModelAutocomplete(2)
                          : const SizedBox(), //Espaço reservado
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (selectedModel1 != null &&
                selectedModel2 != null &&
                carBrands[selectedBrand1]?.contains(
                      _modelController1.text.trim(),
                    ) ==
                    true &&
                carBrands[selectedBrand2]?.contains(
                      _modelController2.text.trim(),
                    ) ==
                    true)
              Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: MyButton(onTap: sendData, text: "Comparar", isLoading: isLoading,),
                      ),
                    ),

                    ElevatedButton.icon(
                      onPressed: _clearText,
                      label: Icon(Icons.delete, size: 30),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[400], // Cor de fundo
                        foregroundColor: Colors.black, // Cor do ícone
                        minimumSize: Size(50, 70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            8,
                          ), // Borda arredondada
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),
            SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                //Usar TextField ao invés de Text para a resposta da Ia para conseguir usar controller para conseguir limpar o texto
                child: Text(apiResponse, style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBrandAutocomplete(int index) {
    List<String> brands = carBrands.keys.toList();

    return SizedBox(
      width: 150,
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return brands;
          }
          return brands.where((String brand) {
            return brand.toLowerCase().contains(
              textEditingValue.text.toLowerCase(),
            );
          }).toList();
        },
        onSelected: (String selection) {
          setState(() {
            if (index == 1) {
              selectedBrand1 = selection;
              selectedModel1 = null;
            } else {
              selectedBrand2 = selection;
              selectedModel2 = null;
            }
          });
        },
        fieldViewBuilder: (
          context,
          textEditingController,
          focusNode,
          onFieldSubmitted,
        ) {
          // Armazene o controller para poder limpar depois
          if (index == 1) {
            _brandController1 = textEditingController;
          } else {
            _brandController2 = textEditingController;
          }

          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: const InputDecoration(
              hintText: 'Marca',
              border: OutlineInputBorder(),
            ),
          );
        },
      ),
    );
  }

  Widget buildModelAutocomplete(int index) {
    List<String> models =
        carBrands[index == 1 ? selectedBrand1 ?? "" : selectedBrand2 ?? ""] ??
        [];

    return SizedBox(
      width: 150,
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return models;
          }
          return models.where((String model) {
            return model.toLowerCase().contains(
              textEditingValue.text.toLowerCase(),
            );
          }).toList();
        },
        onSelected: (String selection) {
          setState(() {
            if (index == 1) {
              selectedModel1 = selection;
            } else {
              selectedModel2 = selection;
            }
          });
        },
        fieldViewBuilder: (
          context,
          textEditingController,
          focusNode,
          onFieldSubmitted,
        ) {
          if (index == 1) {
            _modelController1 = textEditingController;
          } else {
            _modelController2 = textEditingController;
          }

          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: const InputDecoration(
              hintText: 'Modelo',
              border: OutlineInputBorder(),
            ),
          );
        },
      ),
    );
  }
}
