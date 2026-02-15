class CurrencyModel {
   
  late String denominationAr;
  late String denominationEn;

  CurrencyModel.fromJson(Map<String,dynamic> json){
    final List currencies;
    currencies = json['currencies'] ?? [];
    if(currencies.isEmpty ){
      denominationAr='لم استطع تحديدالعملة , حاول مجددا . ';
      denominationEn='Canot detect the currency , try again .';

    }else{
       denominationAr= currencies[0]['denomination_ar'] ?? 'لم استطع تحديدالعملة , حاول مجددا . ';
       denominationEn= currencies[0]['denomination_en'] ?? 'Canot detect the currency , try again .' ;
    }
  }

}