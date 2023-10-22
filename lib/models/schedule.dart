class Schedule {
  String? dayOfWeek;
  String? startTime;
  String? endTime;
  String? user;

  Schedule(
    this.dayOfWeek,
    this.startTime,
    this.endTime,
    this.user,
  );

  Schedule.scheduleWithThreeParameters(
      {this.dayOfWeek, this.startTime, this.endTime});
}
