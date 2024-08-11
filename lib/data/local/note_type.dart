enum NoteType {
  content(displayName: "內容筆記"),
  experience(displayName: "經驗"),
  action(displayName: "行動"),
  thought(displayName: "連結想法");

  final String displayName;
  const NoteType({required this.displayName});
}
