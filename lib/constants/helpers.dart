String getOptimizedUrl(String originalUrl, int width) {
  if (originalUrl.contains('ik.imagekit.io')) {
    return '$originalUrl?tr=w-$width';
  }
  return originalUrl;
}
