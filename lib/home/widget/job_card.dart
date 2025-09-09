import 'package:flutter/material.dart';
import 'package:karirku_application/home/model/job_card_model.dart';

class JobCard extends StatefulWidget {
  const JobCard({super.key, required this.job});

  @override
  State<JobCard> createState() => _JobCardState();

  final JobCardModel job;
}

class _JobCardState extends State<JobCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(widget.job.companyLogo, width: 45, height: 45),
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.job.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0070CE),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.job.company,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: const [
              BuildChip(
                text: "Hybrid",
                bgColor: Color(0xFFE0F0FF),
                textColor: Color(0xFF0070CE),
              ),
              SizedBox(width: 8),
              BuildChip(
                text: "Full Time",
                bgColor: Color(0xFFE0F0FF),
                textColor: Color(0xFF0070CE),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BuildChip extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;

  const BuildChip({
    super.key,
    required this.text,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xFFE0F0FF),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
