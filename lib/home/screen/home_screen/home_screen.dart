import 'package:flutter/material.dart';
import 'package:karirku_application/home/model/featurad_card_model.dart';
import 'package:karirku_application/home/model/job_card_model.dart';
import 'package:karirku_application/home/widget/job_card.dart';
// import 'package:karirku_application/home/model/job_card_model.dart';
import 'package:karirku_application/preferences/CustomIcon_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.name});

  final String? name;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final List<JobCardModel> jobList = [
  JobCardModel(
    title: "Merchandise Designer",
    company: "MLB",
    companyLogo: "assets/images/mlb.png",
    workType: 'Full Time',
    employmentType: 'Onsite',
    salary: '\$80,000 - \$100,000',
  ),
  JobCardModel(
    title: "Company Website Designer",
    company: "NBA",
    companyLogo: "assets/images/nba.png",
    workType: 'Part Time',
    employmentType: 'Remote',
    salary: '\$60,000 - \$80,000',
  ),
];

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          // Header dengan Row untuk ikon dan logo
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.settings,
                  size: 24.0,
                  color: Color(0xff0070CE),
                ),
                SizedBox(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 300,
                    height: 100,
                  ),
                ),
                const Icon(
                  Icons.notifications,
                  size: 24.0,
                  color: Color(0xFF0070CE),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi ${widget.name ?? ''}', // 🔥 pake widget.name
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      'Find Your Jobs',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF27214D),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              suffixIcon: Icon(Icons.equalizer),
              hintText: 'Search for jobs...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF27214D),
                  width: 1,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0070CE), Color(0xFF00BFFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(CustomIcon.vector1, color: Color(0xffffffff)),
                        SizedBox(height: 4),
                        Text(
                          'total jobs',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '8,597',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Divider(color: Colors.white, thickness: 1),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    GestureDetector(
                      onTap: () {
                        // Aksi ketika diklik
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Detail jobs dibuka!")),
                        );
                      },
                      child: const Text(
                        "Lihat Detail",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[200],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FeatureCard(icon: Icons.work, title: 'Job Listings'),
                FeatureCard(icon: Icons.business, title: 'Companies'),
                FeatureCard(icon: Icons.person, title: 'Candidates'),
              ],
            ),
          ),

          SizedBox(height: 12),

          // 🔥 Tambahin job list
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Recommended Jobs",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF27214D),
                ),
              ),
              const SizedBox(height: 8),

              // List JobCard
              ...jobList.map((job) => JobCard(job: job)).toList(),
            ],
          ),
        ],
      ),
    );
  }
}
