// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/.gitkeep
  String get aGitkeep => 'assets/icons/.gitkeep';

  /// File path: assets/icons/btn_back.svg
  SvgGenImage get btnBack => const SvgGenImage('assets/icons/btn_back.svg');

  /// File path: assets/icons/camera.svg
  SvgGenImage get camera => const SvgGenImage('assets/icons/camera.svg');

  /// File path: assets/icons/game_handle.svg
  SvgGenImage get gameHandle =>
      const SvgGenImage('assets/icons/game_handle.svg');

  /// File path: assets/icons/goblet.svg
  SvgGenImage get goblet => const SvgGenImage('assets/icons/goblet.svg');

  /// File path: assets/icons/music.svg
  SvgGenImage get music => const SvgGenImage('assets/icons/music.svg');

  /// File path: assets/icons/noodles.svg
  SvgGenImage get noodles => const SvgGenImage('assets/icons/noodles.svg');

  /// File path: assets/icons/outdoor.svg
  SvgGenImage get outdoor => const SvgGenImage('assets/icons/outdoor.svg');

  /// File path: assets/icons/parachute.svg
  SvgGenImage get parachute => const SvgGenImage('assets/icons/parachute.svg');

  /// File path: assets/icons/platte.svg
  SvgGenImage get platte => const SvgGenImage('assets/icons/platte.svg');

  /// File path: assets/icons/ripple.svg
  SvgGenImage get ripple => const SvgGenImage('assets/icons/ripple.svg');

  /// File path: assets/icons/shopping.svg
  SvgGenImage get shopping => const SvgGenImage('assets/icons/shopping.svg');

  /// File path: assets/icons/sport.svg
  SvgGenImage get sport => const SvgGenImage('assets/icons/sport.svg');

  /// File path: assets/icons/tennis.svg
  SvgGenImage get tennis => const SvgGenImage('assets/icons/tennis.svg');

  /// File path: assets/icons/voice.svg
  SvgGenImage get voice => const SvgGenImage('assets/icons/voice.svg');

  /// File path: assets/icons/yoga.svg
  SvgGenImage get yoga => const SvgGenImage('assets/icons/yoga.svg');

  /// List of all assets
  List<dynamic> get values => [
    aGitkeep,
    btnBack,
    camera,
    gameHandle,
    goblet,
    music,
    noodles,
    outdoor,
    parachute,
    platte,
    ripple,
    shopping,
    sport,
    tennis,
    voice,
    yoga,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/.gitkeep
  String get aGitkeep => 'assets/images/.gitkeep';

  /// File path: assets/images/apple_icon.svg
  SvgGenImage get appleIcon =>
      const SvgGenImage('assets/images/apple_icon.svg');

  /// File path: assets/images/dot_active.svg
  SvgGenImage get dotActive =>
      const SvgGenImage('assets/images/dot_active.svg');

  /// File path: assets/images/dot_inactive.svg
  SvgGenImage get dotInactive =>
      const SvgGenImage('assets/images/dot_inactive.svg');

  /// File path: assets/images/facebook_icon.svg
  SvgGenImage get facebookIcon =>
      const SvgGenImage('assets/images/facebook_icon.svg');

  /// File path: assets/images/google_icon.svg
  SvgGenImage get googleIcon =>
      const SvgGenImage('assets/images/google_icon.svg');

  /// File path: assets/images/logo.svg
  SvgGenImage get logo => const SvgGenImage('assets/images/logo.svg');

  /// File path: assets/images/onboarding_1.png
  AssetGenImage get onboarding1 =>
      const AssetGenImage('assets/images/onboarding_1.png');

  /// File path: assets/images/onboarding_2.png
  AssetGenImage get onboarding2 =>
      const AssetGenImage('assets/images/onboarding_2.png');

  /// File path: assets/images/onboarding_3.png
  AssetGenImage get onboarding3 =>
      const AssetGenImage('assets/images/onboarding_3.png');

  /// File path: assets/images/profile_photo.png
  AssetGenImage get profilePhoto =>
      const AssetGenImage('assets/images/profile_photo.png');

  /// List of all assets
  List<dynamic> get values => [
    aGitkeep,
    appleIcon,
    dotActive,
    dotInactive,
    facebookIcon,
    googleIcon,
    logo,
    onboarding1,
    onboarding2,
    onboarding3,
    profilePhoto,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
