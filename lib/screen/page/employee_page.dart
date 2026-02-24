import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:record_assist/screen/page/login_page.dart';
import 'package:record_assist/screen/widget/add_employee_dialog.dart';
import 'package:record_assist/screen/widget/employee_card.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedOrganizationId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  void _showAddEmployeeDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddEmployeeDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by Name, ID, or Position',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
            const SizedBox(height: 12),

            // Organizations Stream Builder to provide orgName mapping
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('organizations')
                    .snapshots(),
                builder: (context, orgSnapshot) {
                  if (orgSnapshot.hasError) {
                    return const Text('Error loading organizations');
                  }

                  if (orgSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final organizations = orgSnapshot.data?.docs ?? [];
                  final Map<String, String> orgMap = {};
                  for (var org in organizations) {
                    final data = org.data() as Map<String, dynamic>;
                    orgMap[org.id] = data['name'] ?? 'Unknown';
                  }

                  return Column(
                    children: [
                      // Organization Filter
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedOrganizationId,
                          decoration: InputDecoration(
                            hintText: 'Filter by Organization',
                            prefixIcon:
                                const Icon(Icons.business, color: Colors.grey),
                            suffixIcon: _selectedOrganizationId != null
                                ? IconButton(
                                    icon: const Icon(Icons.clear,
                                        color: Colors.grey),
                                    onPressed: () {
                                      setState(() {
                                        _selectedOrganizationId = null;
                                      });
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                          ),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('All Organizations'),
                            ),
                            ...organizations.map((org) {
                              return DropdownMenuItem<String>(
                                value: org.id,
                                child: Text(orgMap[org.id] ?? 'Unknown'),
                              );
                            }).toList(),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedOrganizationId = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Employee Table
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('employees')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            final docs = snapshot.data?.docs ?? [];

                            // Client-side filtering
                            final filteredDocs = docs.where((doc) {
                              final data = doc.data() as Map<String, dynamic>;

                              // Organization filter
                              if (_selectedOrganizationId != null) {
                                final employeeOrgId =
                                    data['org_id']?.toString() ?? '';
                                if (employeeOrgId != _selectedOrganizationId) {
                                  return false;
                                }
                              }

                              // Search filter
                              if (_searchQuery.isEmpty) return true;

                              final employeeId = (data['employee_id'] ?? '')
                                  .toString()
                                  .toLowerCase();
                              final id = doc.id.toLowerCase();
                              final firstName = (data['first_name'] ?? '')
                                  .toString()
                                  .toLowerCase();
                              final lastName = (data['last_name'] ?? '')
                                  .toString()
                                  .toLowerCase();
                              final position = (data['position'] ?? '')
                                  .toString()
                                  .toLowerCase();

                              return employeeId.contains(_searchQuery) ||
                                  id.contains(_searchQuery) ||
                                  firstName.contains(_searchQuery) ||
                                  lastName.contains(_searchQuery) ||
                                  position.contains(_searchQuery);
                            }).toList();

                            if (filteredDocs.isEmpty) {
                              return const Center(
                                  child: Text('No employees found.'));
                            }

                            // Employee Cards List
                            return ListView.builder(
                              itemCount: filteredDocs.length,
                              itemBuilder: (context, index) {
                                final doc = filteredDocs[index];
                                final data = doc.data() as Map<String, dynamic>;
                                final employeeId = data['employee_id'] ?? '';
                                final firstName = data['first_name'] ?? '';
                                final lastName = data['last_name'] ?? '';
                                final position = data['position'] ?? '';
                                final employeeOrgId =
                                    data['org_id']?.toString() ?? '';

                                return EmployeeCard(
                                  doc: doc,
                                  data: data,
                                  employeeId: employeeId,
                                  firstName: firstName,
                                  lastName: lastName,
                                  position: position,
                                  organizationName:
                                      orgMap[employeeOrgId] ?? 'Not Assigned',
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddEmployeeDialog,
        tooltip: 'Add Employee',
        icon: const Icon(Icons.person_add),
        label: const Text('Add Employee'),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
