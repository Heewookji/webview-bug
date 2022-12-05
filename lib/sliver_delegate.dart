import 'dart:io';
import 'dart:math';

import 'package:comento_design_system/comento_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  void Function() onAnswer;
  String title;
  String question;

  CustomSliverAppBarDelegate({
    required this.onAnswer,
    required this.title,
    required this.question,
  }) : super();

  @override
  double get maxExtent => 200;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  final interval = Interval(
    0.0,
    1.0,
    curve: Curves.fastOutSlowIn,
  );

  final opacityInterval = Interval(
    0.2,
    0.65,
    curve: Curves.fastOutSlowIn,
  );
  final reverseOpacityInterval = Interval(
    0.0,
    1.0,
    curve: Curves.fastOutSlowIn,
  );

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final percentage = 1.0 - min(1, shrinkOffset / (maxExtent - minExtent));
    final animatedValue = interval.transform(percentage);
    final opacityIntervalValue = opacityInterval.transform(percentage);
    final reverseOpacityIntervalValue =
        reverseOpacityInterval.transform(percentage);

    return Container(
      height: minExtent + (maxExtent - minExtent) * percentage,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: CdsColors.white,
        border: Border(
          bottom: BorderSide(
            color: CdsColors.grey200.withOpacity(1.0 - animatedValue),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLeftIcon(animatedValue),
          _buildButton(
              animatedValue, opacityIntervalValue, reverseOpacityIntervalValue),
        ],
      ),
    );
  }

  Widget _buildLeftIcon(double animatedValue) {
    return Opacity(
      opacity: 1.0 - animatedValue,
      child: SizedBox(
        width: (1.0 - animatedValue) * 16,
        child: IconButton(
          onPressed: () {},
          icon: Icon(CustomIcons.icon_backward_large_line),
        ),
      ),
    );
  }

  Widget _buildButton(
    double animatedValue,
    double opacityIntervalValue,
    double reverseOpacityIntervalValue,
  ) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        _buildIconButton(reverseOpacityIntervalValue),
        _buildBlockButtoon(opacityIntervalValue, animatedValue),
      ],
    );
  }

  Widget _buildBlockButtoon(double opacityIntervalValue, double animatedValue) {
    return Opacity(
      opacity: opacityIntervalValue,
      // return
      child: GestureDetector(
        onTap: onAnswer,
        child: Container(
          decoration: BoxDecoration(
            color: CdsColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          height: max(32, animatedValue * 48),
          width: Platform.isIOS
              ? max(64, animatedValue * 343)
              : max(64, animatedValue * 375),
          alignment: Alignment.center,
          child: Text(
            '답변 추가',
            style: CdsTextStyles.button.merge(
              TextStyle(color: CdsColors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(double reverseOpacityIntervalValue) {
    return Transform.scale(
      scale: 1.0 + (reverseOpacityIntervalValue),
      child: Opacity(
        opacity: 1.0 - reverseOpacityIntervalValue,
        child: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.edit_calendar_sharp,
            color: CdsColors.primary,
          ),
        ),
      ),
    );
  }
}
