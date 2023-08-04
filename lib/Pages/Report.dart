import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  List day = ['Income', 'Expenses'];
  int index_color = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Report'),
      ),
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Text(
                    'Budget',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Tsh2000',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ...List.generate(2, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {index_color = index;
                              }
                              );
                            },
                            
                            child: Container(
                              height: 40,
                              width: 140,
                              decoration: BoxDecoration(
                                boxShadow: [BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 2,
                                )],
                                
                                borderRadius: BorderRadius.circular(10),
                                color: index_color == index?
                                 Colors.blue:
                                 Colors.white,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                day[index],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: index_color == index?
                                 Colors.white:
                                 Colors.black,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
