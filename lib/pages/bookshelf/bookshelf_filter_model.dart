enum BookStateFilter { 
  waiting(str:  "待讀"),
  reading(str: "在讀"),
  finish(str: "已完成"),
  suspended(str: "已暫停"),
  giveup(str: "已放棄");

  final String str;

  const BookStateFilter({required this.str});
  
 }