class FlightModel {
  FlightModel({
    required this.flightDate,
    required this.flightStatus,
    required this.departure,
    required this.arrival,
    required this.airline,
    required this.flight,
    required this.aircraft,
    required this.live,
  });

  final DateTime? flightDate;
  final String? flightStatus;
  final Arrival? departure;
  final Arrival? arrival;
  final Airline? airline;
  final Flight? flight;
  final Aircraft? aircraft;
  final Live? live;

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      flightDate: DateTime.tryParse(json["flight_date"] ?? ""),
      flightStatus: json["flight_status"],
      departure: json["departure"] == null
          ? null
          : Arrival.fromJson(json["departure"]),
      arrival:
          json["arrival"] == null ? null : Arrival.fromJson(json["arrival"]),
      airline:
          json["airline"] == null ? null : Airline.fromJson(json["airline"]),
      flight: json["flight"] == null ? null : Flight.fromJson(json["flight"]),
      aircraft:
          json["aircraft"] == null ? null : Aircraft.fromJson(json["aircraft"]),
      live: json["live"] == null ? null : Live.fromJson(json["live"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "flight_date":
            "${flightDate?.year.toString().padLeft(4)}-${flightDate?.month.toString().padLeft(2)}-${flightDate?.day.toString().padLeft(2)}",
        "flight_status": flightStatus,
        "departure": departure?.toJson(),
        "arrival": arrival?.toJson(),
        "airline": airline?.toJson(),
        "flight": flight?.toJson(),
        "aircraft": aircraft?.toJson(),
        "live": live?.toJson(),
      };
}

class Aircraft {
  Aircraft({
    required this.registration,
    required this.iata,
    required this.icao,
    required this.icao24,
  });

  final String? registration;
  final String? iata;
  final String? icao;
  final String? icao24;

  factory Aircraft.fromJson(Map<String, dynamic> json) {
    return Aircraft(
      registration: json["registration"],
      iata: json["iata"],
      icao: json["icao"],
      icao24: json["icao24"],
    );
  }

  Map<String, dynamic> toJson() => {
        "registration": registration,
        "iata": iata,
        "icao": icao,
        "icao24": icao24,
      };
}

class Airline {
  Airline({
    required this.name,
    required this.iata,
    required this.icao,
  });

  final String? name;
  final String? iata;
  final String? icao;

  factory Airline.fromJson(Map<String, dynamic> json) {
    return Airline(
      name: json["name"],
      iata: json["iata"],
      icao: json["icao"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "iata": iata,
        "icao": icao,
      };
}

class Arrival {
  Arrival({
    required this.airport,
    required this.timezone,
    required this.iata,
    required this.icao,
    required this.terminal,
    required this.gate,
    required this.baggage,
    required this.delay,
    required this.scheduled,
    required this.estimated,
    required this.actual,
    required this.estimatedRunway,
    required this.actualRunway,
  });

  final String? airport;
  final String? timezone;
  final String? iata;
  final String? icao;
  final String? terminal;
  final String? gate;
  final dynamic baggage;
  final num? delay;
  final DateTime? scheduled;
  final DateTime? estimated;
  final DateTime? actual;
  final DateTime? estimatedRunway;
  final DateTime? actualRunway;

  factory Arrival.fromJson(Map<String, dynamic> json) {
    return Arrival(
      airport: json["airport"],
      timezone: json["timezone"],
      iata: json["iata"],
      icao: json["icao"],
      terminal: json["terminal"],
      gate: json["gate"],
      baggage: json["baggage"],
      delay: json["delay"],
      scheduled: DateTime.tryParse(json["scheduled"] ?? ""),
      estimated: DateTime.tryParse(json["estimated"] ?? ""),
      actual: DateTime.tryParse(json["actual"] ?? ""),
      estimatedRunway: DateTime.tryParse(json["estimated_runway"] ?? ""),
      actualRunway: DateTime.tryParse(json["actual_runway"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "airport": airport,
        "timezone": timezone,
        "iata": iata,
        "icao": icao,
        "terminal": terminal,
        "gate": gate,
        "baggage": baggage,
        "delay": delay,
        "scheduled": scheduled?.toIso8601String(),
        "estimated": estimated?.toIso8601String(),
        "actual": actual?.toIso8601String(),
        "estimated_runway": estimatedRunway?.toIso8601String(),
        "actual_runway": actualRunway?.toIso8601String(),
      };
}

class Flight {
  Flight({
    required this.number,
    required this.iata,
    required this.icao,
    required this.codeshared,
  });

  final String? number;
  final String? iata;
  final String? icao;
  final dynamic codeshared;

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      number: json["number"],
      iata: json["iata"],
      icao: json["icao"],
      codeshared: json["codeshared"],
    );
  }

  Map<String, dynamic> toJson() => {
        "number": number,
        "iata": iata,
        "icao": icao,
        "codeshared": codeshared,
      };
}

class Live {
  Live({
    required this.updated,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.direction,
    required this.speedHorizontal,
    required this.speedVertical,
    required this.isGround,
  });

  final DateTime? updated;
  final num? latitude;
  final num? longitude;
  final num? altitude;
  final num? direction;
  final num? speedHorizontal;
  final num? speedVertical;
  final bool? isGround;

  factory Live.fromJson(Map<String, dynamic> json) {
    return Live(
      updated: DateTime.tryParse(json["updated"] ?? ""),
      latitude: json["latitude"],
      longitude: json["longitude"],
      altitude: json["altitude"],
      direction: json["direction"],
      speedHorizontal: json["speed_horizontal"],
      speedVertical: json["speed_vertical"],
      isGround: json["is_ground"],
    );
  }

  Map<String, dynamic> toJson() => {
        "updated": updated?.toIso8601String(),
        "latitude": latitude,
        "longitude": longitude,
        "altitude": altitude,
        "direction": direction,
        "speed_horizontal": speedHorizontal,
        "speed_vertical": speedVertical,
        "is_ground": isGround,
      };
}
