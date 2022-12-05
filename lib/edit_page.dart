import 'package:comento_design_system/comento_design_system.dart';
import 'package:flutter/material.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});

  static const routeName = '/edit';

  static Route generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => EditPage(),
      settings: settings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        title: Text(
          '답변 작성하기',
          style: CdsTextStyles.headline6,
        ),
        backgroundColor: CdsColors.white,
        foregroundColor: CdsColors.grey700,
      ),
      body: CdsTextArea(hintText: '답변을 작성해주세요'),
    );
  }
}
