enum BookState { 
  waiting(displayName:  "待讀"),
  reading(displayName: "在讀"),
  finished(displayName: "已完成"),
  suspended(displayName: "已暫停"),
  giveup(displayName: "已放棄");

  final String displayName;

  const BookState({required this.displayName});
  
 }