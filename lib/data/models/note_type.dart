enum NoteType {
  content(str: "內容筆記"),
  experience(str:"經驗"),
  action(str:"行動"),
  thought(str:"連結想法");

  final String str;
  const NoteType({required this.str});

} 

