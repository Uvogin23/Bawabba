import 'dart:convert';
import 'package:bawabba/core/models/employee.dart';
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

Future<List<Employee>> fetchemployees() async {
  final response = await http
      .get(Uri.parse('http://127.0.0.1:5000/get_all_users_employees'));

  if (response.statusCode == 200) {
    try {
      List<dynamic> data = json.decode(response.body);

      List<Employee> list = data
          .map((item) => Employee.fromJson(item as Map<String, dynamic>))
          .toList();
      return list;
    } catch (e) {
      print('Error parsing employees: $e');
      rethrow; // Re-throw the exception for handling elsewhere
    }
  } else {
    throw Exception('Failed to load employees: ${response.statusCode}');
  }
}

class EmployeeTable extends StatefulWidget {
  const EmployeeTable({Key? key}) : super(key: key);

  @override
  State<EmployeeTable> createState() => _EmployeeTable();
}

class _EmployeeTable extends State<EmployeeTable> {
  late Future<List<Employee>> employeesFuture;
  late List<Employee> employees;
  bool isAscending = true;
  int? sortColumnIndex;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  Role? selectedRole;
  Grade? selectedGrade;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    employeesFuture = fetchemployees();
  }

  void sortData(int columnIndex, bool ascending) {
    setState(() {
      isAscending = ascending;
      sortColumnIndex = columnIndex;
      if (columnIndex == 0) {
        employees.sort(
            (a, b) => ascending ? a.id.compareTo(b.id) : b.id.compareTo(a.id));
      } else if (columnIndex == 1) {
        employees.sort((a, b) => ascending
            ? a.firstName.compareTo(b.firstName)
            : b.firstName.compareTo(a.firstName));
      } else if (columnIndex == 2) {
        employees.sort((a, b) => ascending
            ? a.lastName.compareTo(b.lastName)
            : b.lastName.compareTo(a.lastName));
      }
    });
  }

  void editEmployee(int id) {
    // Show the Edit Employee popup dialog
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("تعديل المعلومات"),
          content: Container(
            height: 350,
            width: 500,
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
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
                          return null; // No error if the field is empty
                        }
                        // Perform additional validation if the field is not empty
                        if (value.length < 6) {
                          return 'كلمة المرور يجب أن تحتوي على 6 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
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
                        if (value != _passwordController.text) {
                          return 'كلمة المرور غير مطابقة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField<Grade>(
                      isExpanded: false,
                      isDense: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.abc),
                        fillColor: Color.fromARGB(255, 246, 249, 250),
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
                                              ? const Text('مفتش رئيسي للشرطة')
                                              : (grade.name == 'op')
                                                  ? const Text('ضابط شرطة')
                                                  : (grade.name == 'opp')
                                                      ? const Text(
                                                          'ضابط شرطة رئيسي')
                                                      : (grade.name == 'cp')
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
                                                                      ? const Text(
                                                                          'مراقب شرطة')
                                                                      : const Text(
                                                                          'مراقب أول للشرطة'),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return "يرجى إدخال الرتبة";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    employees.firstWhere((emp) => emp.id == id).username !=
                            user?.username
                        ? DropdownButtonFormField<Role>(
                            isExpanded: false,
                            isDense: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.folder_shared),
                              fillColor: Color.fromARGB(255, 246, 249, 250),
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
                          )
                        : const SizedBox(
                            height: 10,
                          )
                  ],
                )),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clearForm();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_passwordController.text.isEmpty &&
                    _confirmPasswordController.text.isEmpty &&
                    selectedRole == null &&
                    selectedGrade == null) {
                  // Show error if all fields are empty
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("يجب ملأ خانة واحدة على الأقل ")),
                  );
                } else {
                  _isLoading ? null : _updateEmployee(id);
                  // Form is valid
                }
                // Close the dialog
              },
              child: const Text("حفظ"),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    _formKey.currentState?.reset(); // Reset the form state
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      selectedRole = null;
      selectedGrade = null; // Clear the dropdown selection
    });

    // Clear the email field
  }

  void _updateEmployee(int id) async {
    final String apiUrl = 'http://127.0.0.1:5000/update_employee/$id';

    // Create a map for the fields to update
    Map<String, dynamic> data = {};
    if (selectedRole != null) data['role'] = selectedRole?.name;
    if (selectedGrade != null) data['grade'] = selectedGrade?.name;
    if (_passwordController.text != '')
      data['password'] = _passwordController.text;

    // Ensure there's data to send
    if (data.isEmpty) {
      throw Exception(' إملأ الخانات');
    }
    print(jsonEncode(data));
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      // Handle the response
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث المعلومات بنجاح')),
        );
      } else if (response.statusCode == 404) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('مستخدم غير موجود')),
        );
        throw Exception("'مستخدم غير موجود'");
      } else if (response.statusCode == 400) {
        throw Exception("No fields to update!");
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating employee: ${response.body}')),
        );
        throw Exception("Error updating employee: ${response.body}");
      }
    } catch (e) {
      throw Exception("Failed to update employee: $e");
    }

    /* Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(id.toString())),
    );*/
  }

  void deleteEmployee(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("حذف المستخدم"),
          content: Container(
              height: 50,
              width: 200,
              child: Text('إضغط على تأكيد لحذف المستخدم')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteEmployee(id);
              },
              child: const Text("تأكيد"),
            ),
          ],
        );
      },
    );
    /*setState(() {
      employees.removeWhere((employee) => employee.id == id);
    });*/
  }

  void _deleteEmployee(int id) async {
    final String apiUrl = 'http://127.0.0.1:5000/delete_user/$id';

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        setState(() {
          employees.removeWhere((employee) => employee.id == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم حذف المستخدم بنجاح')),
        );
      } else if (response.statusCode == 404) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('مستخدم غير موجود')),
        );
        throw Exception("مستخدم غير موجود");
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error : ${response.body}')),
        );
        throw Exception("Error  ${response.body}");
      }
    } catch (e) {
      throw Exception("Failed to delete employee: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    return Container(
      width: 1150,
      height: 450,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 252, 251, 251),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.only(right: 0),
            child: Icon(
              Icons.list_alt_rounded,
              size: 50,
              color: Color.fromARGB(255, 13, 63, 89),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.only(right: 0),
            child: const Text(
              'تسيير المستخدمين',
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
          ),
          const SizedBox(
            height: 30,
          ),
          FutureBuilder<List<Employee>>(
            future: employeesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("لا يوجد مستخدمين"));
              } else {
                employees = snapshot.data!;
                return Expanded(
                    child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columnSpacing: 80.0,
                    headingRowHeight: 40.0,
                    headingRowColor: WidgetStateProperty.resolveWith(
                        (states) => const Color.fromARGB(255, 185, 222, 230)),
                    sortColumnIndex: sortColumnIndex,
                    sortAscending: isAscending,
                    columns: [
                      DataColumn(
                        label: const Text("الرقم"),
                        onSort: (columnIndex, ascending) {
                          sortData(columnIndex, ascending);
                        },
                      ),
                      DataColumn(
                        label: const Text("الإسم"),
                        onSort: (columnIndex, ascending) {
                          sortData(columnIndex, ascending);
                        },
                      ),
                      DataColumn(
                        label: const Text("اللقب"),
                        onSort: (columnIndex, ascending) {
                          sortData(columnIndex, ascending);
                        },
                      ),
                      const DataColumn(
                        label: Text("رقم الذاتية"),
                      ),
                      const DataColumn(
                        label: Text("إسم المستخدم"),
                      ),
                      const DataColumn(
                        label: Text("الرتبة"),
                      ),
                      const DataColumn(
                        label: Text("الدور"),
                      ),
                      const DataColumn(
                        label: Text(""),
                      ),
                    ],
                    rows: employees.map((employee) {
                      return DataRow(
                        color: employee.username == user?.username
                            ? WidgetStateProperty.all(const Color.fromARGB(
                                255, 144, 151, 165)) // Highlight color
                            : WidgetStateProperty.all(Colors.transparent),
                        cells: [
                          DataCell(Text(employee.employeeId.toString())),
                          DataCell(Text(employee.firstName)),
                          DataCell(Text(employee.lastName)),
                          DataCell(Text(employee.badgeNumber)),
                          DataCell(Text(employee.username)),
                          DataCell(
                            (employee.grade == 'ap')
                                ? const Text('عون شرطة')
                                : (employee.grade == 'bp')
                                    ? const Text('حافظ شرطة')
                                    : (employee.grade == 'bcp')
                                        ? const Text('حافظ أول للشرطة')
                                        : (employee.grade == 'ip')
                                            ? const Text('مفتش شرطة')
                                            : (employee.grade == 'ipp')
                                                ? const Text(
                                                    'مفتش رئيسي للشرطة')
                                                : (employee.grade == 'op')
                                                    ? const Text('ضابط شرطة')
                                                    : (employee.grade == 'opp')
                                                        ? const Text(
                                                            'ضابط شرطة رئيسي')
                                                        : (employee.grade ==
                                                                'cp')
                                                            ? const Text(
                                                                'محافظ شرطة')
                                                            : (employee.grade ==
                                                                    'cpp')
                                                                ? const Text(
                                                                    'عميد شرطة')
                                                                : (employee.grade ==
                                                                        'cdp')
                                                                    ? const Text(
                                                                        'عميد أول للشرطة')
                                                                    : (employee.grade ==
                                                                            'cnp')
                                                                        ? const Text(
                                                                            'مراقب شرطة')
                                                                        : const Text(
                                                                            'مراقب أول للشرطة'),
                          ),
                          DataCell(employee.role == 'admin'
                              ? const Text("مشرف")
                              : const Text("مستخدم")),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      editEmployee(employee.employeeId),
                                ),
                                employee.username == user?.username
                                    ? IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content:
                                                    const Text('عملية ممنوعة')),
                                          );
                                        })
                                    : IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () =>
                                            deleteEmployee(employee.id),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ));
              }
            },
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
