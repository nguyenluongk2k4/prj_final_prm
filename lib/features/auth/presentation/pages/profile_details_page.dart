import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  final TextEditingController _firstNameController = TextEditingController(text: 'David');
  final TextEditingController _lastNameController = TextEditingController(text: 'Peterson');
  String? _selectedDate;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1997, 9, 22),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarSimple(
        title: '',
        centerTitle: false,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset(
              'assets/icons/btn_back.svg',
              width: 52,
              height: 52,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.goNamed(AppRoutes.homeName);
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                fontFamily: 'Sk-Modernist',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFFE94057),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // Title
                const Text(
                  'Profile details',
                  style: TextStyle(
                    fontFamily: 'Sk-Modernist',
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 40),

                // Profile photo
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 99,
                        height: 99,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8E6EA),
                          borderRadius: BorderRadius.circular(25),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/profile_photo.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE94057),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 37),

                // First name input
                _buildInputField(
                  controller: _firstNameController,
                  label: 'First name',
                ),

                const SizedBox(height: 5),

                // Last name input
                _buildInputField(
                  controller: _lastNameController,
                  label: 'Last name',
                ),

                const SizedBox(height: 5),

                // Birthday input
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    height: 58,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE94057).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Color(0xFFE94057),
                            size: 18,
                          ),
                          const SizedBox(width: 17.5),
                          Text(
                            _selectedDate ?? 'Choose birthday date',
                            style: const TextStyle(
                              fontFamily: 'Sk-Modernist',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFE94057),
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 86),

                // Confirm button
                AppPrimaryButton(
                  text: 'Confirm',
                  onPressed: () {
                    context.pushNamed(AppRoutes.genderSelectionName);
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Container(
          margin: const EdgeInsets.only(left: 28),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          color: Colors.white,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Sk-Modernist',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0x66000000), // 40% opacity
              height: 1.5,
            ),
          ),
        ),
        // Input field
        Container(
          height: 58,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color(0xFFE8E6EA),
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(
              fontFamily: 'Sk-Modernist',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF000000),
              height: 1.5,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            ),
          ),
        ),
      ],
    );
  }
}
