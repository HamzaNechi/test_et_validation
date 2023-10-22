class Therapy {
  final String id;
  final String image;
  final String titre;
  final String date;
  final String address;
  final String description;
  final String type;
  final String roomName;
  late int capacity;

  Therapy(
      this.id, this.image, this.titre, this.date, this.address,this.description, this.type,this.roomName,dynamic capacity)
      : capacity = capacity is int ? capacity : int.tryParse(capacity) ?? 0;

  Therapy.rania(this.titre, this.id, this.image, this.date, this.address, this.description, this.type, this.roomName);

  setCapacity(int newCapacity) {
    capacity = newCapacity;
  }
}
