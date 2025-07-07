import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loopedin/features/auth/cubit/auth_cubit.dart';
import 'package:loopedin/common/custom_loading_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
  bool _isLoadingConnections = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [_buildHeader(), _buildSearchBar(), _buildContent()],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Loopin',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is Authenticated) {
                    return Text(
                      'Welcome back, ${state.user.name}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    );
                  }
                  return const Text(
                    'Welcome back',
                    style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                  );
                },
              ),
            ],
          ),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'signout') {
                      _showSignOutDialog(context);
                    }
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF007AFF),
                    child: Text(
                      state.user.name.isNotEmpty
                          ? state.user.name[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'signout',
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Color(0xFF666666)),
                          SizedBox(width: 8),
                          Text('Sign Out'),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF007AFF),
                child: Icon(Icons.person, color: Colors.white),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthCubit>().signOut();
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFF666666)),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search professionals, companies...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Color(0xFF999999)),
              ),
            ),
          ),
          const Icon(Icons.filter_list, color: Color(0xFF666666)),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_selectedIndex == 3) {
      // Profile tab selected
      return _buildProfileContent();
    }

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Recommended Connections'),
            const SizedBox(height: 16),
            _buildUserCards(),
            const SizedBox(height: 32),
            _buildSectionTitle('Recent Activity'),
            const SizedBox(height: 16),
            _buildActivityList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return Column(
                    children: [
                      // Profile Avatar
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xFF007AFF),
                          child: Text(
                            state.user.name.isNotEmpty
                                ? state.user.name[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // User Name
                      Center(
                        child: Text(
                          state.user.name.isNotEmpty ? state.user.name : 'User',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // User Email
                      Center(
                        child: Text(
                          state.user.id, // Using ID as email placeholder
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Profile Options
                      _buildProfileOption(
                        icon: Icons.edit,
                        title: 'Edit Profile',
                        onTap: () {
                          // TODO: Navigate to edit profile page
                        },
                      ),
                      _buildProfileOption(
                        icon: Icons.settings,
                        title: 'Settings',
                        onTap: () {
                          // TODO: Navigate to settings page
                        },
                      ),
                      _buildProfileOption(
                        icon: Icons.help,
                        title: 'Help & Support',
                        onTap: () {
                          // TODO: Navigate to help page
                        },
                      ),
                      const SizedBox(height: 20),

                      // Sign Out Button
                      Container(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showSignOutDialog(context);
                          },
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: const Text(
                            'Sign Out',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const Center(child: Text('Not authenticated'));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF007AFF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF007AFF), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A1A),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF999999),
          size: 16,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Colors.white,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _buildUserCards() {
    if (_isLoadingConnections) {
      return const SizedBox(
        height: 180,
        child: Center(
          child: CustomLoadingWidget(
            size: 60,
            message: 'Loading connections...',
          ),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, index) {
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF).withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: const Color(0xFF007AFF),
                      child: Text(
                        String.fromCharCode(65 + index),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(
                        'Professional ${index + 1}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Software Engineer',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF666666),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: double.infinity,
                        height: 28,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isLoadingConnections = true;
                            });
                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() {
                                _isLoadingConnections = false;
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007AFF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            'Connect',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActivityList() {
    return Column(
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF007AFF).withOpacity(0.1),
                child: Icon(
                  index == 0 ? Icons.person_add : Icons.message,
                  color: const Color(0xFF007AFF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      index == 0
                          ? 'New connection request'
                          : 'New message received',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      index == 0
                          ? 'John Doe wants to connect with you'
                          : 'Sarah Wilson sent you a message',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '2m ago',
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF007AFF),
        unselectedItemColor: const Color(0xFF999999),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Network'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
