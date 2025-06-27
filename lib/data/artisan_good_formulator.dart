import 'interface.dart';

enum RoundingBehavior { round, floor, ceil }

sealed class ArtisanGoodFormulator {
  final double multiplier;
  final double? plus;
  final double? dividedBy;
  final RoundingBehavior? roundingBehavior;

  const ArtisanGoodFormulator({
    this.multiplier = 1.0,
    this.plus = 0.0,
    this.dividedBy = 1.0,
    this.roundingBehavior = RoundingBehavior.round,
  });

  const ArtisanGoodFormulator.zero()
    : multiplier = 0.0,
      plus = 0.0,
      dividedBy = 1.0,
      roundingBehavior = RoundingBehavior.floor;

  const ArtisanGoodFormulator.exact(this.plus)
    : multiplier = 0.0,
      dividedBy = 1.0,
      roundingBehavior = RoundingBehavior.floor;

  int calculate(Producable item) {
    throw UnimplementedError(
      'calculate method must be implemented in subclasses',
    );
  }

  int round(double value) {
    return switch (roundingBehavior) {
      RoundingBehavior.round => value.round(),
      RoundingBehavior.floor => value.floor(),
      RoundingBehavior.ceil => value.ceil(),
      null => throw UnimplementedError(),
    };
  }
}

class PriceFormulator extends ArtisanGoodFormulator {
  const PriceFormulator({
    super.multiplier,
    super.plus,
    super.dividedBy,
    super.roundingBehavior = RoundingBehavior.floor,
  });

  const PriceFormulator.zero() : super.zero();
  const PriceFormulator.exact(plus) : super.exact(plus);

  @override
  int calculate(Producable item) {
    final basePrice = item.price;
    final price = ((basePrice * multiplier) + (plus ?? 0)) / (dividedBy ?? 1);
    return round(price);
  }
}

class EnergyFormulator extends ArtisanGoodFormulator {
  final double inedibleMultiplier;

  const EnergyFormulator({
    super.multiplier,
    this.inedibleMultiplier = 0.0,
    super.plus,
    super.dividedBy,
    super.roundingBehavior = RoundingBehavior.ceil,
  });

  const EnergyFormulator.zero() : inedibleMultiplier = 0.0, super.zero();
  const EnergyFormulator.exact(plus)
    : inedibleMultiplier = 0.0,
      super.exact(plus);

  @override
  int calculate(Producable item) {
    final baseEnergy = item.energy;
    final basePrice = item.price;
    final energy =
        ((item.isEdible
                ? (baseEnergy * multiplier)
                : (basePrice * inedibleMultiplier)) +
            (plus ?? 0)) /
        (dividedBy ?? 1);
    return round(energy);
  }
}

class HealthFormulator extends ArtisanGoodFormulator {
  final double inedibleMultiplier;

  const HealthFormulator({
    super.multiplier,
    this.inedibleMultiplier = 0.0,
    super.plus,
    super.dividedBy,
    super.roundingBehavior = RoundingBehavior.floor,
  });

  const HealthFormulator.zero() : inedibleMultiplier = 0.0, super.zero();
  const HealthFormulator.exact(plus)
    : inedibleMultiplier = 0.0,
      super.exact(plus);

  @override
  int calculate(Producable item) {
    final baseHealth = item.health;
    final basePrice = item.price;
    final health =
        ((item.isEdible
                ? (baseHealth * multiplier)
                : (basePrice * inedibleMultiplier)) +
            (plus ?? 0)) /
        (dividedBy ?? 1);
    return round(health);
  }
}
