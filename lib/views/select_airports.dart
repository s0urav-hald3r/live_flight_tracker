import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_flight_tracker/airports_data.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/utils/extension.dart';

class SelectAirports extends StatefulWidget {
  const SelectAirports({super.key});

  @override
  State<SelectAirports> createState() => _SelectAirportsState();
}

class _SelectAirportsState extends State<SelectAirports> {
  final controller = HomeController.instance;

  @override
  void initState() {
    super.initState();
    controller.filteredItems = airportsData;
  }

  void _filterList(String query) {
    controller.filteredItems = airportsData
        .where((item) =>
            item["name"].toLowerCase().contains(query.toLowerCase()) ||
            item["municipality"].toLowerCase().contains(query.toLowerCase()) ||
            item["iata_code"].toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(children: [
          Container(
            padding: EdgeInsets.only(
              right: 16.w,
              top: MediaQuery.of(context).padding.top,
            ),
            width: MediaQuery.of(context).size.width,
            height: 48.h + MediaQuery.of(context).padding.top,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => NavigatorKey.pop(),
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: SvgPicture.asset(leftArrow),
                    ),
                  ),
                  const Text(
                    'Search Airports',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: whiteColor,
                    ),
                  ),
                  const Visibility.maintain(
                    visible: false,
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ]),
          ),
          SizedBox(height: 16.h),
          Container(
            height: 45.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            child: CupertinoTextField(
              onChanged: _filterList,
              autofocus: true,
              decoration: BoxDecoration(
                color: const Color(0xFF323558),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.only(left: 0.w),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: whiteColor,
              ),
              placeholder: 'Search',
              keyboardType: TextInputType.text,
              placeholderStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
              prefix: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SvgPicture.asset(search),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Obx(() {
            return Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.filteredItems.length,
                  itemBuilder: (context, index) {
                    final value = controller.filteredItems[index];

                    return InkWell(
                      onTap: () {
                        NavigatorKey.pop({
                          'iata': value['iata_code'],
                          'name': value['name']
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        margin: EdgeInsets.only(bottom: 16.h),
                        child: Row(children: [
                          Container(
                            width: 50.w,
                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.red),
                              color: Colors.red.shade100,
                            ),
                            child: Center(
                              child: Text(
                                value['iata_code'],
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 285.w,
                            child: Text(
                              value['name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    );
                  }),
            );
          })
        ]),
      ),
    );
  }
}
