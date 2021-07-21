enum ShowDateTimeStyle { datetime, time, timestamp, none }

ShowDateTimeStyle styleById(int id) {
  switch (id) {
    case 0:
      return ShowDateTimeStyle.datetime;
    case 1:
      return ShowDateTimeStyle.time;
    case 2:
      return ShowDateTimeStyle.timestamp;
    case 3:
      return ShowDateTimeStyle.none;
    default:
      return ShowDateTimeStyle.datetime;
  }
}

int idByStyle(ShowDateTimeStyle style) {
  switch (style) {
    case ShowDateTimeStyle.datetime:
      return 0;
    case ShowDateTimeStyle.time:
      return 1;
    case ShowDateTimeStyle.timestamp:
      return 2;
    case ShowDateTimeStyle.none:
      return 3;
  }
}
