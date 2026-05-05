class UserNook {
  final String uid;
  final String email;
  final String nome;
  final String cognome;
  final String dataDiNascita;
  final String genere;

  UserNook({
    required this.uid,
    required this.email,
    required this.nome,
    required this.cognome,
    required this.dataDiNascita,
    required this.genere,
  });

  factory UserNook.fromMap(Map<String, dynamic> map, String emailDoc) {
    return UserNook(
      uid: map['UID'] ?? '',
      email: emailDoc,
      nome: map['nome'] ?? '',
      cognome: map['cognome'] ?? '',
      dataDiNascita: map['dataDiNascita'] ?? '',
      genere: map['genere'] ?? '',
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'UID': uid,
      'nome': nome,
      'cognome': cognome,
      'dataDiNascita': dataDiNascita,
      'genere': genere,

    };
  }
}