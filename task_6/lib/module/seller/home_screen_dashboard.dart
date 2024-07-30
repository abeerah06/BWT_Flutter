import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_6/service/logoutScreen.dart';
import 'package:task_6/module/seller/add_item.dart';
import 'package:task_6/module/seller/all_orders.dart';
import 'package:task_6/module/seller/order_screen.dart';
import 'package:task_6/module/seller/store_detail.dart';
import 'package:task_6/module/seller/view_model/home_screen_dashboard_view_model.dart';

class HomeScreenDashboard extends StatefulWidget {
  final User user;
  HomeScreenDashboard(this.user);

  @override
  State<HomeScreenDashboard> createState() => _HomeScreenDashboardState();
}

class _HomeScreenDashboardState extends State<HomeScreenDashboard> {
  late DashboardViewModel viewModel;
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    viewModel = DashboardViewModel(user: widget.user);
    _initialize();
  }

  Future<void> _initialize() async {
    await viewModel.checkStoreStatus();
    _fetchItemsForCategory(_selectedCategoryIndex);
  }

  void _fetchItemsForCategory(int index) {
    viewModel.fetchItems(
      category: index == 0
          ? null
          : index == 1
              ? 'Clothes'
              : index == 2
                  ? 'Jewelry'
                  : 'Shoes',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => viewModel,
      child: Consumer<DashboardViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              foregroundColor: Color.fromRGBO(63, 26, 92, 1),
              title: Text(
                'codeMart',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () async {
                    await viewModel.checkStoreStatus();
                  },
                ),
              ],
              elevation: 0,
              centerTitle: true,
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(63, 26, 92, 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: Text(
                            model.userName != null ? model.userName![0] : '',
                            style: TextStyle(fontSize: 30.0),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          model.userName ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          model.userEmail ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (model.userRole != null)
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text(model.userRole!),
                    ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.store,
                      color: Color.fromRGBO(63, 26, 92, 1),
                    ),
                    title: Text('Your Store',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Color.fromRGBO(63, 26, 92, 1),
                        )),
                    onTap: () async {
                      bool? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StoreDetailScreen(userId: widget.user.uid),
                        ),
                      );
                      if (result == true) {
                        await viewModel.checkStoreStatus();
                      }
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.shopping_bag,
                      color: Color.fromRGBO(63, 26, 92, 1),
                    ),
                    title: Text(
                      'Current Orders',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Color.fromRGBO(63, 26, 92, 1),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrdersScreenSeller()));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.shopping_bag,
                      color: Color.fromRGBO(63, 26, 92, 1),
                    ),
                    title: Text('All Orders',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Color.fromRGBO(63, 26, 92, 1),
                        )),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllOrdersScreenSeller()));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Color.fromRGBO(63, 26, 92, 1),
                    ),
                    title: Text('Logout',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Color.fromRGBO(63, 26, 92, 1),
                        )),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Logoutscreen()));
                    },
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: model.hasStore && model.isStoreVerified
                  ? Color.fromRGBO(63, 26, 92, 1)
                  : Colors.grey,
              foregroundColor: Colors.white,
              onPressed: () {
                if (model.hasStore && model.isStoreVerified) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddItemScreen(
                                storeId: widget.user.uid,
                              )));
                } else if (!model.hasStore) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                      'Set up your store first',
                      style: TextStyle(
                        color: Color.fromRGBO(63, 26, 92, 1),
                      ),
                    )),
                  );
                } else if (!model.isStoreVerified) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Your store is not verified yet',
                            style: TextStyle(
                              color: Color.fromRGBO(63, 26, 92, 1),
                            ))),
                  );
                }
              },
              child: Icon(Icons.add),
            ),
            body: Column(
              children: [
                // SegmentControl placed outside of AppBar
                SegmentControl(
                  selectedIndex: _selectedCategoryIndex,
                  segments: ['All', 'Clothes', 'Jewelry', 'Shoes'],
                  onValueChanged: (index) {
                    setState(() {
                      _selectedCategoryIndex = index;
                      _fetchItemsForCategory(index);
                    });
                  },
                ),
                Expanded(
                  child: _buildItemsGrid(model),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemsGrid(DashboardViewModel model) {
    if (!model.hasStore) {
      return Center(
          child: Text('Store is not created. Please set up your store.',
              style: TextStyle(
                color: Color.fromRGBO(63, 26, 92, 1),
              )));
    }

    if (!model.isStoreVerified) {
      return Center(
          child: Text('Your store is not verified yet.',
              style: TextStyle(
                color: Color.fromRGBO(63, 26, 92, 1),
              )));
    }

    if (model.items.isEmpty) {
      return Center(
          child: Text('No items found.',
              style: TextStyle(
                color: Color.fromRGBO(63, 26, 92, 1),
              )));
    }

    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: model.items.length,
      itemBuilder: (context, index) {
        var item = model.items[index];
        return Card(
          elevation: 5,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.network(
                      item['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      item['productName'],
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Price: \PKR ${item['price']}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              if (item['isAvailable'] == false)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    color: Colors.black54,
                    padding: EdgeInsets.all(4),
                    child: Text(
                      'Not Available',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
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
        SizedBox(
          height: 10,
        ),
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
