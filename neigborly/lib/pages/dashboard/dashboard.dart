import 'package:flutter/material.dart';
import 'package:neigborly/main.dart';
import 'package:neigborly/pages/communication/recent_convo.dart';
import 'package:neigborly/pages/dashboard/events.dart';
import 'package:neigborly/pages/dashboard/profile.dart';
import 'package:neigborly/pages/dashboard/settings.dart';
import 'package:neigborly/pages/dashboard/submit_ticket.dart';
import 'package:neigborly/pages/dashboard/tasks.dart';

class Dashboard extends StatefulWidget {
  final Map userdata;

  const Dashboard({Key? key, required this.userdata}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Color.fromARGB(255, 104, 220, 78),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 104, 220, 78),
              ),
              child: Text(
                ' ${widget.userdata["first_name"]} ${widget.userdata["family_name"]}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_2_outlined),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ListTile(
  leading: Icon(Icons.live_help), 
  title: Text('Request Ticket for Concern'),
  onTap: () {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketRequestPage(userEmail: widget.userdata['email']),
      ),
    );
  },
),


            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Text(
             'Hello! ${widget.userdata["first_name"]} ${widget.userdata["family_name"]}',

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(child: _buildBigCard1()),
                SizedBox(width: 16.0),
                Expanded(child: _buildBigCard2()),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                children: [
                  _buildOutlinedCard(Icons.assignment_outlined, 'Tasks',
                      Color.fromARGB(255, 0, 100, 0), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TasksPage()),
                    );
                  }),
                  _buildOutlinedCard(Icons.event_outlined, 'Events',
                      Color.fromARGB(255, 0, 100, 0), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EventsPage()),
                    );
                  }),
                  _buildOutlinedCard(Icons.settings_outlined, 'Settings',
                      Color.fromARGB(255, 0, 100, 0), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  }),
                  _buildOutlinedCard(Icons.event_outlined, 'Events',
                      Color.fromARGB(255, 0, 100, 0), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EventsPage()),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60.0,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.person_outline, size: 30.0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                color: Color.fromARGB(255, 0, 100, 0),
              ),
              IconButton(
                icon: Icon(Icons.message_outlined, size: 30.0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecentConvoPage(userdata: widget.userdata)),
                  );
                },
                color: Color.fromARGB(255, 0, 100, 0),
              ),
              IconButton(
                icon: Icon(Icons.swap_horiz_outlined, size: 30.0),
                onPressed: () {},
                color: Color.fromARGB(255, 0, 100, 0),
              ),
              IconButton(
                icon: Icon(Icons.settings_outlined, size: 30.0),
                onPressed: () {},
                color: Color.fromARGB(255, 0, 100, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedCard(
      IconData icon, String label, Color outlineColor, VoidCallback onTap) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 40.0,
                color: outlineColor,
              ),
              SizedBox(height: 8.0),
              Text(
                label,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, Color color) {
    return Card(
      elevation: 0.0,
      color: color,
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 35.0,
                color: Colors.white,
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBigCard1() {
    return Card(
      elevation: 0.0,
      color: Color.fromARGB(255, 39, 174, 96),
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          width: double.infinity,
          height: 200.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_outlined,
                size: 40.0,
                color: Colors.white,
              ),
              SizedBox(height: 8),
              Text(
                'text 1',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBigCard2() {
    return Card(
      elevation: 0.0,
      color: Color.fromARGB(255, 39, 174, 96),
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          width: double.infinity,
          height: 200.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.settings_outlined,
                size: 40.0,
                color: Colors.white,
              ),
              SizedBox(height: 8),
              Text(
                'text 2',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
