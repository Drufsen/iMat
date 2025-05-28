import 'package:flutter/material.dart';
import 'package:imat_app/widgets/settings_popup_content.dart';

class SettingsOverlayController {
  OverlayEntry? _settingsOverlay;

  void toggleSettingsPopup(BuildContext context, GlobalKey targetKey) {
    if (_settingsOverlay != null) {
      removeSettingsPopup();
      return;
    }

    final RenderBox button =
        targetKey.currentContext!.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );
    final Size buttonSize = button.size;

    const double popupWidth = 320;
    double left = position.dx;
    final double screenWidth = overlay.size.width;

    if (left + popupWidth > screenWidth) {
      left = screenWidth - popupWidth - 8;
    }

    _settingsOverlay = OverlayEntry(
      builder:
          (context) => Positioned(
            left: left,
            top: position.dy + buttonSize.height + 8,
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: removeSettingsPopup,
                    child: Container(
                      width: screenWidth,
                      height: overlay.size.height,
                      color: Colors.transparent,
                    ),
                  ),
                  SettingsPopupContent(onClose: removeSettingsPopup),
                ],
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_settingsOverlay!);
  }

  void removeSettingsPopup() {
    _settingsOverlay?.remove();
    _settingsOverlay = null;
  }
}
