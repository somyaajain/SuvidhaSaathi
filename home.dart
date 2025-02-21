import 'package:flutter/material.dart';
import 'sos_page.dart'; // Import the SOS Page
import 'package:suvidha_saathi/medicine_reminder.dart';

class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo Section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/logo.png'), // Add image in assets folder
                ),
              ),

              // Welcome Text
              Text(
                'Welcome to Suvidha Saathi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Making life easier for you',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              SizedBox(height: 30),

              // 2x3 Button Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2, // 2 buttons per row
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 1.2, // Adjusts the button height
                  children: [
                    // 🚀 SOS Button with Navigation
                    _buildFeatureButton(
                      context,
                      'SOS',
                      Colors.red,
                      Icons.warning_rounded,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SOSPage()),
                        );
                      },
                    ),

                    // Medicine Reminder Button
                    _buildFeatureButton(
                      context,
                      'Medicine',
                      Colors.green,
                      Icons.medical_services,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MedicineReminder()),
                        );
                      },
                    ),

                    // Games Button
                    _buildFeatureButton(
                      context,
                      'Games',
                      Colors.blue,
                      Icons.videogame_asset,
                          () {
                        // Navigate to Games Screen
                      },
                    ),

                    // Voice Assistant Button
                    _buildFeatureButton(
                      context,
                      'Voice',
                      Colors.orange,
                      Icons.mic,
                          () {
                        // Navigate to Voice Assistant Screen
                      },
                    ),

                    // Music Player Button
                    _buildFeatureButton(
                      context,
                      'Music',
                      Colors.purple,
                      Icons.music_note,
                          () {
                        // Navigate to Music Player
                      },
                    ),

                    // Photo Sharing Button
                    _buildFeatureButton(
                      context,
                      'Photos',
                      Colors.yellow.shade700,
                      Icons.photo,
                          () {
                        // Navigate to Photo Sharing Chat
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureButton(
      BuildContext context,
      String title,
      Color color,
      IconData icon,
      VoidCallback onPressed,
      ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: Colors.white,
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
