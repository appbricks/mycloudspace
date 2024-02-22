import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:service_integration_tests/screens/identity_service_page.dart';

class TestListView extends StatelessWidget {
  const TestListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Expanded(
              child: SizedBox(),
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Image.asset(
                'assets/test-app-icon.png',
                height: 150,
                fit: BoxFit.fitHeight,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Text('Select an Integration Test to Continue',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                context.goNamed(IdentityServicePage.name);
              },
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: const Text(
                'Identity Service',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: null,
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: const Text(
                'User Space Service',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: null,
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: const Text(
                'User App Service',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: null,
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: const Text(
                'User Device Service',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            const Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
