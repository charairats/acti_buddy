import 'package:flutter/material.dart';

class SearchActivityPage extends StatefulWidget {
  const SearchActivityPage({super.key});

  @override
  State<SearchActivityPage> createState() => _SearchActivityPageState();
}

class _SearchActivityPageState extends State<SearchActivityPage> {
  // Use to store selected category
  String _selectedCategory = 'All';

  // Use to store selected date
  DateTime _selectedDate = DateTime.now();

  // Handle category filtering logic
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      // In a real app, you would fetch new data here
      print('Selected category: $_selectedCategory');
    });
  }

  // Handle date filtering logic
  Future<void> _onDateSelected() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // In a real app, you would fetch new data here
        print('Selected date: $_selectedDate');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Activity'),
        actions: [
          // 'Create Activity' button on the app bar
          TextButton(
            onPressed: () {
              // Navigate to the create activity page
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const CreateActivityPage()),
              // );
            },
            child: const Text(
              'Create Activity',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search input and filter section
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Search for activities...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),

              // Filter by category
              const Text(
                'Filter by Category',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                children: ['All', 'Sports', 'Music', 'Art', 'Gaming', 'Travel']
                    .map((category) {
                      return ChoiceChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          _onCategorySelected(category);
                        },
                      );
                    })
                    .toList(),
              ),
              const SizedBox(height: 16.0),

              // Filter by date
              Row(
                children: [
                  const Text(
                    'Filter by Date:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8.0),
                  TextButton.icon(
                    onPressed: _onDateSelected,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Search for nearby activities section
              const Text(
                'Activities Near You (within 10km)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // In a real app, you would fetch activities based on user's location
              // Use a placeholder for now
              const SizedBox(height: 8.0),
              // Use a list view or other widget to display nearby activities
              Container(
                height: 200, // Example height for a list of nearby activities
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Center(
                  child: Text('Placeholder for nearby activity list'),
                ),
              ),

              const SizedBox(height: 24.0),

              // Activity list section
              const Text(
                'All Activities',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // Placeholder for the main activity list
              const SizedBox(height: 8.0),
              // Use a ListView.builder for better performance with dynamic data
              ListView.builder(
                shrinkWrap: true, // Use this with SingleChildScrollView
                physics:
                    const NeverScrollableScrollPhysics(), // To disable inner scrolling
                itemCount: 5, // Example item count
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text('Activity ${index + 1}'),
                      subtitle: const Text('Description of the activity...'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
