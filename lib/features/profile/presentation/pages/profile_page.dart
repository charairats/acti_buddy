import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Handle settings action
              print('Settings tapped');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section (Picture, Name, Bio)
            _buildProfileHeader(context),
            // Tabs for Joined Activities and Reviews
            _buildProfileTabs(context),
          ],
        ),
      ),
    );
  }

  // --- Profile Header Section ---
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
              'https://via.placeholder.com/150/FFFFFF/000000?text=User',
            ), // Placeholder image
            // You can replace with an actual user image
            child: Align(
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: 18,
                child: IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  color: Colors.black,
                  onPressed: () {
                    // Handle change profile picture
                    print('Edit profile picture tapped');
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          // User Name
          const Text(
            'John Doe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8.0),
          // User Bio/Description
          const Text(
            'Passionate explorer of new activities and connecting with people!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 16.0),
          // Follower/Following or Activity Count (optional)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatColumn('Activities', '12'),
              const SizedBox(width: 24),
              _buildStatColumn('Reviews', '8'),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ],
    );
  }

  // --- Profile Tabs Section ---
  Widget _buildProfileTabs(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Column(
        children: [
          // Tab Bar
          TabBar(
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: const [
              Tab(text: 'Joined Activities', icon: Icon(Icons.event)),
              Tab(text: 'Latest Reviews', icon: Icon(Icons.star)),
            ],
          ),
          // Tab Bar View (Content for each tab)
          SizedBox(
            height:
                MediaQuery.of(context).size.height *
                0.6, // Adjust height as needed
            child: TabBarView(
              children: [
                // Content for "Joined Activities" tab
                _buildJoinedActivitiesTab(),
                // Content for "Latest Reviews" tab
                _buildLatestReviewsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Joined Activities Tab Content ---
  Widget _buildJoinedActivitiesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 5, // Example count
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Activity Title ${index + 1}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Description of the activity ${index + 1}.',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: const [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('2023-11-20'),
                    SizedBox(width: 16),
                    Icon(Icons.location_on, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('Location A'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Latest Reviews Tab Content ---
  Widget _buildLatestReviewsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 3, // Example count
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        'https://via.placeholder.com/50/CCCCCC/000000?text=R',
                      ), // Reviewer image
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reviewer Name ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              starIndex < (5 - index)
                                  ? Icons.star
                                  : Icons.star_border, // Example: 5, 4, 3 stars
                              color: Colors.amber,
                              size: 18,
                            );
                          }),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      '2 days ago', // Example date
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'This was a fantastic activity! I really enjoyed the experience and met great people. Highly recommended!',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
