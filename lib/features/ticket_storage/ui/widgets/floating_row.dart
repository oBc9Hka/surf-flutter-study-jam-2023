import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/ui/widgets/url_bottom_sheet.dart';

import '../../bloc/tickets_list/tickets_list_bloc.dart';
import '../../enum/ticket_state.dart';
import '../theme/style_themes.dart';

class FloatingButtonController extends ChangeNotifier {
  bool _isVisible;

  FloatingButtonController({
    bool isVisible = false,
  }) : _isVisible = isVisible;

  bool get isVisible => _isVisible;

  set isVisible(bool newIsVisible) {
    if (_isVisible == newIsVisible) return;
    _isVisible = newIsVisible;
    notifyListeners();
  }

  void show() {
    if (!_isVisible) {
      _isVisible = true;
      notifyListeners();
    }
  }

  void hide() {
    if (_isVisible) {
      _isVisible = false;
      notifyListeners();
    }
  }
}

class FloatingRow extends StatefulWidget {
  final FloatingButtonController buttonController;

  const FloatingRow({
    super.key,
    required this.buttonController,
  });

  @override
  State<FloatingRow> createState() => _FloatingRowState();
}

class _FloatingRowState extends State<FloatingRow>
    with SingleTickerProviderStateMixin {
  static const _animDuration = Duration(milliseconds: 100);
  late AnimationController _controller;
  late FloatingButtonController _buttonController;
  late CurvedAnimation _scaleAnim;
  late CurvedAnimation _fadeAnim;

  @override
  void initState() {
    _controller = AnimationController(
      duration: _animDuration,
      vsync: this,
    );
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeIn,
    );
    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeIn,
    );
    _buttonController = widget.buttonController;
    if (_buttonController.isVisible) {
      _controller.forward();
    }

    _buttonController.addListener(() {
      if (_buttonController.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: FadeTransition(
          opacity: _fadeAnim,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    backgroundColor: const Color.fromARGB(255, 238, 240, 255),
                    builder: (context) => const UrlBottomSheet(),
                  );
                },
                child: const Text(
                  'Добавить',
                  style: StyleThemes.commonWhiteStyle,
                ),
              ),
              Visibility(
                visible: context
                    .watch<TicketsListBloc>()
                    .tickets
                    .where((element) => element.state == TicketState.notLoaded)
                    .isNotEmpty,
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<TicketsListBloc>(context).add(
                          TicketsListEvent.downloadTickets(
                            keys: context
                                .read<TicketsListBloc>()
                                .tickets
                                .where(
                                  (element) =>
                                      element.state == TicketState.notLoaded,
                                )
                                .map((e) => e.key)
                                .toList(),
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
                      child: const Text(
                        'Загрузить все',
                        style: StyleThemes.commonWhiteStyle,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
