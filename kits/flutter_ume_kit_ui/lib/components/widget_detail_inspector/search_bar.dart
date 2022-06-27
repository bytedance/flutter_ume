import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ume_kit_ui/util/binding_ambiguate.dart';
import 'icon.dart' as icon;

typedef void OnSubmitHandle(String text);
typedef void OnChangeHandle(String text);
typedef void OnFocusChangeHandle(bool focus);

enum BarStyle {
  solid,
  border,
}

class SearchBar extends StatefulWidget {
  final String placeHolder;
  final bool autofocus;
  final bool enabled;
  final String? cancelText;
  final Color? cursorColor;
  final Color? searchIconColor;
  final Brightness keyboardAppearance;
  final BarStyle style;
  final Widget? right;
  final int inputCharactersLength;
  final Function? rightAction;
  final OnChangeHandle? onChangeHandle;
  final OnSubmitHandle? onSubmitHandle;
  final OnFocusChangeHandle? onFocusChangeHandle;

  SearchBar({
    Key? key,
    this.placeHolder = '请输入要搜索的内容',
    this.autofocus = false,
    this.enabled = true,
    this.cancelText,
    this.cursorColor,
    this.right,
    this.style = BarStyle.solid,
    this.keyboardAppearance = Brightness.light,
    this.rightAction,
    this.searchIconColor,
    this.onChangeHandle,
    this.onSubmitHandle,
    this.onFocusChangeHandle,
    this.inputCharactersLength = 100,
  }) : super(key: key);

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchBar> {
  bool _showClearIcon = false;
  TextEditingController _inputController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (widget.onFocusChangeHandle != null) {
        widget.onFocusChangeHandle!(_focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _focus() {
    _unfocus();
    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _unfocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _inputSubmitHandle(String query) {
    _unfocus();
    if (widget.onSubmitHandle is OnSubmitHandle) {
      widget.onSubmitHandle!(query);
    }
  }

  void _inputChangeHandle(String query) {
    bool curClearIconStatus = query.isNotEmpty;
    if (curClearIconStatus != _showClearIcon) {
      setState(() {
        _showClearIcon = curClearIconStatus;
      });
    }
    if (widget.onChangeHandle != null) {
      widget.onChangeHandle!(query);
    }
  }

  Widget _buildSearcIcon() {
    return Container(
        margin: const EdgeInsets.only(right: 11.0),
        child: Image.memory(
          icon.iconBytes,
          width: 16,
          height: 16,
        ));
  }

  Widget _buildClearIcon() {
    if (!_showClearIcon) {
      return Container(width: 0, height: 0);
    }
    return GestureDetector(
      onTap: () {
        bindingAmbiguate(WidgetsBinding.instance)!.addPostFrameCallback((_) {
          _inputController.clear();
          _focus();
        });
        _inputChangeHandle('');
      },
      child: Container(
          margin: EdgeInsets.only(left: 16.0),
          child: Image.memory(icon.iconBytes, width: 16, height: 16)),
    );
  }

  Widget _buildTextField() {
    List<TextInputFormatter> formatters = [];
    if (widget.inputCharactersLength > 0) {
      formatters = [
        LengthLimitingTextInputFormatter(widget.inputCharactersLength)
      ];
    }

    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
      child: TextField(
        enabled: widget.enabled,
        textAlignVertical: TextAlignVertical.center,
        keyboardAppearance: widget.keyboardAppearance,
        focusNode: _focusNode,
        controller: _inputController,
        onChanged: _inputChangeHandle,
        autofocus: widget.autofocus,
        maxLines: 1,
        onSubmitted: _inputSubmitHandle,
        maxLengthEnforcement: MaxLengthEnforcement.none,
        style: TextStyle(
          fontSize: 15.0,
          color: Colors.black,
          textBaseline: TextBaseline.alphabetic,
        ),
        cursorColor: widget.cursorColor ?? Colors.red,
        decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            hintText: widget.placeHolder,
            hintMaxLines: 1,
            hintStyle: TextStyle(
              fontSize: 15.0,
              color: widget.style == BarStyle.border
                  ? Colors.black38
                  : Colors.black54,
              textBaseline: TextBaseline.alphabetic,
            )),
        inputFormatters: formatters,
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      decoration: widget.style == BarStyle.border
          ? BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(6.0)),
              border: Border.all(
                  color: Colors.black12, style: BorderStyle.solid, width: 1))
          : BoxDecoration(
              color: Colors.black.withOpacity(0.04),
              borderRadius: const BorderRadius.all(Radius.circular(6.0))),
      padding:
          const EdgeInsets.only(top: 9.0, left: 12.0, right: 12.0, bottom: 8.0),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: _buildSearcIcon(),
          ),
          Expanded(flex: 1, child: _buildTextField()),
          Expanded(flex: 0, child: _buildClearIcon())
        ],
      ),
    );
  }

  Widget _buildClickButton() {
    Widget right;
    if (widget.right != null) {
      right = Container(
          constraints: const BoxConstraints(maxHeight: 38),
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: widget.right);
    } else {
      if (widget.cancelText == null) {
        right = Container(width: 0, height: 0);
      } else {
        right = Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Text(widget.cancelText!,
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)));
      }
    }
    return GestureDetector(
        onTap: () {
          _inputSubmitHandle(_inputController.text);
          if (widget.rightAction != null) {
            widget.rightAction!();
          }
        },
        child: right);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: _buildInput(),
        ),
        Expanded(flex: 0, child: _buildClickButton())
      ],
    ));
  }
}
