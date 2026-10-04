import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/snackbar_extentions.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';

typedef CounterUpdateCallback = Future<String?> Function(int value);

typedef C = AppConstants;

class CounterUpdateDialog extends StatelessWidget {
  final int currentValue;
  final int target;
  final TargetCondition condition;
  final CounterUpdateCallback onSave;

  const CounterUpdateDialog({
    super.key,
    required this.currentValue,
    required this.target,
    required this.condition,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final counter = currentValue.obs;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Center(
        child: Text(
          C.activity.updateTarget,
          style: TextStyle(
            fontSize: context.text.headlineSmall?.fontSize,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CounterBox(counter: counter, colorScheme: colorScheme),
          const SizedBox(height: 16),
          Text(
            C.activity.targetDisplay(condition.displayName, target),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: context.text.labelMedium?.fontSize,
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: Text(
            C.common.cancel,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: context.text.bodyLarge?.fontSize,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            final error = await onSave(counter.value);
            if (error != null) {
              '${C.activity.updateErrorBase}$error'.errorSnackbar();
            }
            if (context.mounted) {
              Navigator.of(context, rootNavigator: true).pop();
            }
          },
          child: Text(
            C.common.update,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: context.text.titleMedium?.fontSize,
            ),
          ),
        ),
      ],
    );
  }
}

class _CounterBox extends StatefulWidget {
  final RxInt counter;
  final ColorScheme colorScheme;

  const _CounterBox({required this.counter, required this.colorScheme});

  @override
  State<_CounterBox> createState() => _CounterBoxState();
}

class _CounterBoxState extends State<_CounterBox> {
  late final TextEditingController textController;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: '${widget.counter.value}');
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _setCounter(int value) {
    final nextValue = value < 0 ? 0 : value;
    widget.counter.value = nextValue;
    textController.value = TextEditingValue(
      text: '$nextValue',
      selection: TextSelection.collapsed(offset: '$nextValue'.length),
    );
  }

  void _onTextChanged(String value) {
    widget.counter.value = int.tryParse(value) ?? 0;
  }

  void _normalizeText() {
    final normalizedValue = '${widget.counter.value}';
    if (textController.text == normalizedValue) return;

    textController.value = TextEditingValue(
      text: normalizedValue,
      selection: TextSelection.collapsed(offset: normalizedValue.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = widget.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Obx(() {
            final isMinusDisabled = widget.counter.value <= 0;
            return SizedBox(
              width: 36,
              height: 36,
              child: Container(
                decoration: BoxDecoration(
                  color: isMinusDisabled
                      ? colorScheme.primary.withValues(alpha: 0.35)
                      : colorScheme.primary.withValues(alpha: 0.75),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: isMinusDisabled
                      ? null
                      : () => _setCounter(widget.counter.value - 1),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 36,
                    height: 36,
                  ),
                  iconSize: 18,
                  icon: Icon(Icons.remove, color: colorScheme.surface),
                ),
              ),
            );
          }),
          Expanded(
            child: TextFormField(
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
              controller: textController,
              focusNode: focusNode,
              textAlign: TextAlign.center,
              maxLines: 1,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: _onTextChanged,
              onEditingComplete: _normalizeText,
              onFieldSubmitted: (_) {
                _normalizeText();
                focusNode.unfocus();
              },
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 42,
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          SizedBox(
            width: 36,
            height: 36,
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.75),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => _setCounter(widget.counter.value + 1),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 36,
                  height: 36,
                ),
                iconSize: 18,
                icon: Icon(Icons.add, color: colorScheme.surface),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
