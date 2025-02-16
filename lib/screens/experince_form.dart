import 'package:flutter/material.dart';

void main() {
  runApp(ExperienceFormApp());
}

class ExperienceFormApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExperienceFormPage(),
    );
  }
}

class ExperienceFormPage extends StatefulWidget {
  @override
  _ExperienceFormPageState createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  bool isCurrentlyWorking = true;
  String? selectedEmploymentType;
  DateTime? startDate;
  DateTime? endDate;

  final List<String> employmentTypes = [
    'Tam Zamanlı',
    'Yarı Zamanlı',
    'Serbest Çalışan',
    'Sözleşmeli',
    'Stajyer',
  ];

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime initialDate = isStartDate
        ? (startDate ?? DateTime.now())
        : (endDate ?? DateTime.now());

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {},
        ),
        title: Text(
          'Deneyim Ekle',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(
              height: 40,
              child: TextField(decoration: inputDecoration('Başlık*')),
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: DropdownButtonFormField<String>(
                decoration: inputDecoration('İstihdam Türü'),
                value: selectedEmploymentType,
                items: employmentTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedEmploymentType = value;
                  });
                },
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: TextField(
                  decoration: inputDecoration('Şirket veya Kuruluş*')),
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: TextField(decoration: inputDecoration('Konum')),
            ),
            SizedBox(height: 12),
            CheckboxListTile(
              title: Text("Şu an bu pozisyonda çalışıyorum"),
              value: isCurrentlyWorking,
              onChanged: (value) {
                setState(() {
                  isCurrentlyWorking = value!;
                });
              },
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      readOnly: true,
                      controller: TextEditingController(
                          text: startDate != null
                              ? "${startDate!.day}/${startDate!.month}/${startDate!.year}"
                              : ""),
                      decoration: inputDecoration('Başlama Tarihi*'),
                      onTap: () => _selectDate(context, true),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                if (!isCurrentlyWorking)
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        readOnly: true,
                        controller: TextEditingController(
                            text: endDate != null
                                ? "${endDate!.day}/${endDate!.month}/${endDate!.year}"
                                : ""),
                        decoration: inputDecoration('Bitiş Tarihi*'),
                        onTap: () => _selectDate(context, false),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  fixedSize: Size(150, 40),
                ),
                child: Text('Kaydet',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
