import 'package:flutter/material.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/ui/theme/style_themes.dart';

class Loading extends StatelessWidget {
  final bool isTextVisible;

  const Loading({
    super.key,
    this.isTextVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          Visibility(
            visible: isTextVisible,
            child: Column(
              children: const [
                SizedBox(height: 10),
                Text(
                  'Загрузка...',
                  style: StyleThemes.commonDarkStyle,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
