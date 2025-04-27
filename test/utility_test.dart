import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path; // For platform-independent path manipulation

// Assuming your converter script is in the root of your project
final converterScript = path.join(Directory.current.path, 'bin', 'travel_xml_converter.dart');
final inputXmlFile = path.join(Directory.current.path, 'test_travel.xml');

final outputJsonFile = path.join(Directory.current.path, 'test_output.json');

void main() {
  setUpAll(() async {
    // Create the input XML file for the test
    final xmlContent = '''
    <?xml version="1.0" encoding="utf-8"?>
    <!DOCTYPE travel PUBLIC "-//LUG//DTD travel//FR" "/~bboett/dtds/travel.dtd">
    <travelhelper>
      <acls>
        <acl name="public" access="any"/>
      </acls>
      <persons>
        <person>
          <entry type="name" value="Bob Morane" acl="public"/>
        </person>
      </persons>
      <travels>
        <travel auteur="bmorane">
          <titre>Test Travel</titre>
          <etappe name="Start" type="start"/>
        </travel>
      </travels>
    </travelhelper>
    ''';
    final inputFile = File(inputXmlFile);
    await inputFile.writeAsString(xmlContent);

    // Ensure the output file doesn't exist before the test
    final outputFile = File(outputJsonFile);
    if (await outputFile.exists()) {
      await outputFile.delete();
    }
  });

  tearDownAll(() async {
    // Clean up the input and output files after the test
    final inputFile = File(inputXmlFile);
    if (await inputFile.exists()) {
      await inputFile.delete();
    }
    final outputFile = File(outputJsonFile);
    if (await outputFile.exists()) {
      await outputFile.delete();
    }
  });

  test('XML to JSON converter creates output file', () async {
    final process = await Process.run(
      'dart',
      [converterScript, '-i', inputXmlFile, '-o', outputJsonFile],
    );

    expect(process.exitCode, 0, reason: 'Converter script should exit with code 0');
    final outputFile = File(outputJsonFile);
    expect(await outputFile.exists(), isTrue, reason: 'Output JSON file should be created');

    // Optional: Add more assertions on the content of the output file
    final jsonContent = await outputFile.readAsString();
    expect(jsonContent.isNotEmpty, isTrue, reason: 'Output JSON should not be empty');
    expect(jsonContent.contains('"name": "Bob Morane"'), isTrue, reason: 'Output JSON should contain anonymized name');
    expect(jsonContent.contains('"titre": "Test Travel"'), isTrue, reason: 'Output JSON should contain travel title');
  });
}