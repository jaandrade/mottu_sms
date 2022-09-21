import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_plugin/sms_plugin.dart';
import 'package:sms_plugin_example/extensions.dart';
import 'package:sms_plugin_example/permissions.dart';

class SmsWidget extends StatefulWidget {
  const SmsWidget({Key? key}) : super(key: key);

  @override
  State<SmsWidget> createState() => _SmsWidgetState();
}

class _SmsWidgetState extends State<SmsWidget> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _smsPlugin = SmsPlugin();
  final _permission = Permissions();
  final _focusNodePhone = FocusNode();

  bool _isSmsAuthorized = false;
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String result = '';

    try {
      result =
          await _smsPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      result = 'Failed to get platform version.';
    }

    await _permission.checkPermissionStatus();

    if (!mounted) return;

    setState(() {
      _platformVersion = result;
      _isSmsAuthorized = _permission.authorized;
    });
  }

  Future<String> sendSms() {
    try {
      if (_formKey.currentState!.saveAndValidate()) {
        String phone = _formKey.currentState!.value["phone"];
        phone = phone
            .replaceAll(" ", "")
            .replaceAll("(", "")
            .replaceAll(")", "")
            .replaceAll("-", "");

        if (phone.length < 11) return Future(() => "");

        String message = _formKey.currentState!.value["message"];

        _formKey.currentState!.reset();

        _smsPlugin.sendSms(phone, message);

        return Future(() => "Sms sended with sucess.");
      }

      return Future(() => "");
    } on PlatformException {
      return Future(() => "Failed sending sms.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 4,
        title:
            const Text('Mottu Sms', style: TextStyle(color: Color(0xff01A72F))),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Image.asset(
                'assets/banner.png',
                fit: BoxFit.fitWidth,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: context.paddingTop,
                  left: context.paddingHorizontal,
                  right: context.paddingHorizontal),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(context.width12 / 3),
                  child: FormBuilder(
                    key: _formKey,
                    child: _isSmsAuthorized
                        ? getFormView(context)
                        : getPermissionView(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getFormView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Running on $_platformVersion',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(height: 20),
        FormBuilderTextField(
          focusNode: _focusNodePhone,
          name: 'phone',
          keyboardType: TextInputType.phone,
          autovalidateMode: AutovalidateMode.disabled,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: "Phone is required"),
            (value) => (value!.length < 15 ? "Phone invalid" : null)
          ]),
          inputFormatters: [MaskTextInputFormatter(mask: "(##) #####-####")],
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.phone, size: 36),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelText: 'Phone',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        FormBuilderTextField(
          name: 'message',
          keyboardType: TextInputType.text,
          autovalidateMode: AutovalidateMode.disabled,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: "Message is required"),
            (value) => (value!.length < 5
                ? "Message is short, minimum 5 characters "
                : null)
          ]),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.message_outlined, size: 36),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelText: 'Message',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        Visibility(
          maintainSize: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () => {
                    if (Platform.isAndroid)
                      {SystemNavigator.pop()}
                    else if (Platform.isIOS)
                      {
                        //
                      }
                  },
                  child: const Text('Finish'),
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    context.dismissKeyboard();
                    sendSms().then((value) {
                      if (value.isEmpty) {
                        context.showSnackBarMessage(
                            "Please fill the fields to send the SMS",
                            isError: true);
                      } else {
                        context.showSnackBarMessage(value);
                      }
                    });
                  },
                  child: const Text('Send'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getPermissionView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Running on $_platformVersion',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Permission.sms.toString(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Checkbox(
              value: _permission.authorized,
              checkColor: Colors.white,
              activeColor: context.primaryColor,
              onChanged: (value) async {
                await _permission.requestPermission(Permission.sms);
                setState(() {
                  _isSmsAuthorized = _permission.authorized;
                });
              },
            )
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () => {
                  if (Platform.isAndroid)
                    {SystemNavigator.pop()}
                  else if (Platform.isIOS)
                    {
                      // exit(0)
                    }
                },
                child: const Text('Finish'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
