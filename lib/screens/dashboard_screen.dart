import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/metrics_overview.dart';
import '../widgets/revenue_chart.dart';
import '../widgets/trends_bar_chart.dart';
import '../widgets/revenue_pie_chart.dart';
import '../widgets/monthly_leads_chart.dart';
import '../widgets/performance_summary.dart';
import '../utils/responsive_helper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context, isMobile),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          await Future.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Welcome Header
            SliverToBoxAdapter(child: _buildWelcomeHeader(context, isMobile)),

            // Metrics Overview
            const MetricsOverview(),

            // Charts Section
            SliverPadding(
              padding: ResponsiveHelper.getScreenPadding(context),
              sliver: SliverToBoxAdapter(
                child: _buildChartsSection(
                  context,
                  isDesktop,
                  isTablet,
                  isMobile,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isMobile ? _buildBottomNav() : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isMobile) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: Text(
        "Sales Dashboard",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
          fontSize: isMobile ? 18 : 20,
        ),
      ),
      actions: [
        if (!isMobile) ...[
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.grey[600]),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Colors.grey[600]),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blue[100],
            child: Text(
              'U',
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ] else ...[
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: Colors.grey[600]),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'notifications',
                child: ListTile(
                  leading: Icon(Icons.notifications_outlined),
                  title: Text('Notifications'),
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings_outlined),
                  title: Text('Settings'),
                ),
              ),
              const PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('Profile'),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, bool isMobile) {
    return Container(
      margin: ResponsiveHelper.getScreenPadding(context),
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[600]!, Colors.blue[800]!],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[200]!.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: isMobile ? _buildMobileWelcome() : _buildDesktopWelcome(),
    );
  }

  Widget _buildMobileWelcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back! 👋',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sales overview',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.dashboard_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopWelcome() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back! 👋',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Here\'s your sales performance overview',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(Icons.dashboard_rounded, color: Colors.white, size: 32),
        ),
      ],
    );
  }

  Widget _buildChartsSection(
    BuildContext context,
    bool isDesktop,
    bool isTablet,
    bool isMobile,
  ) {
    final spacing = ResponsiveHelper.getCardSpacing(context);

    return Column(
      children: [
        SizedBox(height: spacing),

        // Revenue Chart - Always full width
        const RevenueChart(),

        SizedBox(height: spacing),

        // Responsive chart layout
        if (isMobile) ...[
          // Mobile: Stack charts vertically
          const RevenuePieChart(),
          SizedBox(height: spacing),
          const MonthlyLeadsChart(),
          SizedBox(height: spacing),
          const PerformanceSummary(),
          SizedBox(height: spacing),
          const TrendsBarChart(),
        ] else if (isTablet) ...[
          // Tablet: 2 columns
          Row(
            children: [
              Expanded(child: const RevenuePieChart()),
              SizedBox(width: spacing),
              Expanded(child: const MonthlyLeadsChart()),
            ],
          ),
          SizedBox(height: spacing),
          Row(
            children: [
              Expanded(flex: 2, child: const PerformanceSummary()),
              SizedBox(width: spacing),
              Expanded(child: const TrendsBarChart()),
            ],
          ),
        ] else ...[
          // Desktop: Original layout
          Row(
            children: [
              Expanded(
                child: SizedBox(height: 350, child: const RevenuePieChart()),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: SizedBox(height: 350, child: const MonthlyLeadsChart()),
              ),
            ],
          ),
          SizedBox(height: spacing),
          Row(
            children: [
              Expanded(flex: 2, child: const PerformanceSummary()),
              SizedBox(width: spacing),
              Expanded(
                flex: 1,
                child: SizedBox(height: 300, child: const TrendsBarChart()),
              ),
            ],
          ),
        ],

        SizedBox(height: spacing * 2),
      ],
    );
  }

  Widget? _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue[600],
      unselectedItemColor: Colors.grey[500],
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Leads'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
