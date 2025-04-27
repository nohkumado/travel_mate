import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:travel_mate/person.dart';
import 'package:travel_mate/simple_acl.dart';
import 'package:xml/xml.dart';

// Helper function to safely get attribute value
String? _getAttribute(XmlElement element, String name) {
  return element.getAttribute(name);
}

// Helper function to process person entries
List<Map<String, dynamic>> _processPersonEntries(XmlElement personElement) {
  final entries = <Map<String, dynamic>>[];
  for (final entryElement in personElement.findElements('entry')) {
    entries.add({
      'type': _getAttribute(entryElement, 'type') ?? 'none',
      'value': entryElement.innerText.trim(),
      'acl': _getAttribute(entryElement, 'acl') ?? 'public',
    });
  }
  return entries;
}

// Helper function to process etappe elements recursively
Map<String, dynamic> _processEtappe(XmlElement etappeElement) {
  final etappeData = <String, dynamic>{
    'name': _getAttribute(etappeElement, 'name') ?? '',
    'date': _getAttribute(etappeElement, 'date'),
    'time': _getAttribute(etappeElement, 'time'),
    'from': _getAttribute(etappeElement, 'from'),
    'to': _getAttribute(etappeElement, 'to'),
    'duration': _getAttribute(etappeElement, 'duration'),
    'type': _getAttribute(etappeElement, 'type') ?? 'simple',
  };

  final content = etappeElement.innerText.trim().split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  if (content.isNotEmpty) {
    etappeData['content'] = content;
  }

  final nestedEtapes = <String, dynamic>{};
  for (final nestedEtappeElement in etappeElement.findElements('etappe')) {
    nestedEtapes[_getAttribute(nestedEtappeElement, 'name') ?? 'unnamed'] = _processEtappe(nestedEtappeElement);
  }
  if (nestedEtapes.isNotEmpty) {
    etappeData['etapes'] = nestedEtapes;
  }

  // Extract other attributes
  etappeElement.attributes.forEach((attr) {
    if (!['name', 'date', 'time', 'from', 'to', 'duration', 'type'].contains(attr.name.local)) {
      etappeData[attr.name.local] = attr.value;
    }
  });

  return etappeData;
}

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('input', abbr: 'i', help: 'Path to the input XML file')
    ..addOption('output', abbr: 'o', help: 'Path to the output JSON file');

  final ArgResults argResults = parser.parse(arguments);

  final inputXmlFile = argResults['input'] as String?;
  final outputJsonFile = argResults['output'] as String?;

  if (inputXmlFile == null || outputJsonFile == null) {
    print('Usage: dart xml_to_json_converter.dart -i <input_xml_file> -o <output_json_file>');
    print(parser.usage);
    exit(1);
  }

  final xmlFile = File(inputXmlFile);
  if (!xmlFile.existsSync()) {
    print('Error: Input XML file "$inputXmlFile" not found.');
    exit(1);
  }

  final xmlString = xmlFile.readAsStringSync();

  final document = XmlDocument.parse(xmlString);

  final aclsElement = document.rootElement.findElements('acls').first;
  final acls = <String, SimpleAcl>{};
  for (final aclElement in aclsElement.findElements('acl')) {
    final name = _getAttribute(aclElement, 'name');
    final access = _getAttribute(aclElement, 'access');
    if (name != null && access != null) {
      acls[name] = SimpleAcl(name: name, access: access);
    }
  }

  final personsElement = document.rootElement.findElements('persons').first;
  final persons = <String, Person>{};
  for (final personElement in personsElement.findElements('person')) {
    final entriesData = _processPersonEntries(personElement);
    final nameEntry = entriesData.firstWhere((entry) => entry['type'] == 'name', orElse: () => {});
    final personName = nameEntry['value'] as String? ?? 'anonymous';
    final person = Person(incoming: {'entry': entriesData});
    persons[personName] = person;
  }

  final travelsElement = document.rootElement.findElements('travels').first;
  final travelsJson = <Map<String, dynamic>>[];
  for (final travelElement in travelsElement.findElements('travel')) {
    final etappesElement = travelElement.findElements('etappe').first;
    final etappesData = _processEtappe(etappesElement);

    final travelAttributes = <String, dynamic>{};
    travelElement.attributes.forEach((attr) {
      travelAttributes[attr.name.local] = attr.value;
    });
    travelAttributes['titre'] = travelElement.findElements('titre').firstOrNull?.innerText.trim();

    travelsJson.add({
      'attributes': travelAttributes,
      'etapes': {'root': etappesData}, // Wrap the root etappe
    });
  }

  final outputJson = {
    'acls': acls.map((key, value) => MapEntry(key, value.toJson())),
    'persons': persons.map((key, value) => MapEntry(key, value.toJson())),
    'travels': travelsJson,
  };

  final encoder = JsonEncoder.withIndent('  ');
  final prettyJson = encoder.convert(outputJson);

  final outputFile = File(outputJsonFile);
  outputFile.writeAsStringSync(prettyJson);
  //print(prettyJson);

  // To save to a file:
  // final file = File('travel_data.json');
  // await file.writeAsString(prettyJson);

  print('\nXML to JSON conversion complete!');
}