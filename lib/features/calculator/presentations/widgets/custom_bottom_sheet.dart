import 'package:flutter/material.dart';

void showCustomBottomSheet(BuildContext context,
    {double? heightFactor, required Widget child}) {
  showModalBottomSheet(
    useSafeArea: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
    ),
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 6,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4)),
                  height: 5,
                  width: MediaQuery.of(context).size.width / 6,
                ),
                const SizedBox(
                  height: 6,
                ),
                child
              ],
            )
          ],
        ),
      );
    },
  );
}
