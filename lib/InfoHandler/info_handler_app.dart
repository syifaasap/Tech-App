import 'package:flutter/foundation.dart';
import 'package:tech_app/Models/service_history_model.dart';

import 'direction_handler.dart';

class InfoApp extends ChangeNotifier {
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalService = 0;
  String technicianTotalEarnings = "0";
  String technicianAverageRatings = "0";
  List<String> historyServiceKeysList = [];
  List<ServiceHistoryModel> allServiceHistoryInformationList = [];

  void updatePickUpLocationAddress(Directions userPickUpAddress) {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress) {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }

  updateOverAllServiceCounter(int overAllServiceCounter) {
    countTotalService = overAllServiceCounter;
    notifyListeners();
  }

  updateOverAllServiceKeys(List<String> serviceKeysList) {
    historyServiceKeysList = serviceKeysList;
    notifyListeners();
  }

  updateOverAllServiceHistoryInformation(
      ServiceHistoryModel eachServiceHistory) {
    allServiceHistoryInformationList.add(eachServiceHistory);
    notifyListeners();
  }

  updateTechnicianTotalEarnings(technicianEarnings) {
    technicianTotalEarnings = technicianEarnings;
  }

  updateTechnicianAverageRatings(technicianRatings) {
    technicianAverageRatings = technicianRatings;
  }
}
