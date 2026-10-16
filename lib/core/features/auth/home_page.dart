import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/core/providers/home_provider.dart';
import 'package:flutter_application_1/main.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _logout() async {
    final auth = context.read<AuthProvider>();

    final success = await auth.signOut();

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            auth.errorMessage ?? 'Unable to log out. Please try again.',
          ),
        ),
      );
    }

    // On success, WrapperScreen displays SignInPage automatically.
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    final String userName = user?.displayName ?? 'Lumen User';
    final String userEmail = user?.email ?? 'No email available';
    final DateTime? createdAt = user?.metadata.creationTime;
    final DateTime? lastLogin = user?.metadata.lastSignInTime;
    final bool isEmailVerified = user?.emailVerified ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 28),
          children: [
            _header(),

            const SizedBox(height: 10),

            _ProfileCard(
              user: user,
              userName: userName,
              userEmail: userEmail,
              createdAt: createdAt,
              lastLogin: lastLogin,
              isEmailVerified: isEmailVerified,
            ),

            const SizedBox(height: 26),

            const _SectionHeader(
              title: 'Account details',
              trailing: 'user object',
            ),

            const SizedBox(height: 12),

            _DetailTile(
              icon: Icons.fingerprint,
              iconColor: AppColors.coral,
              iconBg: const Color(0xFFFBE7D2),
              label: 'USER ID',
              value: user?.uid ?? 'Not signed in',
            ),

            _DetailTile(
              icon: Icons.mail_outline_rounded,
              iconColor: AppColors.muted,
              iconBg: AppColors.cream,
              label: 'EMAIL',
              value: userEmail,
            ),

            _DetailTile(
              icon: Icons.person_outline_rounded,
              iconColor: const Color(0xFFD8A418),
              iconBg: const Color(0xFFFAF2D3),
              label: 'DISPLAY NAME',
              value: userName,
            ),

            _DetailTile(
              icon: Icons.calendar_today_outlined,
              iconColor: AppColors.muted,
              iconBg: AppColors.cream,
              label: 'CREATED AT',
              value: _formatDate(createdAt),
            ),

            _DetailTile(
              icon: Icons.verified_user_outlined,
              iconColor: isEmailVerified ? AppColors.green : AppColors.muted,
              iconBg: AppColors.cream,
              label: 'EMAIL VERIFIED',
              value: isEmailVerified ? 'Yes' : 'No',
            ),

            _DetailTile(
              icon: Icons.lock_outline_rounded,
              iconColor: AppColors.green,
              iconBg: AppColors.cream,
              label: 'PASSWORD',
              value: 'Protected',
            ),

            const SizedBox(height: 24),

            const _SectionHeader(
              title: 'Session',
              trailing: 'account activity',
            ),

            const SizedBox(height: 12),

            _SessionTile(
              icon: Icons.smartphone_rounded,
              device: 'Current account',
              meta: 'Last login: ${_formatDate(lastLogin)}',
              isLive: user != null,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  String getUserName(User? user) {
    final String? displayName = user?.displayName?.trim();

    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    // If no display name is saved, use the part before @ in the email.
    final String? email = user?.email;

    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }

    return 'Lumen User';
  }

  // ------------------------------ Header ------------------------------

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: const BoxDecoration(
              color: AppColors.coral,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.flare, color: Colors.white, size: 22),
          ),

          const SizedBox(width: 10),

          const Text(
            'Lumen',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: AppColors.dark,
            ),
          ),

          const Spacer(),

          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.line),
            ),
            child: IconButton(
              onPressed: _logout,
              tooltip: 'Logout',
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.logout_rounded,
                size: 21,
                color: AppColors.dark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------- Bottom navigation ----------------------------

  Widget _bottomNav() {
    const List<IconData> icons = [
      Icons.home_rounded,
      Icons.donut_large_rounded,
      Icons.credit_card_rounded,
      Icons.person_rounded,
    ];

    const List<String> labels = ['Home', 'Activity', 'Cards', 'Profile'];

    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(top: BorderSide(color: AppColors.line)),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 66,
              child: Row(
                children: List.generate(labels.length, (index) {
                  final bool selected = index == homeProvider.navIndex;

                  final Color color = selected
                      ? AppColors.coral
                      : AppColors.muted;

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        context.read<HomeProvider>().changeTab(index);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icons[index], size: 24, color: color),
                          const SizedBox(height: 4),
                          Text(
                            labels[index],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// Profile card
// -----------------------------------------------------------------------------

class _ProfileCard extends StatelessWidget {
  final User? user;
  final String userName;
  final String userEmail;
  final DateTime? createdAt;
  final DateTime? lastLogin;
  final bool isEmailVerified;

  const _ProfileCard({
    required this.user,
    required this.userName,
    required this.userEmail,
    required this.createdAt,
    required this.lastLogin,
    required this.isEmailVerified,
  });

  String _getInitials(String name) {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return 'LU';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first.substring(0, 1)}'
            '${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.green, AppColors.green],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x592F3A20),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar and user information.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.coral,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x73E96D0F),
                      blurRadius: 14,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  _getInitials(userName),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SIGNED IN AS',
                      style: TextStyle(
                        color: AppColors.cream,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Georgia',
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      userEmail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.cream,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Email verification status.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0x47000000),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isEmailVerified
                      ? Icons.verified_outlined
                      : Icons.info_outline_rounded,
                  size: 14,
                  color: AppColors.cream,
                ),

                const SizedBox(width: 6),

                Text(
                  isEmailVerified ? 'Email verified' : 'Email not verified',
                  style: const TextStyle(
                    color: AppColors.cream,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Container(height: 1, color: const Color(0x24FFFFFF)),

          const SizedBox(height: 14),

          // Account statistics.
          Row(
            children: [
              const Expanded(
                child: _Stat(value: 'Protected', label: 'PASSWORD'),
              ),

              _verticalDivider(),

              Expanded(
                child: _Stat(
                  value: _formatShortDate(createdAt),
                  label: 'JOINED',
                ),
              ),

              _verticalDivider(),

              Expanded(
                child: _Stat(
                  value: _formatShortDate(lastLogin),
                  label: 'LAST LOGIN',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 28,
      color: const Color(0x24FFFFFF),
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

// -----------------------------------------------------------------------------
// Statistics
// -----------------------------------------------------------------------------

class _Stat extends StatelessWidget {
  final String value;
  final String label;

  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          label,
          style: const TextStyle(
            color: AppColors.cream,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Section header
// -----------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;
  final String trailing;

  const _SectionHeader({required this.title, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
              color: AppColors.dark,
            ),
          ),

          const Spacer(),

          Text(
            trailing,
            style: const TextStyle(fontSize: 11.5, color: AppColors.dark),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Account detail tile
// -----------------------------------------------------------------------------

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;

  const _DetailTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 5, 16, 5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                    color: AppColors.dark,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.dark,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: Color(0xFFC6C2B2),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Session tile
// -----------------------------------------------------------------------------

class _SessionTile extends StatelessWidget {
  final IconData icon;
  final String device;
  final String meta;
  final bool isLive;

  const _SessionTile({
    required this.icon,
    required this.device,
    required this.meta,
    this.isLive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 5, 16, 5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 18, color: AppColors.green),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.dark,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  meta,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),

          if (isLive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 7, color: AppColors.green),

                  SizedBox(width: 4),

                  Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Date formatting helpers
// -----------------------------------------------------------------------------

String _formatDate(DateTime? date) {
  if (date == null) {
    return 'Not available';
  }

  final DateTime localDate = date.toLocal();

  String twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }

  return '${twoDigits(localDate.day)} '
      '${_monthName(localDate.month)} '
      '${localDate.year}, '
      '${twoDigits(localDate.hour)}:'
      '${twoDigits(localDate.minute)}';
}

String _formatShortDate(DateTime? date) {
  if (date == null) {
    return 'N/A';
  }

  final DateTime localDate = date.toLocal();

  return '${localDate.day} ${_monthName(localDate.month)}';
}

String _monthName(int month) {
  const List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return months[month - 1];
}
