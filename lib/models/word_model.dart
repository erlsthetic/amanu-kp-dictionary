class KPWord {
  final int wordID;
  final String word;
  final String normalWord;
  final List<String> engTranslation;
  final List<String> filTranslation;
  final String phonetic;
  final String pronunciationLink;

  final List<dynamic> meanings;

  final List<String> kulitanForm;

  final List<String> synonyms;
  final List<String> antonyms;
  final List<String> relatedWords;
  final List<String> searchIndex;

  final int contributorID;
  final int expertID;
  final String dateUpdated;
  final List<String> sourceRef;

  KPWord(
    this.wordID,
    this.word,
    this.normalWord,
    this.engTranslation,
    this.filTranslation,
    this.phonetic,
    this.pronunciationLink,
    this.meanings,
    this.kulitanForm,
    this.synonyms,
    this.antonyms,
    this.relatedWords,
    this.searchIndex,
    this.contributorID,
    this.expertID,
    this.dateUpdated,
    this.sourceRef,
  );
}
