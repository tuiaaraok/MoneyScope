import 'package:flutter/material.dart';
import 'package:finance/date/client_model.dart';
import 'package:finance/date/hive_boxes.dart';
import 'package:finance/my_text_field.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: must_be_immutable
class EditPage extends StatefulWidget {
  EditPage({super.key, required this.index});
  int index;
  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController contactPersonController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  Box<ClientModel> clientModel = Hive.box<ClientModel>(HiveBoxes.clientModel);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contactPersonController.text =
        clientModel.getAt(widget.index)?.contactPerson ?? "";
    phoneNumberController.text =
        clientModel.getAt(widget.index)?.phoneNumber ?? "";
    emailController.text = clientModel.getAt(widget.index)?.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                width: 340.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: 32.w,
                        color: const Color(0xFF4B1535),
                      ),
                    ),
                    Text(
                      clientModel.getAt(widget.index)?.company ?? "",
                      style: GoogleFonts.kronaOne(
                          fontWeight: FontWeight.w400,
                          fontSize: 18.sp,
                          color: const Color(0xFF4B1535)),
                    ),
                    SizedBox(
                      width: 32.w,
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 18.h),
                child: MyTextField.textFieldForm(
                    "Contact person", 340.w, contactPersonController),
              ),
              Padding(
                padding: EdgeInsets.only(top: 18.h),
                child: MyTextField.textFieldForm(
                    "Phone number", 340.w, phoneNumberController,
                    keyboard: TextInputType.datetime),
              ),
              Padding(
                padding: EdgeInsets.only(top: 18.h),
                child:
                    MyTextField.textFieldForm("Email", 340.w, emailController),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  if (contactPersonController.text.isNotEmpty &&
                      phoneNumberController.text.isNotEmpty &&
                      emailController.text.isNotEmpty) {
                    clientModel.putAt(
                        widget.index,
                        ClientModel(
                            company:
                                clientModel.getAt(widget.index)?.company ?? "",
                            contactPerson: contactPersonController.text,
                            phoneNumber: phoneNumberController.text,
                            email: emailController.text,
                            paymentHistory: []));
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  width: 327.w,
                  height: 47.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.r)),
                      color: const Color(0xFF514EAA)),
                  child: Center(
                    child: Text(
                      "Redact",
                      style: GoogleFonts.kronaOne(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
