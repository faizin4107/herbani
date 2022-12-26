import 'package:get/get.dart';

mixin GlobalList {
  var category = ''.obs;
  setCategory(String val) {
    category.value = val;
  }

  var currentMax = 20.obs;
  setCurrentMax(int val) {
    currentMax.value = val;
  }

   

  var listSearch = [].obs;
  setListSearch(List<dynamic> val) {
    listSearch.value = val;
  }

  var touch = false.obs;
  setIsTouch(bool val) {
    touch.value = val;
  }

  var search = false.obs;
  setSearch(bool val) {
    search.value = val;
  }

  var tapSearch = false.obs;
  setTapSearch(bool val) {
    tapSearch.value = val;
  }

  var messageError = ''.obs;
  setMessageError(String val) {
    messageError.value = val;
  }

  var messageEmpty = ''.obs;
  setMessageEmpty(String val) {
    messageEmpty.value = val;
  }

  var title = ''.obs;
  setTitle(String val) {
    title.value = val;
  }

  var listFields = [].obs;
  setListFields(List<dynamic> val) {
    listFields.value = val;
  }

  var listRecords = [].obs;
  setListRecords(List<dynamic> val) {
    listRecords.value = val;
  }

  var records = [].obs;
  setRecords(List<dynamic> val) {
    records.value = val;
  }

  var loadingField = false.obs;
  setLoadingField(bool val) {
    loadingField.value = val;
  }

  var sayingTime = {}.obs;
  setSayingTime(Map val) {
    sayingTime.value = val;
  }

  var listMap = {}.obs;
  setListMap(Map val) {
    listMap.value = val;
  }

  var textWelcome = [].obs;
  setTextWelcome(List<dynamic> val) {
    textWelcome.value = val;
  }

  var indexWelcome = 0.obs;
  setIndexWelcome(int val) {
    indexWelcome.value = val;
  }

  var fields = [].obs;
  setFields(List<dynamic> val) {
    fields.value = val;
  }

  var button = ''.obs;
  setButton(String val) {
    button.value = val;
  }

  var detail = false.obs;
  setDetail(bool val) {
    detail.value = val;
  }

  Future initGetData() async {
    setFields([]);
    setMessageError('');
    setMessageEmpty('');
    setDetail(false);
    setTitle('');
    setSayingTime({});
    setTextWelcome([]);
    setIndexWelcome(0);
    setLoadingField(false);
    setSearch(false);
    setTapSearch(false);
    setIsTouch(false);
    setListRecords([]);
    setListFields([]);
    setListSearch([]);
    setRecords([]);
    setCurrentMax(20);
    setListMap({});
  }
}
