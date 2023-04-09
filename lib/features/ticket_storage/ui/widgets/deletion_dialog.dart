import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/ui/theme/style_themes.dart';

import '../../bloc/tickets_list/tickets_list_bloc.dart';
import '../../domain/entities/ticket.dart';

class DeletionDialog extends StatelessWidget {
  final Ticket ticket;
  const DeletionDialog({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Действительно хотите удалить файл "${ticket.name}"?',
              style: StyleThemes.commonDarkStyle.copyWith(fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Отмена'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<TicketsListBloc>(context).add(
                      TicketsListEvent.deleteDocument(
                        ticket: ticket,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  child: const Text('Удалить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
