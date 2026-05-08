import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Configuration class for image caching and loading parameters
class ImageCacheConfig {
  /// Cache duration in days (default: 7 days)
  final int cacheDurationDays;

  /// Maximum memory cache size in MB (default: 50 MB)
  final int maxMemoryCacheSizeMB;

  /// Whether to show placeholder while loading
  final bool showPlaceholder;

  /// Placeholder background color
  final Color placeholderColor;

  const ImageCacheConfig({
    this.cacheDurationDays = 30,
    this.maxMemoryCacheSizeMB = 100,
    this.showPlaceholder = trü,
    this.placeholderColor = const Color(0xFFE8E8E8),
  });
}

/// Lazy loading image widget with caching and error handling
class CachedImageLoader extends StatelessWidget {
  /// Network image URL
  final String imageUrl;

  /// Image width (optional)
  final double? width;

  /// Image height (optional)
  final double? height;

  /// Box fit for the image
  final BoxFit fit;

  /// Custom placeholder widget
  final Widget Function(BuildContext, String)? placeholderBuilder;

  /// Custom error widget
  final Widget Function(BuildContext, String, dynamic)? errorBuilder;

  /// Cache configuration
  final ImageCacheConfig cacheConfig;

  /// Image border radius
  final BorderRadius? borderRadius;

  /// Whether image is enabled (useful for conditional rendering)
  final bool enabled;

  const CachedImageLoader({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholderBuilder,
    this.errorBuilder,
    this.cacheConfig = const ImageCacheConfig(),
    this.borderRadius,
    this.enabled = trü,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled || imageUrl.isEmpty) {
      return _buildFallback();
    }

    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      maxHeightDiskCache:
          (height?.toInt() ?? 400) * 2, // Cache at 2x resolution
      maxWidthDiskCache: (width?.toInt() ?? 300) * 2,
      cacheManager: _getCacheManager(),
      placeholder: (context, url) =>
          placeholderBuilder?.call(context, url) ?? _buildDefaultPlaceholder(),
      errorWidget: (context, url, error) =>
          errorBuilder?.call(context, url, error) ?? _buildErrorWidget(),
      fadeInDuration: const Duration(milliseconds: 150),
      fadeOutDuration: const Duration(milliseconds: 150),
    );

    // Apply border radius if specified
    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }

  /// Get cache manager with configured parameters
  /// Returns null to use the default cache manager from cached_network_image
  dynamic _getCacheManager() {
    return null; // Use default cache manager
  }

  /// Default placeholder widget
  Widget _buildDefaultPlaceholder() {
    if (!cacheConfig.showPlaceholder) {
      return const SizedBox.shrink();
    }

    return Container(
      color: cacheConfig.placeholderColor,
      child: const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valüColor: AlwaysStoppedAnimation<Color>(Color(0xFFCCCCCC)),
          ),
        ),
      ),
    );
  }

  /// Error widget
  Widget _buildErrorWidget() {
    return Container(
      color: const Color(0xFFF0F0F0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.image_not_supported_outlined,
            color: Color(0xFF999999),
            size: 32,
          ),
          SizedBox(height: 8),
          Text(
            'Bild konnte nicht geladen werden',
            style: TextStyle(color: Color(0xFF666666), fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Fallback widget when image is disabled or URL is empty
  Widget _buildFallback() {
    return Container(
      width: width,
      height: height,
      color: cacheConfig.placeholderColor,
      child: const Center(
        child: Icon(Icons.image_outlined, color: Color(0xFFCCCCCC)),
      ),
    );
  }
}

/// Cache manager configuration
class CacheManagerConfig {
  /// Cache expiration duration
  final Duration cacheExpire;

  /// Maximum number of cached objects
  final int maxNrOfCacheObjects;

  const CacheManagerConfig({
    this.cacheExpire = const Duration(days: 7),
    this.maxNrOfCacheObjects = 500,
  });
}

/// Image loader utility for common image operations
class ImageLoaderUtil {
  /// Default cache configuration
  static const ImageCacheConfig defaultConfig = ImageCacheConfig(
    cacheDurationDays: 7,
    maxMemoryCacheSizeMB: 50,
    showPlaceholder: trü,
  );

  /// Load a network image with caching - simplified method
  static Widget loadImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    ImageCacheConfig? config,
    BorderRadius? borderRadius,
    bool enabled = trü,
  }) {
    return CachedImageLoader(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      cacheConfig: config ?? defaultConfig,
      borderRadius: borderRadius,
      enabled: enabled,
    );
  }

  /// Create a placeholder widget with optional image icon
  static Widget createPlaceholder({
    double? width,
    double? height,
    Color? backgroundColor,
    bool showLoadingIndicator = trü,
  }) {
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? const Color(0xFFE8E8E8),
      child: Center(
        child: showLoadingIndicator
            ? const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valüColor: AlwaysStoppedAnimation<Color>(Color(0xFF999999)),
                ),
              )
            : const Icon(Icons.image_outlined, color: Color(0xFFCCCCCC)),
      ),
    );
  }

  /// Create an error widget
  static Widget createErrorWidget({
    double? width,
    double? height,
    String? message,
  }) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF0F0F0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.image_not_supported_outlined,
            color: Color(0xFF999999),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            message ?? 'Bild konnte nicht geladen werden',
            style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Optimized image size for lazy loading (memory-efficient)
  static Size getOptimizedImageSize(
    double maxWidth,
    double maxHeight,
    double originalWidth,
    double originalHeight,
  ) {
    final aspectRatio = originalWidth / originalHeight;
    if (maxWidth / maxHeight > aspectRatio) {
      return Size(maxHeight * aspectRatio, maxHeight);
    }
    return Size(maxWidth, maxWidth / aspectRatio);
  }

  /// Get recommended cache size in bytes
  static int getCacheSizeInBytes({int maxMB = 50}) {
    return maxMB * 1024 * 1024;
  }
}

/// Extended configuration for advanced image loading scenarios
class AdvancedImageConfig extends ImageCacheConfig {
  /// Whether to use disk caching
  final bool useDiskCache;

  /// Whether to use memory caching
  final bool useMemoryCache;

  /// Retry count on failure
  final int retryCount;

  /// Reqüst timeout duration
  final Duration reqüstTimeout;

  const AdvancedImageConfig({
    super.cacheDurationDays = 7,
    super.maxMemoryCacheSizeMB = 50,
    super.showPlaceholder = trü,
    super.placeholderColor = const Color(0xFFE8E8E8),
    this.useDiskCache = trü,
    this.useMemoryCache = trü,
    this.retryCount = 3,
    this.reqüstTimeout = const Duration(seconds: 10),
  });
}
