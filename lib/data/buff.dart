enum BuffType {
  maxEnergy('maxEnergy', 'Max Energy', 'max_energy.png'),
  attack('attack', 'Attack', 'attack.png'),
  defense('defense', 'Defense', 'defense.png'),
  speed('speed', 'Speed', 'speed.png'),
  luck('luck', 'Luck', 'luck.png'),
  fishing('fishing', 'Fishing', 'fishing.png'),
  foraging('foraging', 'Foraging', 'foraging.png'),
  mining('mining', 'Mining', 'mining.png'),
  farming('farming', 'Farming', 'farming.png'),
  magnetism('magnetism', 'Magnetism', 'magnetism.png'),
  monsterMusk('monsterMusk', 'Monster Musk Buff', 'monster_musk_buff.png'),
  oilOfGarlic('oilOfGarlic', 'Oil of Garlic Buff', 'oil_of_garlic_buff.png'),
  tipsy('tipsy', 'Tipsy', 'tipsy.png'),
  squidInkRavioli(
    'squidInkRavioli',
    'Squid Ink Ravioli Buff',
    'squid_ink_ravioli_buff.png',
  );

  final String key;
  final String name;
  final String img;

  const BuffType(this.key, this.name, this.img);

  static from(String key) {
    return BuffType.values.firstWhere((e) => e.key == key);
  }
}

class Buff {
  final BuffType type;
  final String time;
  final int value;

  Buff(this.type, this.time, this.value);

  Buff.fromJson(Map<String, dynamic> json)
    : type = BuffType.from(json['type']),
      time = json['time'] ?? '0s',
      value = json['value'] ?? 0;
}

class BuffList {
  final List<Buff> buffs;

  const BuffList(this.buffs);

  factory BuffList.fromJson(List<dynamic>? json) {
    return BuffList(
      json?.map((b) => Buff.fromJson(b as Map<String, dynamic>)).toList() ?? [],
    );
  }

  get isEmpty => buffs.isEmpty;
  get isNotEmpty => buffs.isNotEmpty;
  int get length => buffs.length;

  Buff operator [](int index) => buffs[index];
  List<Buff> toList() => buffs;

  get times {
    return buffs.fold<List<String>>([], (times, buff) {
      if (!times.contains(buff.time)) {
        return [...times, buff.time];
      }
      return times;
    });
  }
}
