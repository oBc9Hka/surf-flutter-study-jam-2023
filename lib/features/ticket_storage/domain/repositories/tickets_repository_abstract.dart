import 'package:dio/dio.dart';

import '../entities/ticket.dart';

abstract class TicketsRepositoryAbstract {
  Future<bool> saveTicketsList({required List<Ticket> tickets});

  Future<List<Ticket>> loadTicketsList();

  Future<bool> downloadDocument({
    required Ticket ticket,
    void Function(int, int)? onReceiveProgress,
    required CancelToken cancelToken,
  });

  Future<bool> deleteTicket({
    required Ticket ticket,
  });
}
