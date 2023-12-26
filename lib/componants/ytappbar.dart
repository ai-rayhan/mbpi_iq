import 'package:flutter/material.dart';

class YtScreenAppbar extends StatelessWidget {
  const YtScreenAppbar({
    super.key,

    required this.title,
  });


  final String title;

  @override
  Widget build(BuildContext context) {
     var width = MediaQuery.sizeOf(context).width;
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_rounded)),
          SizedBox(
              width: width / 1.3,
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              )),
              const SizedBox(height: 8,)
        ],
      ),
    );
  }
}
