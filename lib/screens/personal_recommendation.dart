import 'package:flutter/material.dart';

class PersonalRecommendation extends StatefulWidget {
  const PersonalRecommendation({Key key}) : super(key: key);

  @override
  State<PersonalRecommendation> createState() => _PersonalRecommendationState();
}

class _PersonalRecommendationState extends State<PersonalRecommendation> {
  int _currentStep = 0;
  TextEditingController ageController = TextEditingController();
  String skinType;
  String skinConcern;
  String productCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Recommendation"),
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() {
              _currentStep += 1;
            });
          } else {
            // Handle the final step logic and product recommendation here
            // You can access the collected data from ageController, skinType, skinConcern, and productCategory
            // Perform the necessary actions, e.g., fetch product recommendations based on the collected data
            // After processing, you can navigate to a new screen or display the recommendations
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => RecommendationScreen()),
            );
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        steps: [
          Step(
            title: Text("Age"),
            content: Column(
              children: [
                Image.network("https://example.com/age_image.jpg"),
                Text("Your Age?"),
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Enter your Age"),
                ),
              ],
            ),
          ),
          Step(
            title: Text("Skin Type"),
            content: Column(
              children: [
                Image.network("https://example.com/skin_image.jpg"),
                Text("What is your Skin Type?"),
                // Add dropdowns or text fields for Skin Concern and Product Category
              ],
            ),
          ),
          Step(
            title: Text("Recommended Products"),
            content: Column(
              children: [
                Text("Recommendation For You"),
                // Display collected data and product recommendations
                // You can use the data collected from previous steps (ageController, skinType, skinConcern, productCategory)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Recommendations"),
      ),
      body: Center(
        child: Text(
            "No products found."), // You can replace this with actual product recommendations
      ),
    );
  }
}
