import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_6/service/logoutScreen.dart';
import 'package:task_6/module/buyer/cartScreen.dart';
import 'package:task_6/module/buyer/orderScreen.dart';
import 'package:task_6/module/buyer/productDetail.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  HomeScreen(this.user);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> items = [];
  late String userName;

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _fetchUserName();
  }

  Future<void> _fetchItems() async {
    String? category;
    if (_selectedIndex == 0) {
      category = null; // All items
    } else if (_selectedIndex == 1) {
      category = 'Clothes';
    } else if (_selectedIndex == 2) {
      category = 'Jewelry';
    } else if (_selectedIndex == 3) {
      category = 'Shoes';
    }

    try {
      QuerySnapshot itemsSnapshot;
      if (category == null) {
        itemsSnapshot =
            await FirebaseFirestore.instance.collection('items').get();
      } else {
        itemsSnapshot = await FirebaseFirestore.instance
            .collection('items')
            .where('category', isEqualTo: category)
            .get();
      }

      setState(() {
        items = itemsSnapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList();
      });
    } catch (e) {
      print('Error fetching items: $e');
    }
  }

  Future<void> _fetchUserName() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc.get('name');
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Color.fromRGBO(63, 26, 92, 1),
        title: Text(
          'Discover',
          style: GoogleFonts.inter(
            color: Color.fromRGBO(63, 26, 92, 1),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Color.fromRGBO(63, 26, 92, 1),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              color: Colors.white,
              elevation: 3.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    icon: Icon(Icons.search,
                        color: Color.fromRGBO(63, 26, 92, 1)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(63, 26, 92, 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Text(
                      userName[0].toUpperCase(),
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    widget.user.email ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.shopping_bag,
                color: Color.fromRGBO(63, 26, 92, 1),
              ),
              title: Text('My Orders'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OrdersScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout_rounded,
                color: Color.fromRGBO(63, 26, 92, 1),
              ),
              title: Text('Log Out'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Logoutscreen()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
                SegmentControl(
                  selectedIndex: _selectedIndex,
                  segments: ['All', 'Clothes', 'Jewelry', 'Shoes'],
                  onValueChanged: _onItemTapped,
                ),
              ],
            ),
          ),
          Expanded(child: _buildItemsGrid()),
        ],
      ),
    );
  }

  Widget _buildItemsGrid() {
    List<Map<String, dynamic>> filteredItems;
    if (_selectedIndex == 0) {
      filteredItems = items;
    } else if (_selectedIndex == 1) {
      filteredItems =
          items.where((item) => item['category'] == 'Clothes').toList();
    } else if (_selectedIndex == 2) {
      filteredItems =
          items.where((item) => item['category'] == 'Jewelry').toList();
    } else {
      filteredItems =
          items.where((item) => item['category'] == 'Shoes').toList();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    productId: item['id'],
                  ),
                ),
              );
            },
            child: Card(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Image.network(
                            item['imageUrls'][0],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      item['name'],
                      style: GoogleFonts.inter(
                        color: Color.fromRGBO(63, 26, 92, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '\PKR ${item['price'].toString()}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SegmentControl extends StatelessWidget {
  final int selectedIndex;
  final List<String> segments;
  final ValueChanged<int> onValueChanged;

  SegmentControl({
    required this.selectedIndex,
    required this.segments,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(2, (index) {
            return GestureDetector(
              onTap: () => onValueChanged(index),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: selectedIndex == index
                      ? Color.fromRGBO(63, 26, 92, 1)
                      : Colors.grey[200],
                ),
                width: 160,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    segments[index],
                    style: TextStyle(
                      color: selectedIndex == index
                          ? Colors.white
                          : Color.fromRGBO(63, 26, 92, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(2, (index) {
            final segmentIndex = index + 2;
            return GestureDetector(
              onTap: () => onValueChanged(segmentIndex),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: selectedIndex == segmentIndex
                      ? Color.fromRGBO(63, 26, 92, 1)
                      : Colors.grey[200],
                ),
                width: 160,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    segments[segmentIndex],
                    style: TextStyle(
                      color: selectedIndex == segmentIndex
                          ? Colors.white
                          : Color.fromRGBO(63, 26, 92, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
