import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color.fromARGB(255, 104, 220, 78),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('images/logo.jpg'),
              ),
              SizedBox(height: 16),
              Text(
                'Paulo Castro',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'paulo@gmail.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 24),
              Divider(
                height: 32,
                thickness: 1,
                color: Colors.grey[300],
              ),
              SizedBox(height: 8),
              _buildProfileItem(
                  Icons.phone_callback_outlined, 'Phone', '09125478412'),
              _buildProfileItem(
                  Icons.location_on_outlined, 'Address', '123 Rainbow village'),
              _buildProfileItem(Icons.confirmation_num_outlined,
                  'Registration number', '20-0523'),
              _buildProfileItem(Icons.phone_outlined, 'Landline', '20-0523'),
              _buildProfileItem(Icons.facebook, 'FB name', 'Facebook Name'),
              _buildProfileItem(
                  Icons.school_outlined, 'Education', 'Your Education Details'),
              _buildProfileItem(Icons.date_range_outlined, 'Date Created',
                  'Your Date Created Details'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: Color.fromARGB(255, 104, 220, 78),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
