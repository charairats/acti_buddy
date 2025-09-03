import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: DefaultTabController(
        length: 3, // Number of tabs
        child: Column(
          children: [
            // Tab Bar
            const TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(text: 'Joined'),
                Tab(text: 'Upcoming'),
                Tab(text: 'Past'),
              ],
            ),
            // Tab Bar View (Content for each tab)
            Expanded(
              child: TabBarView(
                children: [
                  // Content for 'Joined' tab
                  _buildJoinedActivitiesTab(),
                  // Content for 'Upcoming' tab
                  _buildUpcomingActivitiesTab(),
                  // Content for 'Past' tab
                  _buildPastActivitiesTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Joined Activities Tab Content (placeholder) ---
  Widget _buildJoinedActivitiesTab() {
    // This section will list activities the user has joined.
    // In a real app, this data would come from a server.
    List<String> joinedActivities = [
      'Joined Hiking Trip',
      'Joined Music Concert',
      'Joined Yoga Session',
    ];

    return ListView.builder(
      itemCount: joinedActivities.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            leading: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
            title: Text(joinedActivities[index]),
            subtitle: const Text('You have successfully joined this activity.'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to activity details page
            },
          ),
        );
      },
    );
  }

  // --- Upcoming Activities Tab Content (placeholder) ---
  Widget _buildUpcomingActivitiesTab() {
    // This section will show activities scheduled in the near future.
    List<Map<String, String>> upcomingActivities = [
      {'name': 'Team Building Workshop', 'date': 'Tomorrow, 10:00 AM'},
      {'name': 'City Marathon', 'date': 'This Saturday, 7:00 AM'},
      {'name': 'Board Game Night', 'date': 'Next Monday, 8:00 PM'},
    ];

    return ListView.builder(
      itemCount: upcomingActivities.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            leading: const Icon(Icons.access_time, color: Colors.blue),
            title: Text(upcomingActivities[index]['name']!),
            subtitle: Text('Date: ${upcomingActivities[index]['date']}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to activity details page
            },
          ),
        );
      },
    );
  }

  // --- Past Activities Tab Content (to review) ---
  Widget _buildPastActivitiesTab(BuildContext context) {
    // This section will list completed activities for which the user can leave a review.
    List<String> pastActivities = [
      'Community Cleanup',
      'Photography Class',
      'Cooking Class',
    ];

    return ListView.builder(
      itemCount: pastActivities.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          elevation: 2,
          child: ListTile(
            leading: const Icon(Icons.star_rate, color: Colors.orange),
            title: Text(pastActivities[index]),
            subtitle: const Text(
              'Please rate this activity and leave a review.',
            ),
            trailing: ElevatedButton(
              onPressed: () {
                // Navigate to the review page or show a review dialog
                _showReviewDialog(context, pastActivities[index]);
              },
              child: const Text('Review'),
            ),
            onTap: () {
              // Navigate to activity details page
            },
          ),
        );
      },
    );
  }

  // A simple dialog for leaving a review
  void _showReviewDialog(BuildContext context, String activityName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Review "$activityName"'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('How was your experience?'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return const Icon(Icons.star, color: Colors.amber);
                  }),
                ),
                const SizedBox(height: 16),
                const TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Write your review here...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                // Handle review submission logic here
                print('Review submitted for: $activityName');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
