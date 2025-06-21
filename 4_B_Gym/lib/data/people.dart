class Person {
  final int id;
  final String nama;
  final int umur;
  final String jenisKelamin;
  final String spesialis;
  final String phone;
  final String picture;
  const Person(this.id, this.nama, this.umur, this.jenisKelamin, this.spesialis,
      this.phone, this.picture);
}

final List<Person> people = _people
    .map((e) => Person(
        e['id'] as int,
        e['nama'] as String,
        e['umur'] as int,
        e['jenisKelamin'] as String,
        e['spesialis'] as String,
        e['phone'] as String,
        e['picture'] as String))
    .toList(growable: false);

final List<Map<String, Object>> _people = [
  {
    "id": 1,
    "nama": "John Doe",
    "umur": 30,
    "jenisKelamin": "Male",
    "spesialis": "Kardiologi",
    "phone": "+1 (555) 123-4567",
    "picture": "https://example.com/john_doe.jpg",
  },
  {
    "id": 2,
    "nama": "Jane Smith",
    "umur": 28,
    "jenisKelamin": "Female",
    "spesialis": "Pediatri",
    "phone": "+1 (555) 765-4321",
    "picture": "https://example.com/john_doe.jpg",
  },
  {
    "id": 3,
    "nama": "Alice Johnson",
    "umur": 35,
    "jenisKelamin": "Female",
    "spesialis": "Ginekologi",
    "phone": "+1 (555) 987-6543",
    "picture": "https://example.com/john_doe.jpg",
  },
  {
    "id": 4,
    "nama": "Thomas",
    "umur": 27,
    "jenisKelamin": "Male",
    "spesialis": "Ginekologi",
    "phone": "+1 (555) 458-1987",
    "picture": "https://example.com/john_doe.jpg",
  }
];
