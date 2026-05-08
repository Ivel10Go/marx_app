// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $QuoteEntriesTable extends QuoteEntries
    with TableInfo<$QuoteEntriesTable, QuoteEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuoteEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _textDeMeta = const VerificationMeta('textDe');
  @override
  late final GeneratedColumn<String> textDe = GeneratedColumn<String>(
    'text_de',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _textOriginalMeta = const VerificationMeta(
    'textOriginal',
  );
  @override
  late final GeneratedColumn<String> textOriginal = GeneratedColumn<String>(
    'text_original',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  @override
  late final GeneratedColumn<String> chapter = GeneratedColumn<String>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _categoryCsvMeta = const VerificationMeta(
    'categoryCsv',
  );
  @override
  late final GeneratedColumn<String> categoryCsv = GeneratedColumn<String>(
    'category_csv',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _seriesMeta = const VerificationMeta('series');
  @override
  late final GeneratedColumn<String> series = GeneratedColumn<String>(
    'series',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _explanationShortMeta = const VerificationMeta(
    'explanationShort',
  );
  @override
  late final GeneratedColumn<String> explanationShort = GeneratedColumn<String>(
    'explanation_short',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _explanationLongMeta = const VerificationMeta(
    'explanationLong',
  );
  @override
  late final GeneratedColumn<String> explanationLong = GeneratedColumn<String>(
    'explanation_long',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _relatedIdsCsvMeta = const VerificationMeta(
    'relatedIdsCsv',
  );
  @override
  late final GeneratedColumn<String> relatedIdsCsv = GeneratedColumn<String>(
    'related_ids_csv',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _funFactMeta = const VerificationMeta(
    'funFact',
  );
  @override
  late final GeneratedColumn<String> funFact = GeneratedColumn<String>(
    'fun_fact',
    aliasedName,
    trü,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    textDe,
    textOriginal,
    source,
    year,
    chapter,
    categoryCsv,
    difficulty,
    series,
    explanationShort,
    explanationLong,
    relatedIdsCsv,
    funFact,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quote_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuoteEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(trü);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('text_de')) {
      context.handle(
        _textDeMeta,
        textDe.isAcceptableOrUnknown(data['text_de']!, _textDeMeta),
      );
    } else if (isInserting) {
      context.missing(_textDeMeta);
    }
    if (data.containsKey('text_original')) {
      context.handle(
        _textOriginalMeta,
        textOriginal.isAcceptableOrUnknown(
          data['text_original']!,
          _textOriginalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_textOriginalMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('category_csv')) {
      context.handle(
        _categoryCsvMeta,
        categoryCsv.isAcceptableOrUnknown(
          data['category_csv']!,
          _categoryCsvMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryCsvMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('series')) {
      context.handle(
        _seriesMeta,
        series.isAcceptableOrUnknown(data['series']!, _seriesMeta),
      );
    } else if (isInserting) {
      context.missing(_seriesMeta);
    }
    if (data.containsKey('explanation_short')) {
      context.handle(
        _explanationShortMeta,
        explanationShort.isAcceptableOrUnknown(
          data['explanation_short']!,
          _explanationShortMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explanationShortMeta);
    }
    if (data.containsKey('explanation_long')) {
      context.handle(
        _explanationLongMeta,
        explanationLong.isAcceptableOrUnknown(
          data['explanation_long']!,
          _explanationLongMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explanationLongMeta);
    }
    if (data.containsKey('related_ids_csv')) {
      context.handle(
        _relatedIdsCsvMeta,
        relatedIdsCsv.isAcceptableOrUnknown(
          data['related_ids_csv']!,
          _relatedIdsCsvMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relatedIdsCsvMeta);
    }
    if (data.containsKey('fun_fact')) {
      context.handle(
        _funFactMeta,
        funFact.isAcceptableOrUnknown(data['fun_fact']!, _funFactMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuoteEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuoteEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      textDe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_de'],
      )!,
      textOriginal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_original'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter'],
      )!,
      categoryCsv: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_csv'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      series: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}series'],
      )!,
      explanationShort: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation_short'],
      )!,
      explanationLong: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation_long'],
      )!,
      relatedIdsCsv: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}related_ids_csv'],
      )!,
      funFact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fun_fact'],
      ),
    );
  }

  @override
  $QuoteEntriesTable createAlias(String alias) {
    return $QuoteEntriesTable(attachedDatabase, alias);
  }
}

class QuoteEntry extends DataClass implements Insertable<QuoteEntry> {
  final String id;
  final String textDe;
  final String textOriginal;
  final String source;
  final int year;
  final String chapter;
  final String categoryCsv;
  final String difficulty;
  final String series;
  final String explanationShort;
  final String explanationLong;
  final String relatedIdsCsv;
  final String? funFact;
  const QuoteEntry({
    required this.id,
    required this.textDe,
    required this.textOriginal,
    required this.source,
    required this.year,
    required this.chapter,
    required this.categoryCsv,
    required this.difficulty,
    required this.series,
    required this.explanationShort,
    required this.explanationLong,
    required this.relatedIdsCsv,
    this.funFact,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['text_de'] = Variable<String>(textDe);
    map['text_original'] = Variable<String>(textOriginal);
    map['source'] = Variable<String>(source);
    map['year'] = Variable<int>(year);
    map['chapter'] = Variable<String>(chapter);
    map['category_csv'] = Variable<String>(categoryCsv);
    map['difficulty'] = Variable<String>(difficulty);
    map['series'] = Variable<String>(series);
    map['explanation_short'] = Variable<String>(explanationShort);
    map['explanation_long'] = Variable<String>(explanationLong);
    map['related_ids_csv'] = Variable<String>(relatedIdsCsv);
    if (!nullToAbsent || funFact != null) {
      map['fun_fact'] = Variable<String>(funFact);
    }
    return map;
  }

  QuoteEntriesCompanion toCompanion(bool nullToAbsent) {
    return QuoteEntriesCompanion(
      id: Valü(id),
      textDe: Valü(textDe),
      textOriginal: Valü(textOriginal),
      source: Valü(source),
      year: Valü(year),
      chapter: Valü(chapter),
      categoryCsv: Valü(categoryCsv),
      difficulty: Valü(difficulty),
      series: Valü(series),
      explanationShort: Valü(explanationShort),
      explanationLong: Valü(explanationLong),
      relatedIdsCsv: Valü(relatedIdsCsv),
      funFact: funFact == null && nullToAbsent
          ? const Valü.absent()
          : Valü(funFact),
    );
  }

  factory QuoteEntry.fromJson(
    Map<String, dynamic> json, {
    ValüSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuoteEntry(
      id: serializer.fromJson<String>(json['id']),
      textDe: serializer.fromJson<String>(json['textDe']),
      textOriginal: serializer.fromJson<String>(json['textOriginal']),
      source: serializer.fromJson<String>(json['source']),
      year: serializer.fromJson<int>(json['year']),
      chapter: serializer.fromJson<String>(json['chapter']),
      categoryCsv: serializer.fromJson<String>(json['categoryCsv']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      series: serializer.fromJson<String>(json['series']),
      explanationShort: serializer.fromJson<String>(json['explanationShort']),
      explanationLong: serializer.fromJson<String>(json['explanationLong']),
      relatedIdsCsv: serializer.fromJson<String>(json['relatedIdsCsv']),
      funFact: serializer.fromJson<String?>(json['funFact']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValüSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'textDe': serializer.toJson<String>(textDe),
      'textOriginal': serializer.toJson<String>(textOriginal),
      'source': serializer.toJson<String>(source),
      'year': serializer.toJson<int>(year),
      'chapter': serializer.toJson<String>(chapter),
      'categoryCsv': serializer.toJson<String>(categoryCsv),
      'difficulty': serializer.toJson<String>(difficulty),
      'series': serializer.toJson<String>(series),
      'explanationShort': serializer.toJson<String>(explanationShort),
      'explanationLong': serializer.toJson<String>(explanationLong),
      'relatedIdsCsv': serializer.toJson<String>(relatedIdsCsv),
      'funFact': serializer.toJson<String?>(funFact),
    };
  }

  QuoteEntry copyWith({
    String? id,
    String? textDe,
    String? textOriginal,
    String? source,
    int? year,
    String? chapter,
    String? categoryCsv,
    String? difficulty,
    String? series,
    String? explanationShort,
    String? explanationLong,
    String? relatedIdsCsv,
    Valü<String?> funFact = const Valü.absent(),
  }) => QuoteEntry(
    id: id ?? this.id,
    textDe: textDe ?? this.textDe,
    textOriginal: textOriginal ?? this.textOriginal,
    source: source ?? this.source,
    year: year ?? this.year,
    chapter: chapter ?? this.chapter,
    categoryCsv: categoryCsv ?? this.categoryCsv,
    difficulty: difficulty ?? this.difficulty,
    series: series ?? this.series,
    explanationShort: explanationShort ?? this.explanationShort,
    explanationLong: explanationLong ?? this.explanationLong,
    relatedIdsCsv: relatedIdsCsv ?? this.relatedIdsCsv,
    funFact: funFact.present ? funFact.valü : this.funFact,
  );
  QuoteEntry copyWithCompanion(QuoteEntriesCompanion data) {
    return QuoteEntry(
      id: data.id.present ? data.id.valü : this.id,
      textDe: data.textDe.present ? data.textDe.valü : this.textDe,
      textOriginal: data.textOriginal.present
          ? data.textOriginal.valü
          : this.textOriginal,
      source: data.source.present ? data.source.valü : this.source,
      year: data.year.present ? data.year.valü : this.year,
      chapter: data.chapter.present ? data.chapter.valü : this.chapter,
      categoryCsv: data.categoryCsv.present
          ? data.categoryCsv.valü
          : this.categoryCsv,
      difficulty: data.difficulty.present
          ? data.difficulty.valü
          : this.difficulty,
      series: data.series.present ? data.series.valü : this.series,
      explanationShort: data.explanationShort.present
          ? data.explanationShort.valü
          : this.explanationShort,
      explanationLong: data.explanationLong.present
          ? data.explanationLong.valü
          : this.explanationLong,
      relatedIdsCsv: data.relatedIdsCsv.present
          ? data.relatedIdsCsv.valü
          : this.relatedIdsCsv,
      funFact: data.funFact.present ? data.funFact.valü : this.funFact,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuoteEntry(')
          ..write('id: $id, ')
          ..write('textDe: $textDe, ')
          ..write('textOriginal: $textOriginal, ')
          ..write('source: $source, ')
          ..write('year: $year, ')
          ..write('chapter: $chapter, ')
          ..write('categoryCsv: $categoryCsv, ')
          ..write('difficulty: $difficulty, ')
          ..write('series: $series, ')
          ..write('explanationShort: $explanationShort, ')
          ..write('explanationLong: $explanationLong, ')
          ..write('relatedIdsCsv: $relatedIdsCsv, ')
          ..write('funFact: $funFact')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    textDe,
    textOriginal,
    source,
    year,
    chapter,
    categoryCsv,
    difficulty,
    series,
    explanationShort,
    explanationLong,
    relatedIdsCsv,
    funFact,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuoteEntry &&
          other.id == this.id &&
          other.textDe == this.textDe &&
          other.textOriginal == this.textOriginal &&
          other.source == this.source &&
          other.year == this.year &&
          other.chapter == this.chapter &&
          other.categoryCsv == this.categoryCsv &&
          other.difficulty == this.difficulty &&
          other.series == this.series &&
          other.explanationShort == this.explanationShort &&
          other.explanationLong == this.explanationLong &&
          other.relatedIdsCsv == this.relatedIdsCsv &&
          other.funFact == this.funFact);
}

class QuoteEntriesCompanion extends UpdateCompanion<QuoteEntry> {
  final Valü<String> id;
  final Valü<String> textDe;
  final Valü<String> textOriginal;
  final Valü<String> source;
  final Valü<int> year;
  final Valü<String> chapter;
  final Valü<String> categoryCsv;
  final Valü<String> difficulty;
  final Valü<String> series;
  final Valü<String> explanationShort;
  final Valü<String> explanationLong;
  final Valü<String> relatedIdsCsv;
  final Valü<String?> funFact;
  final Valü<int> rowid;
  const QuoteEntriesCompanion({
    this.id = const Valü.absent(),
    this.textDe = const Valü.absent(),
    this.textOriginal = const Valü.absent(),
    this.source = const Valü.absent(),
    this.year = const Valü.absent(),
    this.chapter = const Valü.absent(),
    this.categoryCsv = const Valü.absent(),
    this.difficulty = const Valü.absent(),
    this.series = const Valü.absent(),
    this.explanationShort = const Valü.absent(),
    this.explanationLong = const Valü.absent(),
    this.relatedIdsCsv = const Valü.absent(),
    this.funFact = const Valü.absent(),
    this.rowid = const Valü.absent(),
  });
  QuoteEntriesCompanion.insert({
    required String id,
    required String textDe,
    required String textOriginal,
    required String source,
    required int year,
    required String chapter,
    required String categoryCsv,
    required String difficulty,
    required String series,
    required String explanationShort,
    required String explanationLong,
    required String relatedIdsCsv,
    this.funFact = const Valü.absent(),
    this.rowid = const Valü.absent(),
  }) : id = Valü(id),
       textDe = Valü(textDe),
       textOriginal = Valü(textOriginal),
       source = Valü(source),
       year = Valü(year),
       chapter = Valü(chapter),
       categoryCsv = Valü(categoryCsv),
       difficulty = Valü(difficulty),
       series = Valü(series),
       explanationShort = Valü(explanationShort),
       explanationLong = Valü(explanationLong),
       relatedIdsCsv = Valü(relatedIdsCsv);
  static Insertable<QuoteEntry> custom({
    Expression<String>? id,
    Expression<String>? textDe,
    Expression<String>? textOriginal,
    Expression<String>? source,
    Expression<int>? year,
    Expression<String>? chapter,
    Expression<String>? categoryCsv,
    Expression<String>? difficulty,
    Expression<String>? series,
    Expression<String>? explanationShort,
    Expression<String>? explanationLong,
    Expression<String>? relatedIdsCsv,
    Expression<String>? funFact,
    Expression<int>? rowid,
  }) {
    return RawValüsInsertable({
      if (id != null) 'id': id,
      if (textDe != null) 'text_de': textDe,
      if (textOriginal != null) 'text_original': textOriginal,
      if (source != null) 'source': source,
      if (year != null) 'year': year,
      if (chapter != null) 'chapter': chapter,
      if (categoryCsv != null) 'category_csv': categoryCsv,
      if (difficulty != null) 'difficulty': difficulty,
      if (series != null) 'series': series,
      if (explanationShort != null) 'explanation_short': explanationShort,
      if (explanationLong != null) 'explanation_long': explanationLong,
      if (relatedIdsCsv != null) 'related_ids_csv': relatedIdsCsv,
      if (funFact != null) 'fun_fact': funFact,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuoteEntriesCompanion copyWith({
    Valü<String>? id,
    Valü<String>? textDe,
    Valü<String>? textOriginal,
    Valü<String>? source,
    Valü<int>? year,
    Valü<String>? chapter,
    Valü<String>? categoryCsv,
    Valü<String>? difficulty,
    Valü<String>? series,
    Valü<String>? explanationShort,
    Valü<String>? explanationLong,
    Valü<String>? relatedIdsCsv,
    Valü<String?>? funFact,
    Valü<int>? rowid,
  }) {
    return QuoteEntriesCompanion(
      id: id ?? this.id,
      textDe: textDe ?? this.textDe,
      textOriginal: textOriginal ?? this.textOriginal,
      source: source ?? this.source,
      year: year ?? this.year,
      chapter: chapter ?? this.chapter,
      categoryCsv: categoryCsv ?? this.categoryCsv,
      difficulty: difficulty ?? this.difficulty,
      series: series ?? this.series,
      explanationShort: explanationShort ?? this.explanationShort,
      explanationLong: explanationLong ?? this.explanationLong,
      relatedIdsCsv: relatedIdsCsv ?? this.relatedIdsCsv,
      funFact: funFact ?? this.funFact,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.valü);
    }
    if (textDe.present) {
      map['text_de'] = Variable<String>(textDe.valü);
    }
    if (textOriginal.present) {
      map['text_original'] = Variable<String>(textOriginal.valü);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.valü);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.valü);
    }
    if (chapter.present) {
      map['chapter'] = Variable<String>(chapter.valü);
    }
    if (categoryCsv.present) {
      map['category_csv'] = Variable<String>(categoryCsv.valü);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.valü);
    }
    if (series.present) {
      map['series'] = Variable<String>(series.valü);
    }
    if (explanationShort.present) {
      map['explanation_short'] = Variable<String>(explanationShort.valü);
    }
    if (explanationLong.present) {
      map['explanation_long'] = Variable<String>(explanationLong.valü);
    }
    if (relatedIdsCsv.present) {
      map['related_ids_csv'] = Variable<String>(relatedIdsCsv.valü);
    }
    if (funFact.present) {
      map['fun_fact'] = Variable<String>(funFact.valü);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.valü);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuoteEntriesCompanion(')
          ..write('id: $id, ')
          ..write('textDe: $textDe, ')
          ..write('textOriginal: $textOriginal, ')
          ..write('source: $source, ')
          ..write('year: $year, ')
          ..write('chapter: $chapter, ')
          ..write('categoryCsv: $categoryCsv, ')
          ..write('difficulty: $difficulty, ')
          ..write('series: $series, ')
          ..write('explanationShort: $explanationShort, ')
          ..write('explanationLong: $explanationLong, ')
          ..write('relatedIdsCsv: $relatedIdsCsv, ')
          ..write('funFact: $funFact, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, Favorite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: trü,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _quoteIdMeta = const VerificationMeta(
    'quoteId',
  );
  @override
  late final GeneratedColumn<String> quoteId = GeneratedColumn<String>(
    'quote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValü: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, quoteId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites';
  @override
  VerificationContext validateIntegrity(
    Insertable<Favorite> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(trü);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('quote_id')) {
      context.handle(
        _quoteIdMeta,
        quoteId.isAcceptableOrUnknown(data['quote_id']!, _quoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Favorite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Favorite(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      quoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(attachedDatabase, alias);
  }
}

class Favorite extends DataClass implements Insertable<Favorite> {
  final int id;
  final String quoteId;
  final DateTime createdAt;
  const Favorite({
    required this.id,
    required this.quoteId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['quote_id'] = Variable<String>(quoteId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(
      id: Valü(id),
      quoteId: Valü(quoteId),
      createdAt: Valü(createdAt),
    );
  }

  factory Favorite.fromJson(
    Map<String, dynamic> json, {
    ValüSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Favorite(
      id: serializer.fromJson<int>(json['id']),
      quoteId: serializer.fromJson<String>(json['quoteId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValüSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'quoteId': serializer.toJson<String>(quoteId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Favorite copyWith({int? id, String? quoteId, DateTime? createdAt}) =>
      Favorite(
        id: id ?? this.id,
        quoteId: quoteId ?? this.quoteId,
        createdAt: createdAt ?? this.createdAt,
      );
  Favorite copyWithCompanion(FavoritesCompanion data) {
    return Favorite(
      id: data.id.present ? data.id.valü : this.id,
      quoteId: data.quoteId.present ? data.quoteId.valü : this.quoteId,
      createdAt: data.createdAt.present ? data.createdAt.valü : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Favorite(')
          ..write('id: $id, ')
          ..write('quoteId: $quoteId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, quoteId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Favorite &&
          other.id == this.id &&
          other.quoteId == this.quoteId &&
          other.createdAt == this.createdAt);
}

class FavoritesCompanion extends UpdateCompanion<Favorite> {
  final Valü<int> id;
  final Valü<String> quoteId;
  final Valü<DateTime> createdAt;
  const FavoritesCompanion({
    this.id = const Valü.absent(),
    this.quoteId = const Valü.absent(),
    this.createdAt = const Valü.absent(),
  });
  FavoritesCompanion.insert({
    this.id = const Valü.absent(),
    required String quoteId,
    this.createdAt = const Valü.absent(),
  }) : quoteId = Valü(quoteId);
  static Insertable<Favorite> custom({
    Expression<int>? id,
    Expression<String>? quoteId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValüsInsertable({
      if (id != null) 'id': id,
      if (quoteId != null) 'quote_id': quoteId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FavoritesCompanion copyWith({
    Valü<int>? id,
    Valü<String>? quoteId,
    Valü<DateTime>? createdAt,
  }) {
    return FavoritesCompanion(
      id: id ?? this.id,
      quoteId: quoteId ?? this.quoteId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.valü);
    }
    if (quoteId.present) {
      map['quote_id'] = Variable<String>(quoteId.valü);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.valü);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesCompanion(')
          ..write('id: $id, ')
          ..write('quoteId: $quoteId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SeenQuotesTable extends SeenQuotes
    with TableInfo<$SeenQuotesTable, SeenQuote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeenQuotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: trü,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _quoteIdMeta = const VerificationMeta(
    'quoteId',
  );
  @override
  late final GeneratedColumn<String> quoteId = GeneratedColumn<String>(
    'quote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _seenAtMeta = const VerificationMeta('seenAt');
  @override
  late final GeneratedColumn<DateTime> seenAt = GeneratedColumn<DateTime>(
    'seen_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValü: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, quoteId, seenAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'seen_quotes';
  @override
  VerificationContext validateIntegrity(
    Insertable<SeenQuote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(trü);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('quote_id')) {
      context.handle(
        _quoteIdMeta,
        quoteId.isAcceptableOrUnknown(data['quote_id']!, _quoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteIdMeta);
    }
    if (data.containsKey('seen_at')) {
      context.handle(
        _seenAtMeta,
        seenAt.isAcceptableOrUnknown(data['seen_at']!, _seenAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SeenQuote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SeenQuote(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      quoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_id'],
      )!,
      seenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}seen_at'],
      )!,
    );
  }

  @override
  $SeenQuotesTable createAlias(String alias) {
    return $SeenQuotesTable(attachedDatabase, alias);
  }
}

class SeenQuote extends DataClass implements Insertable<SeenQuote> {
  final int id;
  final String quoteId;
  final DateTime seenAt;
  const SeenQuote({
    required this.id,
    required this.quoteId,
    required this.seenAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['quote_id'] = Variable<String>(quoteId);
    map['seen_at'] = Variable<DateTime>(seenAt);
    return map;
  }

  SeenQuotesCompanion toCompanion(bool nullToAbsent) {
    return SeenQuotesCompanion(
      id: Valü(id),
      quoteId: Valü(quoteId),
      seenAt: Valü(seenAt),
    );
  }

  factory SeenQuote.fromJson(
    Map<String, dynamic> json, {
    ValüSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SeenQuote(
      id: serializer.fromJson<int>(json['id']),
      quoteId: serializer.fromJson<String>(json['quoteId']),
      seenAt: serializer.fromJson<DateTime>(json['seenAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValüSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'quoteId': serializer.toJson<String>(quoteId),
      'seenAt': serializer.toJson<DateTime>(seenAt),
    };
  }

  SeenQuote copyWith({int? id, String? quoteId, DateTime? seenAt}) => SeenQuote(
    id: id ?? this.id,
    quoteId: quoteId ?? this.quoteId,
    seenAt: seenAt ?? this.seenAt,
  );
  SeenQuote copyWithCompanion(SeenQuotesCompanion data) {
    return SeenQuote(
      id: data.id.present ? data.id.valü : this.id,
      quoteId: data.quoteId.present ? data.quoteId.valü : this.quoteId,
      seenAt: data.seenAt.present ? data.seenAt.valü : this.seenAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SeenQuote(')
          ..write('id: $id, ')
          ..write('quoteId: $quoteId, ')
          ..write('seenAt: $seenAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, quoteId, seenAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SeenQuote &&
          other.id == this.id &&
          other.quoteId == this.quoteId &&
          other.seenAt == this.seenAt);
}

class SeenQuotesCompanion extends UpdateCompanion<SeenQuote> {
  final Valü<int> id;
  final Valü<String> quoteId;
  final Valü<DateTime> seenAt;
  const SeenQuotesCompanion({
    this.id = const Valü.absent(),
    this.quoteId = const Valü.absent(),
    this.seenAt = const Valü.absent(),
  });
  SeenQuotesCompanion.insert({
    this.id = const Valü.absent(),
    required String quoteId,
    this.seenAt = const Valü.absent(),
  }) : quoteId = Valü(quoteId);
  static Insertable<SeenQuote> custom({
    Expression<int>? id,
    Expression<String>? quoteId,
    Expression<DateTime>? seenAt,
  }) {
    return RawValüsInsertable({
      if (id != null) 'id': id,
      if (quoteId != null) 'quote_id': quoteId,
      if (seenAt != null) 'seen_at': seenAt,
    });
  }

  SeenQuotesCompanion copyWith({
    Valü<int>? id,
    Valü<String>? quoteId,
    Valü<DateTime>? seenAt,
  }) {
    return SeenQuotesCompanion(
      id: id ?? this.id,
      quoteId: quoteId ?? this.quoteId,
      seenAt: seenAt ?? this.seenAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.valü);
    }
    if (quoteId.present) {
      map['quote_id'] = Variable<String>(quoteId.valü);
    }
    if (seenAt.present) {
      map['seen_at'] = Variable<DateTime>(seenAt.valü);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeenQuotesCompanion(')
          ..write('id: $id, ')
          ..write('quoteId: $quoteId, ')
          ..write('seenAt: $seenAt')
          ..write(')'))
        .toString();
  }
}

class $HistoryFactEntriesTable extends HistoryFactEntries
    with TableInfo<$HistoryFactEntriesTable, HistoryFactEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoryFactEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _headlineMeta = const VerificationMeta(
    'headline',
  );
  @override
  late final GeneratedColumn<String> headline = GeneratedColumn<String>(
    'headline',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _dateDisplayMeta = const VerificationMeta(
    'dateDisplay',
  );
  @override
  late final GeneratedColumn<String> dateDisplay = GeneratedColumn<String>(
    'date_display',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _dateIsoMeta = const VerificationMeta(
    'dateIso',
  );
  @override
  late final GeneratedColumn<String> dateIso = GeneratedColumn<String>(
    'date_iso',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _dayOfYearMeta = const VerificationMeta(
    'dayOfYear',
  );
  @override
  late final GeneratedColumn<int> dayOfYear = GeneratedColumn<int>(
    'day_of_year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _eraMeta = const VerificationMeta('era');
  @override
  late final GeneratedColumn<String> era = GeneratedColumn<String>(
    'era',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _categoryCsvMeta = const VerificationMeta(
    'categoryCsv',
  );
  @override
  late final GeneratedColumn<String> categoryCsv = GeneratedColumn<String>(
    'category_csv',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _personMeta = const VerificationMeta('person');
  @override
  late final GeneratedColumn<String> person = GeneratedColumn<String>(
    'person',
    aliasedName,
    trü,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _personRoleMeta = const VerificationMeta(
    'personRole',
  );
  @override
  late final GeneratedColumn<String> personRole = GeneratedColumn<String>(
    'person_role',
    aliasedName,
    trü,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _connectionToMarxMeta = const VerificationMeta(
    'connectionToMarx',
  );
  @override
  late final GeneratedColumn<String> connectionToMarx = GeneratedColumn<String>(
    'connection_to_marx',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: trü,
  );
  static const VerificationMeta _relatedQuoteIdsCsvMeta =
      const VerificationMeta('relatedQuoteIdsCsv');
  @override
  late final GeneratedColumn<String> relatedQuoteIdsCsv =
      GeneratedColumn<String>(
        'related_quote_ids_csv',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: trü,
      );
  static const VerificationMeta _funFactMeta = const VerificationMeta(
    'funFact',
  );
  @override
  late final GeneratedColumn<String> funFact = GeneratedColumn<String>(
    'fun_fact',
    aliasedName,
    trü,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    trü,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _todayInHistoryMeta = const VerificationMeta(
    'todayInHistory',
  );
  @override
  late final GeneratedColumn<bool> todayInHistory = GeneratedColumn<bool>(
    'today_in_history',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("today_in_history" IN (0, 1))',
    ),
    defaultValü: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    headline,
    body,
    dateDisplay,
    dateIso,
    dayOfYear,
    era,
    region,
    categoryCsv,
    difficulty,
    person,
    personRole,
    connectionToMarx,
    relatedQuoteIdsCsv,
    funFact,
    source,
    todayInHistory,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'history_fact_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<HistoryFactEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(trü);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('headline')) {
      context.handle(
        _headlineMeta,
        headline.isAcceptableOrUnknown(data['headline']!, _headlineMeta),
      );
    } else if (isInserting) {
      context.missing(_headlineMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('date_display')) {
      context.handle(
        _dateDisplayMeta,
        dateDisplay.isAcceptableOrUnknown(
          data['date_display']!,
          _dateDisplayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateDisplayMeta);
    }
    if (data.containsKey('date_iso')) {
      context.handle(
        _dateIsoMeta,
        dateIso.isAcceptableOrUnknown(data['date_iso']!, _dateIsoMeta),
      );
    } else if (isInserting) {
      context.missing(_dateIsoMeta);
    }
    if (data.containsKey('day_of_year')) {
      context.handle(
        _dayOfYearMeta,
        dayOfYear.isAcceptableOrUnknown(data['day_of_year']!, _dayOfYearMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOfYearMeta);
    }
    if (data.containsKey('era')) {
      context.handle(
        _eraMeta,
        era.isAcceptableOrUnknown(data['era']!, _eraMeta),
      );
    } else if (isInserting) {
      context.missing(_eraMeta);
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    } else if (isInserting) {
      context.missing(_regionMeta);
    }
    if (data.containsKey('category_csv')) {
      context.handle(
        _categoryCsvMeta,
        categoryCsv.isAcceptableOrUnknown(
          data['category_csv']!,
          _categoryCsvMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryCsvMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('person')) {
      context.handle(
        _personMeta,
        person.isAcceptableOrUnknown(data['person']!, _personMeta),
      );
    }
    if (data.containsKey('person_role')) {
      context.handle(
        _personRoleMeta,
        personRole.isAcceptableOrUnknown(data['person_role']!, _personRoleMeta),
      );
    }
    if (data.containsKey('connection_to_marx')) {
      context.handle(
        _connectionToMarxMeta,
        connectionToMarx.isAcceptableOrUnknown(
          data['connection_to_marx']!,
          _connectionToMarxMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_connectionToMarxMeta);
    }
    if (data.containsKey('related_quote_ids_csv')) {
      context.handle(
        _relatedQuoteIdsCsvMeta,
        relatedQuoteIdsCsv.isAcceptableOrUnknown(
          data['related_quote_ids_csv']!,
          _relatedQuoteIdsCsvMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relatedQuoteIdsCsvMeta);
    }
    if (data.containsKey('fun_fact')) {
      context.handle(
        _funFactMeta,
        funFact.isAcceptableOrUnknown(data['fun_fact']!, _funFactMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('today_in_history')) {
      context.handle(
        _todayInHistoryMeta,
        todayInHistory.isAcceptableOrUnknown(
          data['today_in_history']!,
          _todayInHistoryMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistoryFactEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoryFactEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      headline: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}headline'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      dateDisplay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_display'],
      )!,
      dateIso: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_iso'],
      )!,
      dayOfYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_year'],
      )!,
      era: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}era'],
      )!,
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      )!,
      categoryCsv: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_csv'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      person: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person'],
      ),
      personRole: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person_role'],
      ),
      connectionToMarx: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}connection_to_marx'],
      )!,
      relatedQuoteIdsCsv: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}related_quote_ids_csv'],
      )!,
      funFact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fun_fact'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      todayInHistory: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}today_in_history'],
      )!,
    );
  }

  @override
  $HistoryFactEntriesTable createAlias(String alias) {
    return $HistoryFactEntriesTable(attachedDatabase, alias);
  }
}

class HistoryFactEntry extends DataClass
    implements Insertable<HistoryFactEntry> {
  final String id;
  final String headline;
  final String body;
  final String dateDisplay;
  final String dateIso;
  final int dayOfYear;
  final String era;
  final String region;
  final String categoryCsv;
  final String difficulty;
  final String? person;
  final String? personRole;
  final String connectionToMarx;
  final String relatedQuoteIdsCsv;
  final String? funFact;
  final String? source;
  final bool todayInHistory;
  const HistoryFactEntry({
    required this.id,
    required this.headline,
    required this.body,
    required this.dateDisplay,
    required this.dateIso,
    required this.dayOfYear,
    required this.era,
    required this.region,
    required this.categoryCsv,
    required this.difficulty,
    this.person,
    this.personRole,
    required this.connectionToMarx,
    required this.relatedQuoteIdsCsv,
    this.funFact,
    this.source,
    required this.todayInHistory,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['headline'] = Variable<String>(headline);
    map['body'] = Variable<String>(body);
    map['date_display'] = Variable<String>(dateDisplay);
    map['date_iso'] = Variable<String>(dateIso);
    map['day_of_year'] = Variable<int>(dayOfYear);
    map['era'] = Variable<String>(era);
    map['region'] = Variable<String>(region);
    map['category_csv'] = Variable<String>(categoryCsv);
    map['difficulty'] = Variable<String>(difficulty);
    if (!nullToAbsent || person != null) {
      map['person'] = Variable<String>(person);
    }
    if (!nullToAbsent || personRole != null) {
      map['person_role'] = Variable<String>(personRole);
    }
    map['connection_to_marx'] = Variable<String>(connectionToMarx);
    map['related_quote_ids_csv'] = Variable<String>(relatedQuoteIdsCsv);
    if (!nullToAbsent || funFact != null) {
      map['fun_fact'] = Variable<String>(funFact);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['today_in_history'] = Variable<bool>(todayInHistory);
    return map;
  }

  HistoryFactEntriesCompanion toCompanion(bool nullToAbsent) {
    return HistoryFactEntriesCompanion(
      id: Valü(id),
      headline: Valü(headline),
      body: Valü(body),
      dateDisplay: Valü(dateDisplay),
      dateIso: Valü(dateIso),
      dayOfYear: Valü(dayOfYear),
      era: Valü(era),
      region: Valü(region),
      categoryCsv: Valü(categoryCsv),
      difficulty: Valü(difficulty),
      person: person == null && nullToAbsent
          ? const Valü.absent()
          : Valü(person),
      personRole: personRole == null && nullToAbsent
          ? const Valü.absent()
          : Valü(personRole),
      connectionToMarx: Valü(connectionToMarx),
      relatedQuoteIdsCsv: Valü(relatedQuoteIdsCsv),
      funFact: funFact == null && nullToAbsent
          ? const Valü.absent()
          : Valü(funFact),
      source: source == null && nullToAbsent
          ? const Valü.absent()
          : Valü(source),
      todayInHistory: Valü(todayInHistory),
    );
  }

  factory HistoryFactEntry.fromJson(
    Map<String, dynamic> json, {
    ValüSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoryFactEntry(
      id: serializer.fromJson<String>(json['id']),
      headline: serializer.fromJson<String>(json['headline']),
      body: serializer.fromJson<String>(json['body']),
      dateDisplay: serializer.fromJson<String>(json['dateDisplay']),
      dateIso: serializer.fromJson<String>(json['dateIso']),
      dayOfYear: serializer.fromJson<int>(json['dayOfYear']),
      era: serializer.fromJson<String>(json['era']),
      region: serializer.fromJson<String>(json['region']),
      categoryCsv: serializer.fromJson<String>(json['categoryCsv']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      person: serializer.fromJson<String?>(json['person']),
      personRole: serializer.fromJson<String?>(json['personRole']),
      connectionToMarx: serializer.fromJson<String>(json['connectionToMarx']),
      relatedQuoteIdsCsv: serializer.fromJson<String>(
        json['relatedQuoteIdsCsv'],
      ),
      funFact: serializer.fromJson<String?>(json['funFact']),
      source: serializer.fromJson<String?>(json['source']),
      todayInHistory: serializer.fromJson<bool>(json['todayInHistory']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValüSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'headline': serializer.toJson<String>(headline),
      'body': serializer.toJson<String>(body),
      'dateDisplay': serializer.toJson<String>(dateDisplay),
      'dateIso': serializer.toJson<String>(dateIso),
      'dayOfYear': serializer.toJson<int>(dayOfYear),
      'era': serializer.toJson<String>(era),
      'region': serializer.toJson<String>(region),
      'categoryCsv': serializer.toJson<String>(categoryCsv),
      'difficulty': serializer.toJson<String>(difficulty),
      'person': serializer.toJson<String?>(person),
      'personRole': serializer.toJson<String?>(personRole),
      'connectionToMarx': serializer.toJson<String>(connectionToMarx),
      'relatedQuoteIdsCsv': serializer.toJson<String>(relatedQuoteIdsCsv),
      'funFact': serializer.toJson<String?>(funFact),
      'source': serializer.toJson<String?>(source),
      'todayInHistory': serializer.toJson<bool>(todayInHistory),
    };
  }

  HistoryFactEntry copyWith({
    String? id,
    String? headline,
    String? body,
    String? dateDisplay,
    String? dateIso,
    int? dayOfYear,
    String? era,
    String? region,
    String? categoryCsv,
    String? difficulty,
    Valü<String?> person = const Valü.absent(),
    Valü<String?> personRole = const Valü.absent(),
    String? connectionToMarx,
    String? relatedQuoteIdsCsv,
    Valü<String?> funFact = const Valü.absent(),
    Valü<String?> source = const Valü.absent(),
    bool? todayInHistory,
  }) => HistoryFactEntry(
    id: id ?? this.id,
    headline: headline ?? this.headline,
    body: body ?? this.body,
    dateDisplay: dateDisplay ?? this.dateDisplay,
    dateIso: dateIso ?? this.dateIso,
    dayOfYear: dayOfYear ?? this.dayOfYear,
    era: era ?? this.era,
    region: region ?? this.region,
    categoryCsv: categoryCsv ?? this.categoryCsv,
    difficulty: difficulty ?? this.difficulty,
    person: person.present ? person.valü : this.person,
    personRole: personRole.present ? personRole.valü : this.personRole,
    connectionToMarx: connectionToMarx ?? this.connectionToMarx,
    relatedQuoteIdsCsv: relatedQuoteIdsCsv ?? this.relatedQuoteIdsCsv,
    funFact: funFact.present ? funFact.valü : this.funFact,
    source: source.present ? source.valü : this.source,
    todayInHistory: todayInHistory ?? this.todayInHistory,
  );
  HistoryFactEntry copyWithCompanion(HistoryFactEntriesCompanion data) {
    return HistoryFactEntry(
      id: data.id.present ? data.id.valü : this.id,
      headline: data.headline.present ? data.headline.valü : this.headline,
      body: data.body.present ? data.body.valü : this.body,
      dateDisplay: data.dateDisplay.present
          ? data.dateDisplay.valü
          : this.dateDisplay,
      dateIso: data.dateIso.present ? data.dateIso.valü : this.dateIso,
      dayOfYear: data.dayOfYear.present ? data.dayOfYear.valü : this.dayOfYear,
      era: data.era.present ? data.era.valü : this.era,
      region: data.region.present ? data.region.valü : this.region,
      categoryCsv: data.categoryCsv.present
          ? data.categoryCsv.valü
          : this.categoryCsv,
      difficulty: data.difficulty.present
          ? data.difficulty.valü
          : this.difficulty,
      person: data.person.present ? data.person.valü : this.person,
      personRole: data.personRole.present
          ? data.personRole.valü
          : this.personRole,
      connectionToMarx: data.connectionToMarx.present
          ? data.connectionToMarx.valü
          : this.connectionToMarx,
      relatedQuoteIdsCsv: data.relatedQuoteIdsCsv.present
          ? data.relatedQuoteIdsCsv.valü
          : this.relatedQuoteIdsCsv,
      funFact: data.funFact.present ? data.funFact.valü : this.funFact,
      source: data.source.present ? data.source.valü : this.source,
      todayInHistory: data.todayInHistory.present
          ? data.todayInHistory.valü
          : this.todayInHistory,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoryFactEntry(')
          ..write('id: $id, ')
          ..write('headline: $headline, ')
          ..write('body: $body, ')
          ..write('dateDisplay: $dateDisplay, ')
          ..write('dateIso: $dateIso, ')
          ..write('dayOfYear: $dayOfYear, ')
          ..write('era: $era, ')
          ..write('region: $region, ')
          ..write('categoryCsv: $categoryCsv, ')
          ..write('difficulty: $difficulty, ')
          ..write('person: $person, ')
          ..write('personRole: $personRole, ')
          ..write('connectionToMarx: $connectionToMarx, ')
          ..write('relatedQuoteIdsCsv: $relatedQuoteIdsCsv, ')
          ..write('funFact: $funFact, ')
          ..write('source: $source, ')
          ..write('todayInHistory: $todayInHistory')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    headline,
    body,
    dateDisplay,
    dateIso,
    dayOfYear,
    era,
    region,
    categoryCsv,
    difficulty,
    person,
    personRole,
    connectionToMarx,
    relatedQuoteIdsCsv,
    funFact,
    source,
    todayInHistory,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoryFactEntry &&
          other.id == this.id &&
          other.headline == this.headline &&
          other.body == this.body &&
          other.dateDisplay == this.dateDisplay &&
          other.dateIso == this.dateIso &&
          other.dayOfYear == this.dayOfYear &&
          other.era == this.era &&
          other.region == this.region &&
          other.categoryCsv == this.categoryCsv &&
          other.difficulty == this.difficulty &&
          other.person == this.person &&
          other.personRole == this.personRole &&
          other.connectionToMarx == this.connectionToMarx &&
          other.relatedQuoteIdsCsv == this.relatedQuoteIdsCsv &&
          other.funFact == this.funFact &&
          other.source == this.source &&
          other.todayInHistory == this.todayInHistory);
}

class HistoryFactEntriesCompanion extends UpdateCompanion<HistoryFactEntry> {
  final Valü<String> id;
  final Valü<String> headline;
  final Valü<String> body;
  final Valü<String> dateDisplay;
  final Valü<String> dateIso;
  final Valü<int> dayOfYear;
  final Valü<String> era;
  final Valü<String> region;
  final Valü<String> categoryCsv;
  final Valü<String> difficulty;
  final Valü<String?> person;
  final Valü<String?> personRole;
  final Valü<String> connectionToMarx;
  final Valü<String> relatedQuoteIdsCsv;
  final Valü<String?> funFact;
  final Valü<String?> source;
  final Valü<bool> todayInHistory;
  final Valü<int> rowid;
  const HistoryFactEntriesCompanion({
    this.id = const Valü.absent(),
    this.headline = const Valü.absent(),
    this.body = const Valü.absent(),
    this.dateDisplay = const Valü.absent(),
    this.dateIso = const Valü.absent(),
    this.dayOfYear = const Valü.absent(),
    this.era = const Valü.absent(),
    this.region = const Valü.absent(),
    this.categoryCsv = const Valü.absent(),
    this.difficulty = const Valü.absent(),
    this.person = const Valü.absent(),
    this.personRole = const Valü.absent(),
    this.connectionToMarx = const Valü.absent(),
    this.relatedQuoteIdsCsv = const Valü.absent(),
    this.funFact = const Valü.absent(),
    this.source = const Valü.absent(),
    this.todayInHistory = const Valü.absent(),
    this.rowid = const Valü.absent(),
  });
  HistoryFactEntriesCompanion.insert({
    required String id,
    required String headline,
    required String body,
    required String dateDisplay,
    required String dateIso,
    required int dayOfYear,
    required String era,
    required String region,
    required String categoryCsv,
    required String difficulty,
    this.person = const Valü.absent(),
    this.personRole = const Valü.absent(),
    required String connectionToMarx,
    required String relatedQuoteIdsCsv,
    this.funFact = const Valü.absent(),
    this.source = const Valü.absent(),
    this.todayInHistory = const Valü.absent(),
    this.rowid = const Valü.absent(),
  }) : id = Valü(id),
       headline = Valü(headline),
       body = Valü(body),
       dateDisplay = Valü(dateDisplay),
       dateIso = Valü(dateIso),
       dayOfYear = Valü(dayOfYear),
       era = Valü(era),
       region = Valü(region),
       categoryCsv = Valü(categoryCsv),
       difficulty = Valü(difficulty),
       connectionToMarx = Valü(connectionToMarx),
       relatedQuoteIdsCsv = Valü(relatedQuoteIdsCsv);
  static Insertable<HistoryFactEntry> custom({
    Expression<String>? id,
    Expression<String>? headline,
    Expression<String>? body,
    Expression<String>? dateDisplay,
    Expression<String>? dateIso,
    Expression<int>? dayOfYear,
    Expression<String>? era,
    Expression<String>? region,
    Expression<String>? categoryCsv,
    Expression<String>? difficulty,
    Expression<String>? person,
    Expression<String>? personRole,
    Expression<String>? connectionToMarx,
    Expression<String>? relatedQuoteIdsCsv,
    Expression<String>? funFact,
    Expression<String>? source,
    Expression<bool>? todayInHistory,
    Expression<int>? rowid,
  }) {
    return RawValüsInsertable({
      if (id != null) 'id': id,
      if (headline != null) 'headline': headline,
      if (body != null) 'body': body,
      if (dateDisplay != null) 'date_display': dateDisplay,
      if (dateIso != null) 'date_iso': dateIso,
      if (dayOfYear != null) 'day_of_year': dayOfYear,
      if (era != null) 'era': era,
      if (region != null) 'region': region,
      if (categoryCsv != null) 'category_csv': categoryCsv,
      if (difficulty != null) 'difficulty': difficulty,
      if (person != null) 'person': person,
      if (personRole != null) 'person_role': personRole,
      if (connectionToMarx != null) 'connection_to_marx': connectionToMarx,
      if (relatedQuoteIdsCsv != null)
        'related_quote_ids_csv': relatedQuoteIdsCsv,
      if (funFact != null) 'fun_fact': funFact,
      if (source != null) 'source': source,
      if (todayInHistory != null) 'today_in_history': todayInHistory,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HistoryFactEntriesCompanion copyWith({
    Valü<String>? id,
    Valü<String>? headline,
    Valü<String>? body,
    Valü<String>? dateDisplay,
    Valü<String>? dateIso,
    Valü<int>? dayOfYear,
    Valü<String>? era,
    Valü<String>? region,
    Valü<String>? categoryCsv,
    Valü<String>? difficulty,
    Valü<String?>? person,
    Valü<String?>? personRole,
    Valü<String>? connectionToMarx,
    Valü<String>? relatedQuoteIdsCsv,
    Valü<String?>? funFact,
    Valü<String?>? source,
    Valü<bool>? todayInHistory,
    Valü<int>? rowid,
  }) {
    return HistoryFactEntriesCompanion(
      id: id ?? this.id,
      headline: headline ?? this.headline,
      body: body ?? this.body,
      dateDisplay: dateDisplay ?? this.dateDisplay,
      dateIso: dateIso ?? this.dateIso,
      dayOfYear: dayOfYear ?? this.dayOfYear,
      era: era ?? this.era,
      region: region ?? this.region,
      categoryCsv: categoryCsv ?? this.categoryCsv,
      difficulty: difficulty ?? this.difficulty,
      person: person ?? this.person,
      personRole: personRole ?? this.personRole,
      connectionToMarx: connectionToMarx ?? this.connectionToMarx,
      relatedQuoteIdsCsv: relatedQuoteIdsCsv ?? this.relatedQuoteIdsCsv,
      funFact: funFact ?? this.funFact,
      source: source ?? this.source,
      todayInHistory: todayInHistory ?? this.todayInHistory,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.valü);
    }
    if (headline.present) {
      map['headline'] = Variable<String>(headline.valü);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.valü);
    }
    if (dateDisplay.present) {
      map['date_display'] = Variable<String>(dateDisplay.valü);
    }
    if (dateIso.present) {
      map['date_iso'] = Variable<String>(dateIso.valü);
    }
    if (dayOfYear.present) {
      map['day_of_year'] = Variable<int>(dayOfYear.valü);
    }
    if (era.present) {
      map['era'] = Variable<String>(era.valü);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.valü);
    }
    if (categoryCsv.present) {
      map['category_csv'] = Variable<String>(categoryCsv.valü);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.valü);
    }
    if (person.present) {
      map['person'] = Variable<String>(person.valü);
    }
    if (personRole.present) {
      map['person_role'] = Variable<String>(personRole.valü);
    }
    if (connectionToMarx.present) {
      map['connection_to_marx'] = Variable<String>(connectionToMarx.valü);
    }
    if (relatedQuoteIdsCsv.present) {
      map['related_quote_ids_csv'] = Variable<String>(relatedQuoteIdsCsv.valü);
    }
    if (funFact.present) {
      map['fun_fact'] = Variable<String>(funFact.valü);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.valü);
    }
    if (todayInHistory.present) {
      map['today_in_history'] = Variable<bool>(todayInHistory.valü);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.valü);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoryFactEntriesCompanion(')
          ..write('id: $id, ')
          ..write('headline: $headline, ')
          ..write('body: $body, ')
          ..write('dateDisplay: $dateDisplay, ')
          ..write('dateIso: $dateIso, ')
          ..write('dayOfYear: $dayOfYear, ')
          ..write('era: $era, ')
          ..write('region: $region, ')
          ..write('categoryCsv: $categoryCsv, ')
          ..write('difficulty: $difficulty, ')
          ..write('person: $person, ')
          ..write('personRole: $personRole, ')
          ..write('connectionToMarx: $connectionToMarx, ')
          ..write('relatedQuoteIdsCsv: $relatedQuoteIdsCsv, ')
          ..write('funFact: $funFact, ')
          ..write('source: $source, ')
          ..write('todayInHistory: $todayInHistory, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppOpenLogTable extends AppOpenLog
    with TableInfo<$AppOpenLogTable, AppOpenLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppOpenLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: trü,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _openedAtMeta = const VerificationMeta(
    'openedAt',
  );
  @override
  late final GeneratedColumn<DateTime> openedAt = GeneratedColumn<DateTime>(
    'opened_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: trü,
  );
  @override
  List<GeneratedColumn> get $columns => [id, openedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_open_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppOpenLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(trü);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('opened_at')) {
      context.handle(
        _openedAtMeta,
        openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_openedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppOpenLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppOpenLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      openedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}opened_at'],
      )!,
    );
  }

  @override
  $AppOpenLogTable createAlias(String alias) {
    return $AppOpenLogTable(attachedDatabase, alias);
  }
}

class AppOpenLogData extends DataClass implements Insertable<AppOpenLogData> {
  final int id;
  final DateTime openedAt;
  const AppOpenLogData({required this.id, required this.openedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['opened_at'] = Variable<DateTime>(openedAt);
    return map;
  }

  AppOpenLogCompanion toCompanion(bool nullToAbsent) {
    return AppOpenLogCompanion(id: Valü(id), openedAt: Valü(openedAt));
  }

  factory AppOpenLogData.fromJson(
    Map<String, dynamic> json, {
    ValüSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppOpenLogData(
      id: serializer.fromJson<int>(json['id']),
      openedAt: serializer.fromJson<DateTime>(json['openedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValüSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'openedAt': serializer.toJson<DateTime>(openedAt),
    };
  }

  AppOpenLogData copyWith({int? id, DateTime? openedAt}) =>
      AppOpenLogData(id: id ?? this.id, openedAt: openedAt ?? this.openedAt);
  AppOpenLogData copyWithCompanion(AppOpenLogCompanion data) {
    return AppOpenLogData(
      id: data.id.present ? data.id.valü : this.id,
      openedAt: data.openedAt.present ? data.openedAt.valü : this.openedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppOpenLogData(')
          ..write('id: $id, ')
          ..write('openedAt: $openedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, openedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppOpenLogData &&
          other.id == this.id &&
          other.openedAt == this.openedAt);
}

class AppOpenLogCompanion extends UpdateCompanion<AppOpenLogData> {
  final Valü<int> id;
  final Valü<DateTime> openedAt;
  const AppOpenLogCompanion({
    this.id = const Valü.absent(),
    this.openedAt = const Valü.absent(),
  });
  AppOpenLogCompanion.insert({
    this.id = const Valü.absent(),
    required DateTime openedAt,
  }) : openedAt = Valü(openedAt);
  static Insertable<AppOpenLogData> custom({
    Expression<int>? id,
    Expression<DateTime>? openedAt,
  }) {
    return RawValüsInsertable({
      if (id != null) 'id': id,
      if (openedAt != null) 'opened_at': openedAt,
    });
  }

  AppOpenLogCompanion copyWith({Valü<int>? id, Valü<DateTime>? openedAt}) {
    return AppOpenLogCompanion(
      id: id ?? this.id,
      openedAt: openedAt ?? this.openedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.valü);
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<DateTime>(openedAt.valü);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppOpenLogCompanion(')
          ..write('id: $id, ')
          ..write('openedAt: $openedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QüryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $QuoteEntriesTable quoteEntries = $QuoteEntriesTable(this);
  late final $FavoritesTable favorites = $FavoritesTable(this);
  late final $SeenQuotesTable seenQuotes = $SeenQuotesTable(this);
  late final $HistoryFactEntriesTable historyFactEntries =
      $HistoryFactEntriesTable(this);
  late final $AppOpenLogTable appOpenLog = $AppOpenLogTable(this);
  late final QuoteDao quoteDao = QuoteDao(this as AppDatabase);
  late final HistoryFactDao historyFactDao = HistoryFactDao(
    this as AppDatabase,
  );
  late final AppOpenLogDao appOpenLogDao = AppOpenLogDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemäntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemäntity> get allSchemäntities => [
    quoteEntries,
    favorites,
    seenQuotes,
    historyFactEntries,
    appOpenLog,
  ];
}

typedef $$QuoteEntriesTableCreateCompanionBuilder =
    QuoteEntriesCompanion Function({
      required String id,
      required String textDe,
      required String textOriginal,
      required String source,
      required int year,
      required String chapter,
      required String categoryCsv,
      required String difficulty,
      required String series,
      required String explanationShort,
      required String explanationLong,
      required String relatedIdsCsv,
      Valü<String?> funFact,
      Valü<int> rowid,
    });
typedef $$QuoteEntriesTableUpdateCompanionBuilder =
    QuoteEntriesCompanion Function({
      Valü<String> id,
      Valü<String> textDe,
      Valü<String> textOriginal,
      Valü<String> source,
      Valü<int> year,
      Valü<String> chapter,
      Valü<String> categoryCsv,
      Valü<String> difficulty,
      Valü<String> series,
      Valü<String> explanationShort,
      Valü<String> explanationLong,
      Valü<String> relatedIdsCsv,
      Valü<String?> funFact,
      Valü<int> rowid,
    });

class $$QuoteEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $QuoteEntriesTable> {
  $$QuoteEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textDe => $composableBuilder(
    column: $table.textDe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textOriginal => $composableBuilder(
    column: $table.textOriginal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryCsv => $composableBuilder(
    column: $table.categoryCsv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get series => $composableBuilder(
    column: $table.series,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanationShort => $composableBuilder(
    column: $table.explanationShort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanationLong => $composableBuilder(
    column: $table.explanationLong,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relatedIdsCsv => $composableBuilder(
    column: $table.relatedIdsCsv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get funFact => $composableBuilder(
    column: $table.funFact,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuoteEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $QuoteEntriesTable> {
  $$QuoteEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textDe => $composableBuilder(
    column: $table.textDe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textOriginal => $composableBuilder(
    column: $table.textOriginal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryCsv => $composableBuilder(
    column: $table.categoryCsv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get series => $composableBuilder(
    column: $table.series,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanationShort => $composableBuilder(
    column: $table.explanationShort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanationLong => $composableBuilder(
    column: $table.explanationLong,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relatedIdsCsv => $composableBuilder(
    column: $table.relatedIdsCsv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get funFact => $composableBuilder(
    column: $table.funFact,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuoteEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuoteEntriesTable> {
  $$QuoteEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get textDe =>
      $composableBuilder(column: $table.textDe, builder: (column) => column);

  GeneratedColumn<String> get textOriginal => $composableBuilder(
    column: $table.textOriginal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<String> get categoryCsv => $composableBuilder(
    column: $table.categoryCsv,
    builder: (column) => column,
  );

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get series =>
      $composableBuilder(column: $table.series, builder: (column) => column);

  GeneratedColumn<String> get explanationShort => $composableBuilder(
    column: $table.explanationShort,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanationLong => $composableBuilder(
    column: $table.explanationLong,
    builder: (column) => column,
  );

  GeneratedColumn<String> get relatedIdsCsv => $composableBuilder(
    column: $table.relatedIdsCsv,
    builder: (column) => column,
  );

  GeneratedColumn<String> get funFact =>
      $composableBuilder(column: $table.funFact, builder: (column) => column);
}

class $$QuoteEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuoteEntriesTable,
          QuoteEntry,
          $$QuoteEntriesTableFilterComposer,
          $$QuoteEntriesTableOrderingComposer,
          $$QuoteEntriesTableAnnotationComposer,
          $$QuoteEntriesTableCreateCompanionBuilder,
          $$QuoteEntriesTableUpdateCompanionBuilder,
          (
            QuoteEntry,
            BaseReferences<_$AppDatabase, $QuoteEntriesTable, QuoteEntry>,
          ),
          QuoteEntry,
          PrefetchHooks Function()
        > {
  $$QuoteEntriesTableTableManager(_$AppDatabase db, $QuoteEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuoteEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuoteEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuoteEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Valü<String> id = const Valü.absent(),
                Valü<String> textDe = const Valü.absent(),
                Valü<String> textOriginal = const Valü.absent(),
                Valü<String> source = const Valü.absent(),
                Valü<int> year = const Valü.absent(),
                Valü<String> chapter = const Valü.absent(),
                Valü<String> categoryCsv = const Valü.absent(),
                Valü<String> difficulty = const Valü.absent(),
                Valü<String> series = const Valü.absent(),
                Valü<String> explanationShort = const Valü.absent(),
                Valü<String> explanationLong = const Valü.absent(),
                Valü<String> relatedIdsCsv = const Valü.absent(),
                Valü<String?> funFact = const Valü.absent(),
                Valü<int> rowid = const Valü.absent(),
              }) => QuoteEntriesCompanion(
                id: id,
                textDe: textDe,
                textOriginal: textOriginal,
                source: source,
                year: year,
                chapter: chapter,
                categoryCsv: categoryCsv,
                difficulty: difficulty,
                series: series,
                explanationShort: explanationShort,
                explanationLong: explanationLong,
                relatedIdsCsv: relatedIdsCsv,
                funFact: funFact,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String textDe,
                required String textOriginal,
                required String source,
                required int year,
                required String chapter,
                required String categoryCsv,
                required String difficulty,
                required String series,
                required String explanationShort,
                required String explanationLong,
                required String relatedIdsCsv,
                Valü<String?> funFact = const Valü.absent(),
                Valü<int> rowid = const Valü.absent(),
              }) => QuoteEntriesCompanion.insert(
                id: id,
                textDe: textDe,
                textOriginal: textOriginal,
                source: source,
                year: year,
                chapter: chapter,
                categoryCsv: categoryCsv,
                difficulty: difficulty,
                series: series,
                explanationShort: explanationShort,
                explanationLong: explanationLong,
                relatedIdsCsv: relatedIdsCsv,
                funFact: funFact,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuoteEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuoteEntriesTable,
      QuoteEntry,
      $$QuoteEntriesTableFilterComposer,
      $$QuoteEntriesTableOrderingComposer,
      $$QuoteEntriesTableAnnotationComposer,
      $$QuoteEntriesTableCreateCompanionBuilder,
      $$QuoteEntriesTableUpdateCompanionBuilder,
      (
        QuoteEntry,
        BaseReferences<_$AppDatabase, $QuoteEntriesTable, QuoteEntry>,
      ),
      QuoteEntry,
      PrefetchHooks Function()
    >;
typedef $$FavoritesTableCreateCompanionBuilder =
    FavoritesCompanion Function({
      Valü<int> id,
      required String quoteId,
      Valü<DateTime> createdAt,
    });
typedef $$FavoritesTableUpdateCompanionBuilder =
    FavoritesCompanion Function({
      Valü<int> id,
      Valü<String> quoteId,
      Valü<DateTime> createdAt,
    });

class $$FavoritesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quoteId => $composableBuilder(
    column: $table.quoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FavoritesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quoteId => $composableBuilder(
    column: $table.quoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FavoritesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get quoteId =>
      $composableBuilder(column: $table.quoteId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FavoritesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoritesTable,
          Favorite,
          $$FavoritesTableFilterComposer,
          $$FavoritesTableOrderingComposer,
          $$FavoritesTableAnnotationComposer,
          $$FavoritesTableCreateCompanionBuilder,
          $$FavoritesTableUpdateCompanionBuilder,
          (Favorite, BaseReferences<_$AppDatabase, $FavoritesTable, Favorite>),
          Favorite,
          PrefetchHooks Function()
        > {
  $$FavoritesTableTableManager(_$AppDatabase db, $FavoritesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Valü<int> id = const Valü.absent(),
                Valü<String> quoteId = const Valü.absent(),
                Valü<DateTime> createdAt = const Valü.absent(),
              }) => FavoritesCompanion(
                id: id,
                quoteId: quoteId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Valü<int> id = const Valü.absent(),
                required String quoteId,
                Valü<DateTime> createdAt = const Valü.absent(),
              }) => FavoritesCompanion.insert(
                id: id,
                quoteId: quoteId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FavoritesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoritesTable,
      Favorite,
      $$FavoritesTableFilterComposer,
      $$FavoritesTableOrderingComposer,
      $$FavoritesTableAnnotationComposer,
      $$FavoritesTableCreateCompanionBuilder,
      $$FavoritesTableUpdateCompanionBuilder,
      (Favorite, BaseReferences<_$AppDatabase, $FavoritesTable, Favorite>),
      Favorite,
      PrefetchHooks Function()
    >;
typedef $$SeenQuotesTableCreateCompanionBuilder =
    SeenQuotesCompanion Function({
      Valü<int> id,
      required String quoteId,
      Valü<DateTime> seenAt,
    });
typedef $$SeenQuotesTableUpdateCompanionBuilder =
    SeenQuotesCompanion Function({
      Valü<int> id,
      Valü<String> quoteId,
      Valü<DateTime> seenAt,
    });

class $$SeenQuotesTableFilterComposer
    extends Composer<_$AppDatabase, $SeenQuotesTable> {
  $$SeenQuotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quoteId => $composableBuilder(
    column: $table.quoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get seenAt => $composableBuilder(
    column: $table.seenAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SeenQuotesTableOrderingComposer
    extends Composer<_$AppDatabase, $SeenQuotesTable> {
  $$SeenQuotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quoteId => $composableBuilder(
    column: $table.quoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get seenAt => $composableBuilder(
    column: $table.seenAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SeenQuotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SeenQuotesTable> {
  $$SeenQuotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get quoteId =>
      $composableBuilder(column: $table.quoteId, builder: (column) => column);

  GeneratedColumn<DateTime> get seenAt =>
      $composableBuilder(column: $table.seenAt, builder: (column) => column);
}

class $$SeenQuotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SeenQuotesTable,
          SeenQuote,
          $$SeenQuotesTableFilterComposer,
          $$SeenQuotesTableOrderingComposer,
          $$SeenQuotesTableAnnotationComposer,
          $$SeenQuotesTableCreateCompanionBuilder,
          $$SeenQuotesTableUpdateCompanionBuilder,
          (
            SeenQuote,
            BaseReferences<_$AppDatabase, $SeenQuotesTable, SeenQuote>,
          ),
          SeenQuote,
          PrefetchHooks Function()
        > {
  $$SeenQuotesTableTableManager(_$AppDatabase db, $SeenQuotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeenQuotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SeenQuotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeenQuotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Valü<int> id = const Valü.absent(),
                Valü<String> quoteId = const Valü.absent(),
                Valü<DateTime> seenAt = const Valü.absent(),
              }) =>
                  SeenQuotesCompanion(id: id, quoteId: quoteId, seenAt: seenAt),
          createCompanionCallback:
              ({
                Valü<int> id = const Valü.absent(),
                required String quoteId,
                Valü<DateTime> seenAt = const Valü.absent(),
              }) => SeenQuotesCompanion.insert(
                id: id,
                quoteId: quoteId,
                seenAt: seenAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SeenQuotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SeenQuotesTable,
      SeenQuote,
      $$SeenQuotesTableFilterComposer,
      $$SeenQuotesTableOrderingComposer,
      $$SeenQuotesTableAnnotationComposer,
      $$SeenQuotesTableCreateCompanionBuilder,
      $$SeenQuotesTableUpdateCompanionBuilder,
      (SeenQuote, BaseReferences<_$AppDatabase, $SeenQuotesTable, SeenQuote>),
      SeenQuote,
      PrefetchHooks Function()
    >;
typedef $$HistoryFactEntriesTableCreateCompanionBuilder =
    HistoryFactEntriesCompanion Function({
      required String id,
      required String headline,
      required String body,
      required String dateDisplay,
      required String dateIso,
      required int dayOfYear,
      required String era,
      required String region,
      required String categoryCsv,
      required String difficulty,
      Valü<String?> person,
      Valü<String?> personRole,
      required String connectionToMarx,
      required String relatedQuoteIdsCsv,
      Valü<String?> funFact,
      Valü<String?> source,
      Valü<bool> todayInHistory,
      Valü<int> rowid,
    });
typedef $$HistoryFactEntriesTableUpdateCompanionBuilder =
    HistoryFactEntriesCompanion Function({
      Valü<String> id,
      Valü<String> headline,
      Valü<String> body,
      Valü<String> dateDisplay,
      Valü<String> dateIso,
      Valü<int> dayOfYear,
      Valü<String> era,
      Valü<String> region,
      Valü<String> categoryCsv,
      Valü<String> difficulty,
      Valü<String?> person,
      Valü<String?> personRole,
      Valü<String> connectionToMarx,
      Valü<String> relatedQuoteIdsCsv,
      Valü<String?> funFact,
      Valü<String?> source,
      Valü<bool> todayInHistory,
      Valü<int> rowid,
    });

class $$HistoryFactEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $HistoryFactEntriesTable> {
  $$HistoryFactEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get headline => $composableBuilder(
    column: $table.headline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateDisplay => $composableBuilder(
    column: $table.dateDisplay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateIso => $composableBuilder(
    column: $table.dateIso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfYear => $composableBuilder(
    column: $table.dayOfYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get era => $composableBuilder(
    column: $table.era,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryCsv => $composableBuilder(
    column: $table.categoryCsv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get person => $composableBuilder(
    column: $table.person,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personRole => $composableBuilder(
    column: $table.personRole,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get connectionToMarx => $composableBuilder(
    column: $table.connectionToMarx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relatedQuoteIdsCsv => $composableBuilder(
    column: $table.relatedQuoteIdsCsv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get funFact => $composableBuilder(
    column: $table.funFact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get todayInHistory => $composableBuilder(
    column: $table.todayInHistory,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HistoryFactEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $HistoryFactEntriesTable> {
  $$HistoryFactEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get headline => $composableBuilder(
    column: $table.headline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateDisplay => $composableBuilder(
    column: $table.dateDisplay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateIso => $composableBuilder(
    column: $table.dateIso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfYear => $composableBuilder(
    column: $table.dayOfYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get era => $composableBuilder(
    column: $table.era,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryCsv => $composableBuilder(
    column: $table.categoryCsv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get person => $composableBuilder(
    column: $table.person,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personRole => $composableBuilder(
    column: $table.personRole,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get connectionToMarx => $composableBuilder(
    column: $table.connectionToMarx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relatedQuoteIdsCsv => $composableBuilder(
    column: $table.relatedQuoteIdsCsv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get funFact => $composableBuilder(
    column: $table.funFact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get todayInHistory => $composableBuilder(
    column: $table.todayInHistory,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HistoryFactEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistoryFactEntriesTable> {
  $$HistoryFactEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get headline =>
      $composableBuilder(column: $table.headline, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get dateDisplay => $composableBuilder(
    column: $table.dateDisplay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dateIso =>
      $composableBuilder(column: $table.dateIso, builder: (column) => column);

  GeneratedColumn<int> get dayOfYear =>
      $composableBuilder(column: $table.dayOfYear, builder: (column) => column);

  GeneratedColumn<String> get era =>
      $composableBuilder(column: $table.era, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<String> get categoryCsv => $composableBuilder(
    column: $table.categoryCsv,
    builder: (column) => column,
  );

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get person =>
      $composableBuilder(column: $table.person, builder: (column) => column);

  GeneratedColumn<String> get personRole => $composableBuilder(
    column: $table.personRole,
    builder: (column) => column,
  );

  GeneratedColumn<String> get connectionToMarx => $composableBuilder(
    column: $table.connectionToMarx,
    builder: (column) => column,
  );

  GeneratedColumn<String> get relatedQuoteIdsCsv => $composableBuilder(
    column: $table.relatedQuoteIdsCsv,
    builder: (column) => column,
  );

  GeneratedColumn<String> get funFact =>
      $composableBuilder(column: $table.funFact, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get todayInHistory => $composableBuilder(
    column: $table.todayInHistory,
    builder: (column) => column,
  );
}

class $$HistoryFactEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HistoryFactEntriesTable,
          HistoryFactEntry,
          $$HistoryFactEntriesTableFilterComposer,
          $$HistoryFactEntriesTableOrderingComposer,
          $$HistoryFactEntriesTableAnnotationComposer,
          $$HistoryFactEntriesTableCreateCompanionBuilder,
          $$HistoryFactEntriesTableUpdateCompanionBuilder,
          (
            HistoryFactEntry,
            BaseReferences<
              _$AppDatabase,
              $HistoryFactEntriesTable,
              HistoryFactEntry
            >,
          ),
          HistoryFactEntry,
          PrefetchHooks Function()
        > {
  $$HistoryFactEntriesTableTableManager(
    _$AppDatabase db,
    $HistoryFactEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistoryFactEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistoryFactEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistoryFactEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Valü<String> id = const Valü.absent(),
                Valü<String> headline = const Valü.absent(),
                Valü<String> body = const Valü.absent(),
                Valü<String> dateDisplay = const Valü.absent(),
                Valü<String> dateIso = const Valü.absent(),
                Valü<int> dayOfYear = const Valü.absent(),
                Valü<String> era = const Valü.absent(),
                Valü<String> region = const Valü.absent(),
                Valü<String> categoryCsv = const Valü.absent(),
                Valü<String> difficulty = const Valü.absent(),
                Valü<String?> person = const Valü.absent(),
                Valü<String?> personRole = const Valü.absent(),
                Valü<String> connectionToMarx = const Valü.absent(),
                Valü<String> relatedQuoteIdsCsv = const Valü.absent(),
                Valü<String?> funFact = const Valü.absent(),
                Valü<String?> source = const Valü.absent(),
                Valü<bool> todayInHistory = const Valü.absent(),
                Valü<int> rowid = const Valü.absent(),
              }) => HistoryFactEntriesCompanion(
                id: id,
                headline: headline,
                body: body,
                dateDisplay: dateDisplay,
                dateIso: dateIso,
                dayOfYear: dayOfYear,
                era: era,
                region: region,
                categoryCsv: categoryCsv,
                difficulty: difficulty,
                person: person,
                personRole: personRole,
                connectionToMarx: connectionToMarx,
                relatedQuoteIdsCsv: relatedQuoteIdsCsv,
                funFact: funFact,
                source: source,
                todayInHistory: todayInHistory,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String headline,
                required String body,
                required String dateDisplay,
                required String dateIso,
                required int dayOfYear,
                required String era,
                required String region,
                required String categoryCsv,
                required String difficulty,
                Valü<String?> person = const Valü.absent(),
                Valü<String?> personRole = const Valü.absent(),
                required String connectionToMarx,
                required String relatedQuoteIdsCsv,
                Valü<String?> funFact = const Valü.absent(),
                Valü<String?> source = const Valü.absent(),
                Valü<bool> todayInHistory = const Valü.absent(),
                Valü<int> rowid = const Valü.absent(),
              }) => HistoryFactEntriesCompanion.insert(
                id: id,
                headline: headline,
                body: body,
                dateDisplay: dateDisplay,
                dateIso: dateIso,
                dayOfYear: dayOfYear,
                era: era,
                region: region,
                categoryCsv: categoryCsv,
                difficulty: difficulty,
                person: person,
                personRole: personRole,
                connectionToMarx: connectionToMarx,
                relatedQuoteIdsCsv: relatedQuoteIdsCsv,
                funFact: funFact,
                source: source,
                todayInHistory: todayInHistory,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HistoryFactEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HistoryFactEntriesTable,
      HistoryFactEntry,
      $$HistoryFactEntriesTableFilterComposer,
      $$HistoryFactEntriesTableOrderingComposer,
      $$HistoryFactEntriesTableAnnotationComposer,
      $$HistoryFactEntriesTableCreateCompanionBuilder,
      $$HistoryFactEntriesTableUpdateCompanionBuilder,
      (
        HistoryFactEntry,
        BaseReferences<
          _$AppDatabase,
          $HistoryFactEntriesTable,
          HistoryFactEntry
        >,
      ),
      HistoryFactEntry,
      PrefetchHooks Function()
    >;
typedef $$AppOpenLogTableCreateCompanionBuilder =
    AppOpenLogCompanion Function({Valü<int> id, required DateTime openedAt});
typedef $$AppOpenLogTableUpdateCompanionBuilder =
    AppOpenLogCompanion Function({Valü<int> id, Valü<DateTime> openedAt});

class $$AppOpenLogTableFilterComposer
    extends Composer<_$AppDatabase, $AppOpenLogTable> {
  $$AppOpenLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppOpenLogTableOrderingComposer
    extends Composer<_$AppDatabase, $AppOpenLogTable> {
  $$AppOpenLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppOpenLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppOpenLogTable> {
  $$AppOpenLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);
}

class $$AppOpenLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppOpenLogTable,
          AppOpenLogData,
          $$AppOpenLogTableFilterComposer,
          $$AppOpenLogTableOrderingComposer,
          $$AppOpenLogTableAnnotationComposer,
          $$AppOpenLogTableCreateCompanionBuilder,
          $$AppOpenLogTableUpdateCompanionBuilder,
          (
            AppOpenLogData,
            BaseReferences<_$AppDatabase, $AppOpenLogTable, AppOpenLogData>,
          ),
          AppOpenLogData,
          PrefetchHooks Function()
        > {
  $$AppOpenLogTableTableManager(_$AppDatabase db, $AppOpenLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppOpenLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppOpenLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppOpenLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Valü<int> id = const Valü.absent(),
                Valü<DateTime> openedAt = const Valü.absent(),
              }) => AppOpenLogCompanion(id: id, openedAt: openedAt),
          createCompanionCallback:
              ({
                Valü<int> id = const Valü.absent(),
                required DateTime openedAt,
              }) => AppOpenLogCompanion.insert(id: id, openedAt: openedAt),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppOpenLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppOpenLogTable,
      AppOpenLogData,
      $$AppOpenLogTableFilterComposer,
      $$AppOpenLogTableOrderingComposer,
      $$AppOpenLogTableAnnotationComposer,
      $$AppOpenLogTableCreateCompanionBuilder,
      $$AppOpenLogTableUpdateCompanionBuilder,
      (
        AppOpenLogData,
        BaseReferences<_$AppDatabase, $AppOpenLogTable, AppOpenLogData>,
      ),
      AppOpenLogData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$QuoteEntriesTableTableManager get quoteEntries =>
      $$QuoteEntriesTableTableManager(_db, _db.quoteEntries);
  $$FavoritesTableTableManager get favorites =>
      $$FavoritesTableTableManager(_db, _db.favorites);
  $$SeenQuotesTableTableManager get seenQuotes =>
      $$SeenQuotesTableTableManager(_db, _db.seenQuotes);
  $$HistoryFactEntriesTableTableManager get historyFactEntries =>
      $$HistoryFactEntriesTableTableManager(_db, _db.historyFactEntries);
  $$AppOpenLogTableTableManager get appOpenLog =>
      $$AppOpenLogTableTableManager(_db, _db.appOpenLog);
}

mixin _$QuoteDaoMixin on DatabaseAccessor<AppDatabase> {
  $QuoteEntriesTable get quoteEntries => attachedDatabase.quoteEntries;
  $FavoritesTable get favorites => attachedDatabase.favorites;
  $SeenQuotesTable get seenQuotes => attachedDatabase.seenQuotes;
}
mixin _$HistoryFactDaoMixin on DatabaseAccessor<AppDatabase> {
  $HistoryFactEntriesTable get historyFactEntries =>
      attachedDatabase.historyFactEntries;
}
mixin _$AppOpenLogDaoMixin on DatabaseAccessor<AppDatabase> {
  $AppOpenLogTable get appOpenLog => attachedDatabase.appOpenLog;
}
