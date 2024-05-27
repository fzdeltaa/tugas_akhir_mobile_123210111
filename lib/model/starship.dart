class StarshipsResult {
  final int? count;
  final String? next;
  final String? previous;
  final List<Starship>? starships;

  StarshipsResult({
    this.count,
    this.next,
    this.previous,
    this.starships,
  });

  StarshipsResult.fromJson(Map<String, dynamic> json)
      : count = json['count'] as int?,
        next = json['next'] as String?,
        previous = json['previous'] as String?,
        starships = (json['results'] as List?)?.map((dynamic e) => Starship.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'count' : count,
    'next' : next,
    'previous' : previous,
    'results' : starships?.map((e) => e.toJson()).toList()
  };
}

class Starship {
  final String? name;
  final String? model;
  final String? manufacturer;
  final String? costInCredits;
  final String? length;
  final String? maxAtmospheringSpeed;
  final String? crew;
  final String? passengers;
  final String? cargoCapacity;
  final String? consumables;
  final String? hyperdriveRating;
  final String? mGLT;
  final String? starshipClass;
  final List<String>? pilots;
  final List<String>? films;
  final String? created;
  final String? edited;
  final String? url;

  Starship({
    this.name,
    this.model,
    this.manufacturer,
    this.costInCredits,
    this.length,
    this.maxAtmospheringSpeed,
    this.crew,
    this.passengers,
    this.cargoCapacity,
    this.consumables,
    this.hyperdriveRating,
    this.mGLT,
    this.starshipClass,
    this.pilots,
    this.films,
    this.created,
    this.edited,
    this.url,
  });

  Starship.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        model = json['model'] as String?,
        manufacturer = json['manufacturer'] as String?,
        costInCredits = json['cost_in_credits'] as String?,
        length = json['length'] as String?,
        maxAtmospheringSpeed = json['max_atmosphering_speed'] as String?,
        crew = json['crew'] as String?,
        passengers = json['passengers'] as String?,
        cargoCapacity = json['cargo_capacity'] as String?,
        consumables = json['consumables'] as String?,
        hyperdriveRating = json['hyperdrive_rating'] as String?,
        mGLT = json['MGLT'] as String?,
        starshipClass = json['starship_class'] as String?,
        pilots = (json['pilots'] as List?)?.map((dynamic e) => e as String).toList(),
        films = (json['films'] as List?)?.map((dynamic e) => e as String).toList(),
        created = json['created'] as String?,
        edited = json['edited'] as String?,
        url = json['url'] as String?;

  Map<String, dynamic> toJson() => {
    'name' : name,
    'model' : model,
    'manufacturer' : manufacturer,
    'cost_in_credits' : costInCredits,
    'length' : length,
    'max_atmosphering_speed' : maxAtmospheringSpeed,
    'crew' : crew,
    'passengers' : passengers,
    'cargo_capacity' : cargoCapacity,
    'consumables' : consumables,
    'hyperdrive_rating' : hyperdriveRating,
    'MGLT' : mGLT,
    'starship_class' : starshipClass,
    'pilots' : pilots,
    'films' : films,
    'created' : created,
    'edited' : edited,
    'url' : url
  };
}