import 'etappe.dart';
import 'simple_acl.dart';
import 'person.dart';

class Travel {
  final Map<String, SimpleAcl> acls;
  final Map<String, Person> participants;
  final Map<String, dynamic> attributes; // DateTime will be handled as String initially
  final Map<String, Etappe> etapes;
  final String titre;

  Travel({
    this.acls = const {},
    this.participants = const {},
    this.attributes = const {},
    this.etapes = const {},
    this.titre = 'untitled Travel',
  });

  @override
  String toString() {
    return 'Travel $titre: ACLs: $acls, Participants: $participants, Attributes: $attributes, Etapes: $etapes';
  }

  Travel addAcl(SimpleAcl acl) {
    return Travel(
      acls: {...acls, acl.name: acl},
      participants: participants,
      attributes: attributes,
      etapes: etapes,
      titre: titre,
    );
  }

  Travel addPerson(Person person) {
    return Travel(
      acls: acls,
      participants: {...participants, person.name(): person}, // Corrected line
      attributes: attributes,
      etapes: etapes,
      titre: titre,
    );
  }


  // In Flutter, 'read' logic will likely be part of the data loading process
  // from a local file or API. We'll handle JSON parsing in fromJson.

  Map<String, dynamic> toJson() {
    return {
      'acls': acls.map((key, acl) => MapEntry(key, acl.toJson())),
      'participants': participants.map((key, person) => MapEntry(key, person.toJson())),
      'attributes': attributes, // Dates will be strings
      'etapes': etapes.map((key, etappe) => MapEntry(key, etappe.toJson())),
      'titre': titre,
    };
  }

  factory Travel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? jsonAcls = json['acls'] as Map<String, dynamic>?;
    final Map<String, dynamic>? jsonParticipants = json['participants'] as Map<String, dynamic>?;
    final Map<String, dynamic>? jsonEtapes = json['etapes'] as Map<String, dynamic>?;

    return Travel(
      acls: jsonAcls?.map((key, aclJson) => MapEntry(key, SimpleAcl.fromJson(aclJson as Map<String, dynamic>))) ?? {},
      participants: jsonParticipants?.map((key, personJson) => MapEntry(key, Person.fromJson(personJson as Map<String, dynamic>))) ?? {},
      attributes: json['attributes'] as Map<String, dynamic>? ?? {},
      etapes: jsonEtapes?.map((key, etappeJson) => MapEntry(key, Etappe.fromJson(etappeJson as Map<String, dynamic>))) ?? {},
      titre: json['titre'] as String? ?? 'untitled Travel',
    );
  }

  List<String> listTravels() {
    return etapes.keys.toList();
  }

  String title() {
    return titre;
  }

  // 'id()' will depend on how it's stored in your JSON data
  int? id() {
    return attributes['id'] as int?;
  }

// toHtml() is UI-specific and will be built using Flutter widgets
}