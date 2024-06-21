void main() async {
  // Simple print statement
  print("3" + "7");
  print("3" * 7);

  // Variables
  int num1 = 15;
  int num2 = 30;
  int product = num1 * num2;
  print("First number: $num1");
  print("Second number: $num2");
  print("Product: $product");

  dynamic dynamicVar = "Example";
  print("dynamicVar is of type: ${dynamicVar.runtimeType}");

  String multiLineStr = """This is a 
  multi-line string.""";
  print(multiLineStr);

  // Const and final
  final currentDate = DateTime.now();
  const constantValue = 25;
  print(currentDate);
  print(constantValue);

  // Nullable variables
  String? nullableStr;
  print(nullableStr);
  print(nullableStr?.length ?? 0);

  // If statements
  int studentAge = 15;
  bool hasPermission = true;

  if (studentAge >= 18) {
    if (hasPermission) {
      print("Yes, you can participate in the exam.");
    }
  } else if (studentAge >= 16) {
    if (hasPermission) {
      print("You can participate in the exam, but only with parental consent.");
    }
  } else {
    print("You are not eligible to participate in the exam.");
  }

  // Ternary operator
  String eligibilityStatus = (studentAge >= 18) ? "Eligible" : "Not Eligible";
  print("You are $eligibilityStatus for the exam.");

  // Switch statement
  switch (studentAge) {
    case 10:
      print("You are 10 years old.");
      break;
    case 20:
      print("You are 20 years old.");
      break;
    default:
      print("Your age is not specified.");
  }

  // For loops
  for (int i = 0; i < 5; i++) {
    print("Hello from iteration $i");
  }

  String sampleStr = "Hello World";
  int index = 0;

  while (index <= 11) {
    if (index == 5) {
      index++;
      break;
    } else {
      print(sampleStr[index]);
      index++;
    }
  }

  // Do while loop
  do {
    print("This is a do-while loop iteration $index");
    index++;
  } while (index < 15);

  // Continue keyword
  for (int k = 0; k < 10; k++) {
    if (k % 2 == 0) continue; // Skip even numbers
    print("Odd number: $k");
  }

  // Functions
  String personName = "Abeerah";
  var functionResult = processName(personName);
  print(functionResult);
  print("Age is ${processName(personName).$1}");

  // Function named arguments
  greetPerson(name: "Abeerah", age: 17);

  // Returning functions from functions
  var addTen = createAdder(10);
  print(addTen(5)); // 15

  // Arrow functions
  int squareNum(int x) => x * x;
  print(squareNum(3)); // 9

  // Higher-order functions
  executeFirst(executeSecond);

  // Classes
  Car myCar = Car("Tesla", "Model S");
  myCar.displayDetails();

  myCar.model = "Model X";
  print("The car model is now ${myCar.model}");
  print("The color of the car is ${myCar.color}");

  // Lists
  List<Car> carList = [
    Car("Tesla", "Model S"),
    Car("BMW", "X5"),
    Car("Audi", "Q7"),
    Car("Mercedes", "GLE")
  ];

  carList.add(Car("Porsche", "Cayenne"));
  carList.removeLast();

  for (int i = 0; i < carList.length; i++) {
    print(carList[i].make);
  }

  final teslas = carList.where((car) => car.make == "Tesla").toList();

  for (int i = 0; i < teslas.length; i++) {
    print(teslas[i].make);
  }

  // Sets
  Set<int> uniqueSet = {1, 2, 2, 3, 4, 4, 5};
  uniqueSet.add(7);
  uniqueSet.remove(3);
  print(uniqueSet);

  // Maps
  Map<String, int> scores = {
    "Math": 95,
    "Science": 85,
    "History": 75,
  };

  scores["PE"] = 90;

  scores.forEach((subject, score) {
    print("$subject: $score");
  });

  // Enums
  Weather weather = Weather.sunny;
  print("The weather is ${weather.description} ${weather.icon}");

  // Exception handling
  try {
    print(10 ~/ 0);
  } catch (e) {
    print(e);
  } finally {
    print("This will always execute.");
  }

  print("Abeerah");

  // Future and async wait
  var result = await calculateSum(20, 25);
  print("The awaited result is: $result");

  // Streams
  await for (var value in streamCounter()) {
    print(value);
  }

  // Higher-order functions
  executeFirst(executeSecond);

  // Extension methods
  print("hello".capitalize());
}

// Functions for practicing higher-order functions
void executeFirst(Function secondFunction) {
  secondFunction();
}

void executeSecond() {
  print("I am the second function in higher-order functions.");
}

// Function with named arguments
void greetPerson({required String name, required int age}) {
  print("Hello $name, you are $age years old.");
}

// Function returning another function
Function createAdder(int incrementBy) {
  return (int i) => incrementBy + i;
}

// Function for future - async wait
Future<int> calculateSum(int a, int b) {
  return Future.delayed(Duration(seconds: 2), () => a + b);
}

// Function for stream
Stream<int> streamCounter() async* {
  for (int i = 0; i < 5; i++) {
    yield i;
    await Future.delayed(Duration(seconds: 1));
  }
}

// Extension method
extension StringExt on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

// Enums and their extensions
enum Weather {
  sunny,
  cloudy,
  rainy,
}

extension WeatherExt on Weather {
  String get description {
    switch (this) {
      case Weather.sunny:
        return "Sunny";
      case Weather.cloudy:
        return "Cloudy";
      case Weather.rainy:
        return "Rainy";
      default:
        return "";
    }
  }

  String get icon {
    switch (this) {
      case Weather.sunny:
        return "☀️";
      case Weather.cloudy:
        return "☁️";
      case Weather.rainy:
        return "🌧️";
      default:
        return "";
    }
  }
}

// Classes
class Vehicle {
  String color = "red";
}

// Abstract classes
abstract class VehicleInterface {
  void displayDetails();
}

// Mixins
mixin Drivable {
  void drive() {
    print("Driving...");
  }
}

class Car extends Vehicle with Drivable implements VehicleInterface {
  String make;
  String model;

  Car(this.make, this.model) {
    print("Car constructor has been called");
    color = "Blue";
  }

  void displayDetails() {
    print("$make $model is on the road");
  }

  // Private variable
  String _type = "Electric";

  // Getter
  String get type => _type;

  // Setter
  set type(String type) {
    _type = type;
  }

  // Static variable
  static String category = "Vehicle";

  // Static function
  static void showCategory() {
    print("Category: $category");
  }
}

// Immutable classes
class Point {
  final int x;
  final int y;

  const Point(this.x, this.y);
}

// Returning 2 values from a function (records)
(int, String) processName(String name) {
  return (21, name);
}
