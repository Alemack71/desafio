import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/car_selection_page.dart';

class MyNavigator extends StatelessWidget {
  final int selectedIndex;

  const MyNavigator({
    super.key,
    required this.selectedIndex,
  });

  void _navigate(BuildContext context, int index) {
    Navigator.pop(context); // Fecha o Dialog antes de navegar

    //Evitando que navegue para si mesmo
    if (index == 0 && selectedIndex != 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(selectedIndex: 0),
        ),
      );
    } else if (index == 1 && selectedIndex != 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CarSelectionScreen(selectedIndex: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 150,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.grey,
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10),
          ],
        ),
        child: NavigationRail(
          extended: true,
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) => _navigate(context, index),
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.home, size: 30),
              label: Text('Home', style: TextStyle(fontSize: 16)),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.question_answer),
              label: Text('Chatbot', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}