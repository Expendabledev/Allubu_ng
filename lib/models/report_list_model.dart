class ReportListModel {
  List<ReportCategories>? reportCategories;

  ReportListModel({this.reportCategories});

  ReportListModel.fromJson(Map<String, dynamic> json) {
    if (json['report_categories'] != null) {
      reportCategories = <ReportCategories>[];
      json['report_categories'].forEach((v) {
        reportCategories!.add(ReportCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (reportCategories != null) {
      data['report_categories'] =
          reportCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReportCategories {
  List<String>? reports;
  String? category;

  ReportCategories({this.reports, this.category});

  ReportCategories.fromJson(Map<String, dynamic> json) {
    reports = json['reports'].cast<String>();
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reports'] = reports;
    data['category'] = category;
    return data;
  }
}
