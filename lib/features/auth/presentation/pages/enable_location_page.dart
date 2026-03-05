import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../stores/auth_store.dart';

class EnableLocationPage extends StatefulWidget {
  const EnableLocationPage({super.key});

  @override
  State<EnableLocationPage> createState() => _EnableLocationPageState();
}

class _EnableLocationPageState extends State<EnableLocationPage> {
  bool _isLoading = false;

  Future<void> _requestLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng bật GPS (Dịch vụ vị trí) trên thiết bị của bạn trước!'),
            backgroundColor: Colors.red,
          ),
        );
        return; // Don't proceed if GPS is off, they must turn it on
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Quyền vị trí đã bị từ chối vĩnh viễn. Vui lòng cấp quyền trong Cài đặt ứng dụng.'),
            backgroundColor: Colors.red,
          ),
        );
        return; // Give them a second to realize what happened
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
        );
        
        final authStore = getIt<AuthStore>();
        await authStore.updateLocation(
          latitude: position.latitude, 
          longitude: position.longitude,
        );
      }

      if (!mounted) return;

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        context.pushNamed(AppRoutes.friendsName); // Move to next screen only if allowed
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showSkipButton: true,
      onSkip: () => context.pushNamed(AppRoutes.friendsName), // Navigate to next step
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 104),
          
          // Icon placeholder (reusing UI style from notifications)
          Center(
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: context.appColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on,
                size: 80,
                color: context.appColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 64),

          // Title and description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Enable Location',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h2,
                ),
                const SizedBox(height: 12),
                Text(
                  'You\'ll need to enable your location in order to use this app and find matches nearby.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: context.appColors.text70,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Allow Location Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: AppPrimaryButton(
              text: 'Allow Location',
              isLoading: _isLoading,
              onPressed: _requestLocation,
            ),
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
