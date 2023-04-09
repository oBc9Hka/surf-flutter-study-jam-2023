import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_preview/bloc/document_view/document_view_bloc.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/bloc/tickets_list/tickets_list_bloc.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/domain/entities/ticket.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/ui/widgets/deletion_dialog.dart';
import 'dart:math';

import '../../../ticket_preview/ui/document_view_screen.dart';
import '../../enum/ticket_state.dart';

class TicketTile extends StatelessWidget {
  final Ticket ticket;

  const TicketTile({
    super.key,
    required this.ticket,
  });

  Widget _loadingButton(BuildContext context) {
    final IconButton button;
    switch (ticket.state) {
      case TicketState.notLoaded:
        button = IconButton(
          onPressed: () {
            BlocProvider.of<TicketsListBloc>(context).add(
              TicketsListEvent.downloadTickets(
                keys: [ticket.key],
                onError: (msg) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(msg),
                      duration: const Duration(milliseconds: 1500),
                    ),
                  );
                },
              ),
            );
          },
          icon: const Icon(Icons.download),
        );
        break;
      case TicketState.loading:
        button = IconButton(
          onPressed: () {
            BlocProvider.of<TicketsListBloc>(context).add(
              TicketsListEvent.pauseDownloadForTicket(
                key: ticket.key,
              ),
            );
          },
          icon: const Icon(Icons.stop_circle),
        );
        break;
      case TicketState.paused:
        button = IconButton(
          onPressed: () {},
          icon: const Icon(Icons.play_arrow),
        );
        break;
      case TicketState.loaded:
        button = const IconButton(
          onPressed: null,
          disabledColor: Colors.black,
          icon: Icon(Icons.cloud_download),
        );
        break;
    }
    return Row(
      children: [
        button,
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return DeletionDialog(
                  ticket: ticket,
                );
              },
            );
          },
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }

  Widget _loadingIndicator() {
    var val = 0.0;
    if (ticket.state == TicketState.loading &&
        ticket.loadingProgress.total > 0) {
      val = ticket.loadingProgress.downloaded / ticket.loadingProgress.total;
    } else if (ticket.state == TicketState.loaded) {
      val = 1;
    }
    return LinearProgressIndicator(
      value: val,
    );
  }

  static String formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    final i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }

  Widget _subText() {
    final String text;
    switch (ticket.state) {
      case TicketState.notLoaded:
        text = 'Ожидает начала загрузки';
        break;
      case TicketState.loading:
      case TicketState.paused:
        text =
            'Загружается ${formatBytes(ticket.loadingProgress.downloaded)} из ${formatBytes(ticket.loadingProgress.total)}';
        break;
      case TicketState.loaded:
        text = 'Загружено';
        break;
    }
    return Text(text);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (ticket.state == TicketState.loaded) {
          BlocProvider.of<DocumentViewBloc>(context).add(
            DocumentViewEvent.load(ticket: ticket),
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DocumentViewScreen(),
            ),
          );
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.airplane_ticket),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ticket.name),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: _loadingIndicator(),
                          ),
                          _subText(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _loadingButton(context),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
