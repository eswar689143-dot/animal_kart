import 'package:animal_kart_demo2/l10n/app_localizations.dart';
import 'package:animal_kart_demo2/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';

class TrackerScreen extends StatefulWidget {
  final String buffaloType;
  final int unitCount;
  final String purchaseDate;
  final int buffaloCount;
  final int calfCount;
  final int totalUnitcost;


  const TrackerScreen({super.key,
  required this.buffaloType,
  required this.unitCount,
  required this.purchaseDate,
  required this.buffaloCount,
  required this.calfCount,
  required this.totalUnitcost
  });

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  final int _currentStep = 2; // Index for "Received at Quarantine"
  final List<TrackerStep> _steps = [];

  @override
  void initState() {
    super.initState();
    _initializeSteps();
  }

  void _initializeSteps() {
    _steps.addAll([
      TrackerStep(
        title: 'Purchase Confirmed',
        description: 'Murrah Buffalo (1 unit) purchased',
        date: 'Jan 15, 2024',
        status: StepStatus.completed,
        icon: Icons.shopping_cart,
      ),
      TrackerStep(
        title: 'Sent to Quarantine',
        description: 'Murrah Buffalo 1 unit sent to quarantine',
        date: 'Jan 18, 2024',
        status: StepStatus.completed,
        icon: Icons.local_shipping,
      ),
      TrackerStep(
        title: 'Received at Quarantine',
        description: 'Murrah Buffalo 1 unit received at quarantine',
        date: 'Jan 19, 2024',
        status: StepStatus.completed,
        icon: Icons.check_circle_outline,
      ),
      TrackerStep(
        title: 'Quarantine Passed',
        description: 'Murrah Buffalo 1 unit passed quarantine',
        date: 'Jan 25, 2024',
        status: StepStatus.pending,
        icon: Icons.health_and_safety,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Theme.of(context).primaryTextColor,
              ),
              onPressed: () => Navigator.pop(context),
            ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 10),
            _buildTimeline(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child:
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // aligns everything at the top
            children: [
            
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/images/buffalo_image2.png",
                      height: 70,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Breed ID: ${widget.buffaloType}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _valueRow(context, "${widget.buffaloCount}", context.tr("buffalo")),
                              const SizedBox(width: 6),
                              _valueRow(context, "${widget.calfCount}", context.tr("calf")),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${widget.unitCount} ${context.tr("unit")} + CPF",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

              
                    Container(
                      height: 70, // match image or content height
                      width: 1,
                      color: Colors.grey.withOpacity(0.5),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                    ),

           
                Column(
                          mainAxisAlignment: MainAxisAlignment.start, 
                          crossAxisAlignment: CrossAxisAlignment.start, 
                          children: [
                            Text(
                              "Total",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          // const SizedBox(height: 4),
                            Text(
                              "₹${_formatAmount(widget.totalUnitcost)}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ));
              }

  Widget _buildTimeline() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: FixedTimeline.tileBuilder(
        theme: TimelineThemeData(
          nodePosition: 0, 
          connectorTheme: const ConnectorThemeData(
            thickness: 3.0,
            color: kPrimaryDarkColor,
          ),
          indicatorTheme: const IndicatorThemeData(
            size: 30.0,
          ),
        ),
        builder: TimelineTileBuilder.connected(
          indicatorBuilder: (context, index) {
            final step = _steps[index];
            return OutlinedDotIndicator(
              borderWidth: 2.0,
              color: index <= _currentStep ? Colors.green : Colors.grey[300]!,
              child: Icon(
                step.icon,
                size: 15,
                color: index <= _currentStep ? Colors.green : Colors.grey[400],
              ),
            );
          },
          connectorBuilder: (context, index, type) {
            return SolidLineConnector(
              color: index <= _currentStep ? Colors.green : Colors.grey[200],
            );
          },
          contentsBuilder: (context, index) {
            final step = _steps[index];
            return Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.date,
                    style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (index <= _currentStep)
                        const Icon(Icons.check_circle, color: kPrimaryDarkColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        step.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: index <= _currentStep ? kPrimaryDarkColor : Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    step.description,
                    style: TextStyle( fontSize: 15,fontWeight: FontWeight.w500),
                  ),
                  
                  
                ],
              ),
            );
          },
          itemCount: _steps.length,
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      width: double.infinity,
      color: Colors.grey.withOpacity(0.4),
    );
  }

  Widget _valueRow(BuildContext context, String value, String label) {
    return Text(
      "$value $label",
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
    );
  }

  static String _formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}

enum StepStatus { completed, pending }

class TrackerStep {
  final String title;
  final String description;
  final String date;
  final StepStatus status;
  final IconData icon;

  TrackerStep({
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.icon,
  });
}