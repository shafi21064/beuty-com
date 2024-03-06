import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:kirei/my_theme.dart';

class ShimmerHelper {
  buildBasicShimmer(
      {double height = double.infinity, double width = double.infinity}) {
    return Shimmer.fromColors(
      baseColor: MyTheme.light_grey,
      highlightColor: MyTheme.light_grey,
      child: Container(
        height: height,
        width: width,
        color: Colors.white,
      ),
    );
  }

  buildAddressLoadingShimmer(
      {double height = double.infinity, double width = double.infinity}) {
    return Shimmer.fromColors(
      baseColor: MyTheme.white,
      highlightColor: MyTheme.white,
      child: Container(
        height: height,
        width: width,
        color: Colors.white,
      ),
    );
  }

  buildListShimmer({item_count = 10, item_height = 100.0}) {
    return ListView.builder(
      itemCount: item_count,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
              top: 0.0, left: 16.0, right: 16.0, bottom: 16.0),
          child: ShimmerHelper().buildBasicShimmer(height: item_height),
        );
      },
    );
  }

  buildProductGridShimmer({scontroller, item_count = 10}) {
    return GridView.builder(
      itemCount: item_count,
      controller: scontroller,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7),
      padding: EdgeInsets.all(8),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: MyTheme.light_grey,
            highlightColor: MyTheme.light_grey,
            child: Container(
              height: 120,
              width: double.infinity,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  buildHomeProductGridShimmer({scontroller, item_count = 10}) {
    return GridView.builder(
      itemCount: item_count,
      controller: scontroller,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.85),
      padding: EdgeInsets.all(8),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: MyTheme.light_grey,
            highlightColor: MyTheme.light_grey,
            child: Container(
              height: 120,
              width: double.infinity,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  // buildHomeProductGridShimmer({scontroller, item_count = 10}) {
  //   return ListView.builder(
  //     scrollDirection: Axis.horizontal,
  //     itemCount: item_count,
  //     controller: scontroller,
  //     // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //     //     crossAxisCount: 2,
  //     //     crossAxisSpacing: 10,
  //     //     mainAxisSpacing: 10,
  //     //     childAspectRatio: 0.85),
  //     padding: EdgeInsets.all(8),
  //     physics: NeverScrollableScrollPhysics(),
  //     shrinkWrap: true,
  //     itemBuilder: (context, index) {
  //       return Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Shimmer.fromColors(
  //           baseColor: MyTheme.light_grey,
  //           highlightColor: MyTheme.light_grey,
  //           child: Container(
  //             height: 120,
  //             width: 60,
  //             color: Colors.white,
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  buildSquareGridShimmer({scontroller, item_count = 10}) {
    return GridView.builder(
      itemCount: item_count,
      controller: scontroller,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1
      ),
      padding: EdgeInsets.all(8),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: MyTheme.light_grey,
            highlightColor: MyTheme.light_grey,
            child: Container(
              height: 120,
              width: double.infinity,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
