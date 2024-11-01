import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'image_page.dart'; // เพิ่มบรรทัดนี้

class AcneLevelsPage extends StatelessWidget {
  final String acneLevel;

  const AcneLevelsPage({super.key, required this.acneLevel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Acne Levels',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(33, 150, 243, 0.8),
                Color.fromRGBO(33, 150, 243, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(33, 150, 243, 0.1),
              Color.fromRGBO(33, 150, 243, 0.2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'สิวสามารถแบ่งออกเป็น 6 ระดับตามความรุนแรง ได้แก่:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildAcneLevelDetails(acneLevel),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ImagePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Color.fromRGBO(33, 150, 243, 1),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side:
                            BorderSide(color: Color.fromRGBO(33, 150, 243, 1)),
                      ),
                      elevation: 6,
                    ).copyWith(
                      shadowColor: MaterialStateProperty.all(
                        Color.fromRGBO(33, 150, 243, 0.4),
                      ),
                    ),
                    child: const Text(
                      'Analyze Another Image',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildContactInfo(acneLevel),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAcneLevelDetails(String level) {
    switch (level) {
      case 'Mild Acne':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'การรักษาสิวเล็กน้อย (Mild Acne):\n'
              'สามารถใช้ยาทาเฉพาะที่ เช่น ยาที่มีส่วนประกอบของสารต่าง ๆ ดังนี้:\n'
              '1. สบู่ล้างหน้า L soap\n'
              '2. ยาทา Benzoly peroxide 2.5%-5%\n'
              '3. Ance cream or ance lotion\n'
              '4. Topical retinoids 0.01%-0.1%',
              style: TextStyle(fontSize: 16),
            ),
          ],
        );
      case 'Moderate Acne':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'การรักษาสิวปานกลาง (Moderate Acne):\n'
              'จะพิจารณาให้ยาทาในกลุ่ม mild acne ร่วมกับยารับประทาน ดังนี้:\n'
              '1. สบู่ล้างหน้า L soap\n'
              '2. ยาทา Benzoly peroxide 2.5%-5%\n'
              '3. Ance cream or ance lotion\n'
              '4. Topical retinoids 0.01%-0.1%\n'
              '5. Differine\n'
              '6. ยารับประทาน Doxycycline',
              style: TextStyle(fontSize: 16),
            ),
          ],
        );
      case 'Severe Acne':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'การรักษาสิวรุนแรง (Severe Acne):\n'
              'ในกรณีที่การรักษาไม่ตอบสนอง หรือมีความรุนแรงขึ้นควรปรึกษาแพทย์ผู้เชี่ยวชาญโรคผิวหนัง ดังนี้:\n'
              '1. สบู่ล้างหน้า L soap\n'
              '2. ยาทา Benzoly peroxide 2.5%-5%\n'
              '3. Ance cream or ance lotion\n'
              '4. Topical retinoids 0.01%-0.1%\n'
              '5. Differine\n'
              '6. ยารับประทาน Isotretinoin',
              style: TextStyle(fontSize: 16),
            ),
          ],
        );
      default:
        return const Text('ไม่สามารถระบุระดับสิวได้',
            style: TextStyle(fontSize: 16));
    }
  }

  Widget _buildContactInfo(String level) {
    final bool isSevere = level == 'Severe Acne' || level == 'Less Severe Acne';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ระบบการแพทย์ทางไกล:\n'
          'กับโรงพยาบาลโรคผิวหนังเขตร้อนภาคใต้จังหวัดตรัง\n',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0), // ปรับระยะห่างด้านล่าง
          child: ElevatedButton(
            onPressed: () async {
              final Uri url =
                  Uri.parse('https://page.line.me/kxb2834g?openQrModal=true');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                // Handle the error
                throw 'Could not launch $url';
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isSevere ? Colors.red : Colors.transparent,
              foregroundColor:
                  isSevere ? Colors.white : Color.fromRGBO(33, 150, 243, 1),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                    color: isSevere
                        ? Colors.red
                        : Color.fromRGBO(33, 150, 243, 1)),
              ),
              elevation: 6,
            ).copyWith(
              shadowColor: MaterialStateProperty.all(
                isSevere
                    ? Colors.red.withOpacity(0.4)
                    : Color.fromRGBO(33, 150, 243, 0.4),
              ),
            ),
            child: const Text(
              'รับการรักษาทางไกล',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
