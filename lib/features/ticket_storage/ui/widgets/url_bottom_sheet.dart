import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/bloc/tickets_list/tickets_list_bloc.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/ui/theme/style_themes.dart';
import 'package:validators/validators.dart';

class UrlBottomSheet extends StatefulWidget {
  const UrlBottomSheet({super.key});

  @override
  State<UrlBottomSheet> createState() => _UrlBottomSheetState();
}

class _UrlBottomSheetState extends State<UrlBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  @override
  void initState() {
    getClipBoardData();
    super.initState();
  }

  Future<void> getClipBoardData() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text;
    if ((text?.isNotEmpty ?? false) && text!.split('.').last == 'pdf') {
      controller.text = text;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.25,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 50,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Form(
                key: formKey,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Введите Url',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.redAccent,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.indigo,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  controller: controller,
                  validator: (value) {
                    if (!isURL(value, requireProtocol: true)) {
                      return 'Введите корректный Url';
                    }
                    return null;
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty &&
                    (formKey.currentState?.validate() ?? false)) {
                  if (context
                      .read<TicketsListBloc>()
                      .tickets
                      .where((element) => element.url == controller.text)
                      .isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Такой Url уже есть в списке'),
                        duration: Duration(milliseconds: 2500),
                      ),
                    );
                    Navigator.pop(context);
                    return;
                  }
                  BlocProvider.of<TicketsListBloc>(context).add(
                    TicketsListEvent.addTicket(
                      url: controller.text,
                      onSuccess: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Файл успешо добавлен'),
                            duration: Duration(milliseconds: 1500),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      onError: (msg) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(msg),
                            duration: const Duration(milliseconds: 2500),
                          ),
                        );
                      },
                    ),
                  );
                  controller.clear();
                }
              },
              child: const Text(
                'Добавить',
                style: StyleThemes.commonWhiteStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
