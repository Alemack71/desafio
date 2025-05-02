import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/car_selection_page.dart';

class MyNavigator extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const MyNavigator({
    super.key, 
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

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
          onDestinationSelected: (int index) {
            // Fecha o dialog antes de navegar
            Navigator.pop(context); 

            if (index == 0) {
              // Se for Home
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(selectedIndex: 0),
                ),
              );
            } else if (index == 1) {
              // Se for Car Selection
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CarSelectionScreen(selectedIndex: 1),
                ),
              );
            }
          },
          destinations: const[
            NavigationRailDestination(
              icon: Icon(
                Icons.home, 
                size: 30,
              ),
              label: Text(
                'Home',
                style: TextStyle(fontSize: 16),
              ),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.question_answer),
              label: Text(
                'Chatbot',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}