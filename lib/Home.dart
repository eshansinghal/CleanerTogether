import 'package:carousel_slider/carousel_slider.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'Custom Widgets.dart';
import 'Notifications.dart';

class Home extends StatelessWidget {
  final currentMinutes =
      DateTime.now().difference(DateTime(DateTime.now().year)).inMinutes;

  final facts = [["Recycling cardboard only takes 75% of the energy required to make new cardboard.", "Over 90% of all products shipped in the U.S. are shipped in corrugated boxes, which makes up more than 400 billion square feet of cardboard.", "Around 80% of retailers and grocers recycle cardboard.", "70% of corrugated cardboard is recovered for recycling." , "Approximately 100 billion cardboard boxes are produced each year in the U.S.", "One ton of recycled cardboard saves 46 gallons of oil.", "One ton of recycled cardboard saves 9 cubic yards of landfill space."],
    ["Nearly half of the food in the U.S. goes to waste - approximately 3,000 pounds per second.","Only about 5% of food is diverted from landfill.","The U.S. produces approximately 34 million tons of food waste each year.","Food scraps make up almost 12% of municipal solid waste generated in the U.S.","In 2015, about 137.7 million tons of MSW were landfilled. Food was the largest component at about 22%."],
    ["2.5 million plastic bottles are thrown away every hour in America.","Recycling plastic takes 88% less energy than making it from raw materials.","Enough plastic is thrown away each year to circle the earth four times.","Only 23% of disposable water bottles are recycled.","Plastic bags can take up to 1,000 years to decompose.","Recycling one ton of plastic saves the equivalent of 1,000–2,000 gallons of gasoline.","Recycling plastic saves twice as much energy as burning it in an incinerator.","Styrofoam never decomposes.","The world produces more than 14 million tons of Polystyrene (plastic foam) each year.","Recycling one ton of plastic bottles saves the equivalent energy usage of a two person household for one year."],
    ["A modern glass bottle would take 4,000 years or more to decompose -- and even longer if it's in landfill.","Glass can be recycled and re-manufactured an infinite amount of times and never wear out.","More than 28 billion glass bottles and jars go to landfills every year. That's enough to fill two Empire State Buildings every three weeks.","A modern glass bottle would take 4,000 years or more to decompose − and even longer if it’s in landfill."],
    ["Americans use 85 million tons of paper per year which is about 680 pounds per person.","70% of the total waste in offices is paper waste.","Recycling one ton of paper saves 7,000 gallons of water.","The average office worker uses 10,000 sheets of paper per year.","American businesses use around 21 million tons of paper - with about 750,000 copies made every minute.","Each ton of recycled paper can save 17 mature trees.","Recycling a stack of newspaper just 3 feet high saves one tree.","Approximately 1 billion trees worth of paper are thrown away every year in the U.S."],
    ["The average person has the opportunity to recycle more than 25,000 cans in their life.","An aluminum can can be recycled and back on a grocery store shelf as a new can in as little as 60 days.","Aluminum can be recycled forever without any loss of quality.","Aluminum can be recycled using only 5% of the energy used to make the product from new.","Recycling a single aluminum can saves enough energy to power a TV for 3 hours."],
    ["About 11 million tons of textiles end up in U.S. landfills each year — an average of about 70 pounds per person.","In 2007, 1.8 million tons of e-waste ended up in landfills.","The average person generates 4.4 pounds of solid waste every day.","In 2014, The U.S. generated 258 million tons of municipal solid waste (MSW).","The EPA estimates that 75% of the American waste stream is recyclable, but we only recycle about 30% of it.","94% of the U.S. population has access to some type of recycling program.","Americans generate an additional 5 million tons of waste throughout the holidays.","Americans throw away enough trash in an average year to circle the earth 24 times.","Electronic waste totals approximately 2% of the waste stream in the U.S.","On average, it costs \$30 per ton to recycle trash, \$50 to send it to the landfill and \$65 to \$75 to incinerate it."]];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text('Which Bin'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_active),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Notifications()));
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.blue,
        child: Column(
          children: <Widget>[
            Container(
              child: CarouselSlider(
              options: CarouselOptions(height: 250.0, enlargeCenterPage: true),
              items: [0, 1, 2].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    var title = '';
                    var increase = 0.0;
                    var description = '';
                    if (i == 0) {
                      title =
                          'Tons of Plastic Waste Dumped into the Oceans this Year';
                      increase = 24.163;
                    }
                    if (i == 1) {
                      title =
                          'Tons of CO2 Emitted into the Atmosphere this Year';
                      increase = 21308.98;
                    }
                    if (i == 2) {
                      title =
                          'Tons of CO2 emitted into the atmosphere this year';
                      increase = 81811.26;
                    }
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Column(
                        children: <Widget>[
                          Countup(
                            begin: currentMinutes * increase,
                            end: (currentMinutes + 720) * increase,
                            duration: Duration(hours: 12),
                            separator: ',',
                            style: TextStyle(
                              fontSize: 36,
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.white)),
                                TextSpan(
                                    text: description,
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            )),
          ],
        ),
      ),
    );
  }
}
