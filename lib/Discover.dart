import 'dart:convert';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cleaner_together/Custom%20Widgets.dart';
import 'package:cleaner_together/ShowWebView.dart';
import 'package:countup/countup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morphable_shape/morphable_shape.dart';

class Discover extends StatelessWidget {
  final articles = [
    'Basic Material Knowledge',
    'First Steps to Zero-Waste',
    'Having a Zero Waste Party',
    'How to Fix a Wet Compost',
    'How to Make a Compost',
    'MAGGOTS!!!',
    'Ranking the 3 R\'s (and Composting)',
    'Recycling Do\'s and Don\'ts',
    'Recycling v. Composting',
    'The Browns in Your Compost',
    'The Horrors of E-Waste',
    'What Plastic Numbers Mean'
  ];

  final facts = [
      "Recycling cardboard only takes 75% of the energy required to make new cardboard.",
      "Over 90% of all products shipped in the U.S. are shipped in corrugated boxes, which makes up more than 400 billion square feet of cardboard.",
      "Around 80% of retailers and grocers recycle cardboard.",
      "70% of corrugated cardboard is recovered for recycling.",
      "Approximately 100 billion cardboard boxes are produced each year in the U.S.",
      "One ton of recycled cardboard saves 46 gallons of oil.",
      "One ton of recycled cardboard saves 9 cubic yards of landfill space.",
      "Nearly half of the food in the U.S. goes to waste - approximately 3,000 pounds per second.",
      "Only about 5% of food is diverted from landfill.",
      "The U.S. produces approximately 34 million tons of food waste each year.",
      "Food scraps make up almost 12% of municipal solid waste generated in the U.S.",
      "In 2015, about 137.7 million tons of MSW were landfilled. Food was the largest component at about 22%.",
      "2.5 million plastic bottles are thrown away every hour in America.",
      "Recycling plastic takes 88% less energy than making it from raw materials.",
      "Enough plastic is thrown away each year to circle the earth four times.",
      "Only 23% of disposable water bottles are recycled.",
      "Plastic bags can take up to 1,000 years to decompose.",
      "Recycling one ton of plastic saves the equivalent of 1,000–2,000 gallons of gasoline.",
      "Recycling plastic saves twice as much energy as burning it in an incinerator.",
      "Styrofoam never decomposes.",
      "The world produces more than 14 million tons of Polystyrene (plastic foam) each year.",
      "Recycling one ton of plastic bottles saves the equivalent energy usage of a two person household for one year.",
      "A modern glass bottle would take 4,000 years or more to decompose -- and even longer if it's in landfill.",
      "Glass can be recycled and re-manufactured an infinite amount of times and never wear out.",
      "More than 28 billion glass bottles and jars go to landfills every year. That's enough to fill two Empire State Buildings every three weeks.",
      "A modern glass bottle would take 4,000 years or more to decompose − and even longer if it’s in landfill.",
      "Americans use 85 million tons of paper per year which is about 680 pounds per person.",
      "70% of the total waste in offices is paper waste.",
      "Recycling one ton of paper saves 7,000 gallons of water.",
      "The average office worker uses 10,000 sheets of paper per year.",
      "American businesses use around 21 million tons of paper - with about 750,000 copies made every minute.",
      "Each ton of recycled paper can save 17 mature trees.",
      "Recycling a stack of newspaper just 3 feet high saves one tree.",
      "Approximately 1 billion trees worth of paper are thrown away every year in the U.S.",
      "The average person has the opportunity to recycle more than 25,000 cans in their life.",
      "An aluminum can can be recycled and back on a grocery store shelf as a new can in as little as 60 days.",
      "Aluminum can be recycled forever without any loss of quality.",
      "Aluminum can be recycled using only 5% of the energy used to make the product from new.",
      "Recycling a single aluminum can saves enough energy to power a TV for 3 hours.",
      "About 11 million tons of textiles end up in U.S. landfills each year — an average of about 70 pounds per person.",
      "In 2007, 1.8 million tons of e-waste ended up in landfills.",
      "The average person generates 4.4 pounds of solid waste every day.",
      "In 2014, The U.S. generated 258 million tons of municipal solid waste (MSW).",
      "The EPA estimates that 75% of the American waste stream is recyclable, but we only recycle about 30% of it.",
      "94% of the U.S. population has access to some type of recycling program.",
      "Americans generate an additional 5 million tons of waste throughout the holidays.",
      "Americans throw away enough trash in an average year to circle the earth 24 times.",
      "Electronic waste totals approximately 2% of the waste stream in the U.S.",
      "On average, it costs \$30 per ton to recycle trash, \$50 to send it to the landfill and \$65 to \$75 to incinerate it."
  ];

  final currentMinutes = DateTime.now().difference(DateTime(DateTime.now().year)).inMinutes;
  CarouselController carouselArrowController = CarouselController();

