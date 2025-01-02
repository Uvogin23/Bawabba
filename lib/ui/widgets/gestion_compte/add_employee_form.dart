import 'dart:convert';
import 'package:bawabba/core/services/config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:window_manager/window_manager.dart';
import 'package:bawabba/core/services/card_stats.dart';
import 'package:bawabba/core/models/user.dart';
import 'package:bawabba/core/services/auth_provider.dart';
import 'package:bawabba/main.dart';
import 'package:provider/provider.dart';

enum Role {
  admin,
  operator,
}

enum Grade { ap, bp, bcp, ip, ipp, op, opp, cp, cpp, cdp, cnp, cnpp }

class AddEmployeeForm extends StatefulWidget {
  const AddEmployeeForm({Key? key}) : super(key: key);

  @override
  State<AddEmployeeForm> createState() => _AddEmployeeForm();
}

class _AddEmployeeForm extends State<AddEmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _badgeNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  Role? selectedRole;
  Grade? selectedGrade;

  bool _isLoading = false;
  String? _errorMessage;

  void _clearForm() {
    _formKey.currentState?.reset(); // Reset the form state
    _usernameController.clear(); // Clear the name field
    _firstNameController.clear();
    _lastNameController.clear();
    _badgeNumberController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      selectedRole = null;
      selectedGrade = null; // Clear the dropdown selection
    });
  }

  Future<void> _addemployee() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final url =
        Uri.parse('${Config.baseUrl}/add_employee'); // Your API endpoint
    try {
      print(selectedRole?.name);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
          'role': selectedRole?.name,
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'grade': selectedGrade?.name,
          'badge_number': _badgeNumberController.text,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تمت إضافة المستخدم بنجاح')),
        );
      } else {
        setState(() {
          _errorMessage =
              'الموظف موجود بقاعدة البيانات \n غير اسم المستخدم او رقم الذاتية ';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  ' الموظف موجود بقاعدة البيانات \n قم بتغيير اسم المستخدم او رقم الذاتية ')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error connecting to the server';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error connecting to the server')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.775,
      height: 500,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 251, 252, 252),
        border: Border.all(color: Color.fromARGB(255, 76, 77, 78), width: 1),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Icon(
            Icons.group_add_outlined,
            size: 50,
            color: Color.fromARGB(255, 13, 63, 89),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'إضافة مستخدم جديد',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromARGB(255, 13, 63, 89),
                fontFamily: 'Times New Roman',
                fontSize: 16,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.bold,
                height: 1),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: 350,
                          child: TextFormField(
                            controller: _firstNameController,
                            maxLines: 1,
                            maxLength: 12,
                            decoration: const InputDecoration(
                                hintText: 'الإسم ',
                                prefixIcon: Icon(Icons.abc),
                                fillColor: Color.fromARGB(255, 231, 231, 231),
                                filled: true),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال الإسم  ';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: 350,
                          child: TextFormField(
                            controller: _lastNameController,
                            maxLines: 1,
                            maxLength: 12,
                            decoration: const InputDecoration(
                                hintText: 'اللقب ',
                                prefixIcon: Icon(Icons.abc_sharp),
                                fillColor: Color.fromARGB(255, 231, 231, 231),
                                filled: true),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال اللقب ';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: 350,
                          child: TextFormField(
                            controller: _usernameController,
                            maxLines: 1,
                            maxLength: 12,
                            decoration: const InputDecoration(
                              hintText: 'إسم المستخدم',
                              prefixIcon: Icon(Icons.person),
                              fillColor: Color.fromARGB(255, 231, 231, 231),
                              filled: true,
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال إسم المستخدم';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: 300,
                          child: TextFormField(
                            controller: _badgeNumberController,
                            maxLines: 1,
                            maxLength: 12,
                            decoration: const InputDecoration(
                                hintText: 'رقم الذاتية',
                                prefixIcon: Icon(Icons.numbers),
                                fillColor: Color.fromARGB(255, 231, 231, 231),
                                filled: true),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال رقم الذاتية';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: 300,
                          child: TextFormField(
                            controller: _passwordController,
                            maxLines: 1,
                            maxLength: 20,
                            obscureText: true,
                            decoration: const InputDecoration(
                                hintText: ' كلمة المرور',
                                prefixIcon: Icon(Icons.lock),
                                fillColor: Color.fromARGB(255, 246, 249, 250),
                                filled: true),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال كلمة المرور';
                              }
                              if (value.length < 6) {
                                return 'كلمة المرور يجب أن تكون مكونة من 06 حروف على الأقل';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: 300,
                          child: TextFormField(
                            controller: _confirmPasswordController,
                            maxLines: 1,
                            maxLength: 20,
                            obscureText: true,
                            decoration: const InputDecoration(
                                hintText: 'تأكيد كلمة المرور',
                                prefixIcon: Icon(Icons.lock),
                                fillColor: Color.fromARGB(255, 246, 249, 250),
                                filled: true),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى تأكيد كلمة المرور';
                              }
                              if (value != _passwordController.text) {
                                return 'كلمة المرور غير مطابقة';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: 280,
                          child: DropdownButtonFormField<Grade>(
                            isExpanded: false,
                            isDense: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.abc),
                              fillColor: Color.fromARGB(255, 231, 231, 231),
                              hintText: "الرتبة",
                              filled: true,
                            ),
                            value: selectedGrade,
                            onChanged: (Grade? newValu) {
                              setState(() {
                                selectedGrade = newValu;
                              });
                            },
                            items: Grade.values.map((Grade grade) {
                              return DropdownMenuItem<Grade>(
                                value: grade,
                                child: (grade.name == 'ap')
                                    ? const Text('عون شرطة')
                                    : (grade.name == 'bp')
                                        ? const Text('حافظ شرطة')
                                        : (grade.name == 'bcp')
                                            ? const Text('حافظ أول للشرطة')
                                            : (grade.name == 'ip')
                                                ? const Text('مفتش شرطة')
                                                : (grade.name == 'ipp')
                                                    ? const Text(
                                                        'مفتش رئيسي للشرطة')
                                                    : (grade.name == 'op')
                                                        ? const Text(
                                                            'ضابط شرطة')
                                                        : (grade.name == 'opp')
                                                            ? const Text(
                                                                'ضابط شرطة رئيسي')
                                                            : (grade.name ==
                                                                    'cp')
                                                                ? const Text(
                                                                    'محافظ شرطة')
                                                                : (grade.name ==
                                                                        'cpp')
                                                                    ? const Text(
                                                                        'عميد شرطة')
                                                                    : (grade.name ==
                                                                            'cdp')
                                                                        ? const Text(
                                                                            'عميد أول للشرطة')
                                                                        : (grade.name ==
                                                                                'cnp')
                                                                            ? const Text('مراقب شرطة')
                                                                            : const Text('مراقب أول للشرطة'),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null) {
                                return "يرجى إدخال الرتبة";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: 280,
                          child: DropdownButtonFormField<Role>(
                            isExpanded: false,
                            isDense: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.folder_shared),
                              fillColor: Color.fromARGB(255, 231, 231, 231),
                              hintText: "الدور",
                              filled: true,
                            ),
                            value: selectedRole,
                            onChanged: (Role? newValue) {
                              setState(() {
                                selectedRole = newValue;
                              });
                            },
                            items: Role.values.map((Role role) {
                              return DropdownMenuItem<Role>(
                                value: role,
                                child: role.name == 'admin'
                                    ? const Text('مشرف')
                                    : const Text('مستخدم'),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null) {
                                return "يرجى إدخال الدور";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          const SizedBox(height: 20),
          if (_errorMessage != null) ...[
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 10),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 224, 232, 235),
                  elevation: 5,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // All validations passed
                    _isLoading ? null : _addemployee();
                  }
                },
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('إضافة حساب'),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: _clearForm, // Call the clear function
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 224, 232, 235),
                  elevation: 5,
                ),
                child: const Text("مسح الإستمارة"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
