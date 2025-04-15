import 'package:finance/date/client_model.dart';
import 'package:finance/date/hive_boxes.dart';
import 'package:finance/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddClientPage extends StatefulWidget {
  const AddClientPage({super.key});

  @override
  State<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  TextEditingController companyController = TextEditingController();
  TextEditingController contactPersonController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  Box<ClientModel> clientModel = Hive.box<ClientModel>(HiveBoxes.clientModel);

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
                      "Add a client",
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
                    "Company", 340.w, companyController),
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
                  if (companyController.text.isNotEmpty &&
                      contactPersonController.text.isNotEmpty &&
                      phoneNumberController.text.isNotEmpty &&
                      emailController.text.isNotEmpty) {
                    clientModel.add(ClientModel(
                        company: companyController.text,
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
                      "Save",
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
