part of 'app.dart';

Stream<LicenseEntry> _addLicenses() {
  late final StreamController<LicenseEntry> controller;
  controller = StreamController<LicenseEntry>(
    onListen: () async {
      const licenses = [
        LicenseEntryWithLineBreaks(
          ['Image Data Service'],
          '''
          Unsplash API is used in the image search feature. Please visit https://unsplash.com/license to view the full license.
          
          Picsum API is used for the images displayed on the /pictures screen. Please visit https://github.com/DMarby/picsum-photos/blob/main/LICENSE.md for full license.
          ''',
        ),
        LicenseEntryWithLineBreaks(
          ['App Icon'],
          'Hexagon icons created by Freepik - Flaticon: https://www.flaticon.com/free-icons/hexagon',
        ),
      ];
      licenses.forEach(controller.add);
      await controller.close();
    },
  );
  return controller.stream;
}