  final wave =
      '{"type":"Path","border":{"color":"ff000000","width":0,"style":"none","strokeCap":"butt","strokeJoin":"miter"},"path":{"size":{"width":1000,"height":600},"nodes":[{"pos":{"dx":1000,"dy":1.34},"next":{"dx":1000,"dy":90.69}},{"pos":{"dx":1000,"dy":359.28000000000026},"prev":{"dx":1000,"dy":154.74999999999977},"next":{"dx":917.97,"dy":314.036}},{"pos":{"dx":801.2789746093769,"dy":360.4336425781248},"prev":{"dx":909.551,"dy":250.273},"next":{"dx":733.127,"dy":395.644}},{"pos":{"dx":604.4642968750021,"dy":361.5728906250001},"prev":{"dx":710.383,"dy":474.14},"next":{"dx":521.156,"dy":315.28}},{"pos":{"dx":401.8843750000004,"dy":360.2231250000005},"prev":{"dx":508.807,"dy":249.949},"next":{"dx":334.969,"dy":399.341}},{"pos":{"dx":200.11500000000004,"dy":359.8750000000018},"prev":{"dx":309.808,"dy":471.308},"next":{"dx":132.73,"dy":312.685}},{"pos":{"dx":0,"dy":359.97999999999973},"prev":{"dx":106,"dy":251.91},"next":{"dx":0,"dy":0}},{"pos":{"dx":0,"dy":0}}]}}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SideMenu(),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: <Widget>[
              Container(
                height: 150,
                padding: EdgeInsets.fromLTRB(10, 40, 10, 0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Theme.of(context).shadowColor, Colors.white],
                  )
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Discover',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 44.0,
                          ),
                        ),
                        Spacer(),
                        // IconButton(
                        //   icon: Icon(
                        //       Icons.menu,
                        //       size: 36.0,
                        //       color: Colors.white
                        //   ),
                        //   onPressed: () {
                        //     print('1');
                        //     Scaffold.of(context).openEndDrawer();
                        //   },
                        // ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(
                                'Why?',
                                style: TextStyle(color: Colors.grey),
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ShowWebView(
                                    'https://cleanertogether.com/why/',
                                    'Why')));
                              },
                            ),
                            Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(
                                'How?',
                                style: TextStyle(color: Colors.grey),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context, MaterialPageRoute(
                                        builder: (context) => ShowWebView(
                                            'https://cleanertogether.com/initiatives/',
                                            'Initiatives')));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
                ),
              ),
              Container(
                height: 410,
                color: Colors.white,
                child: Column(
                  children: buildCounters(context),
                ),
              ),
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, size: 30.0, color: Colors.black,),
                      onPressed: () {
                        carouselArrowController.previousPage();
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: CarouselSlider(
                        carouselController: carouselArrowController,
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          viewportFraction: 1.0,
                          height: 150,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 10),
                          initialPage: Random().nextInt(facts.length),
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                        ),
                        items: facts.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                margin: EdgeInsets.fromLTRB(35, 0, 35, 0),
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).shadowColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    i,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios, size: 30.0, color: Colors.black),
                      onPressed: () {
                        carouselArrowController.nextPage();
                      },
                    ),
                  ]
                ),
              ),
              DecoratedShadowedShape(
                shape: parseMorphableShapeBorder(json.decode(wave)),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Blog',
                    style: TextStyle(color: Colors.white, fontSize: 36.0),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.width - 25) * 9 / 16,
                // child: Expanded(
                  child: ListView.builder(
                    itemCount: articles.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        width: MediaQuery.of(context).size.width - 60,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/Article Thumbnails/${articles[i]}.jpg'))),
                        child: ButtonTheme(
                          buttonColor: Colors.transparent,
                          child: ElevatedButton(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Text(
                                    articles[i],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      backgroundColor: Colors.transparent
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            ),
                            onPressed: () {
                              String articleUrl = '';
                              for (int j = 0; j < articles[i].length; j++) {
                                if (articles[i].substring(j, j + 1) == ' ')
                                  articleUrl += '-';
                                else
                                  articleUrl += articles[i].substring(j, j + 1).toLowerCase();
                                print(articleUrl);
                              }
                              String url = 'https://cleanertogether.com/$articleUrl';
                              print(url);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ShowWebView(url, articles[i])));
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildCounters(BuildContext context) {
    List<Widget> counters = [];
    List<String> titles = [
      'Tons of Plastic Dumped into\nthe Oceans this Year',
      'Tons of Solid Waste Created\nthis Year',
      'Tons of CO2 Emitted into the\nAtmosphere this Year'
    ];
    List<String> descrips = [
      'Sea animals often ingest plastic waste and it can travel up the food chain to humans.',
      'Growing amounts of trash lead to more resource consumption and landfill area usage.',
      'Leads to increased temperatures, natural disasters, wildlife extinctions, and death rates.'
    ];
    List<double> countUp = [24.163, 21308.98, 81811.26];

    for (int i = 0; i < 3; i++) {
      counters.add(
        Container(
          width: MediaQuery.of(context).size.width,
          height: 130,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Positioned(
                left: 10,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(10, 10, 30, 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 40,
                        child: FittedBox(
                          child: Countup(
                            begin: currentMinutes * countUp[i],
                            end: (currentMinutes + 720) * countUp[i],
                            duration: Duration(hours: 12),
                            separator: ',',
                            style: TextStyle(
                              // fontSize: 30,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        child: FittedBox(
                          child: Text(
                            titles[i],
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.6 - 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  height: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Text(
                      descrips[i],
                      textAlign: TextAlign.center,
                      maxLines: 8,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      );
    }
    return counters;
  }
}
