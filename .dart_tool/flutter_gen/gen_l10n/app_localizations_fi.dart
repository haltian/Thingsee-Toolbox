import 'app_localizations.dart';

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get installerTitle => 'Thingsee Toolbox';

  @override
  String get removeStack => 'Poista stack?';

  @override
  String get remove => 'Poista';

  @override
  String get cancel => 'Peruuta';

  @override
  String get areYouSureYouWantToDeleteStack => 'Oletko varma että haluat poistaa stackin käyttäjältä? Stack pysyy saatavilla järjestelmässä.';

  @override
  String clientID(String id) {
    return 'Asiakastunnus: $id';
  }

  @override
  String path(String path) {
    return 'Polku: $path';
  }

  @override
  String get ok => 'OK';

  @override
  String get info => 'Tiedot';

  @override
  String get addNewStack => 'Lisää uusi stack';

  @override
  String get stackAddedSuccessfully => 'Stackin lisäys onnistui';

  @override
  String get stackDeletedSuccessfully => 'Stack poistettu onnistuneesti';

  @override
  String get youHaveNotTakenStacksToUse => 'Et ole ottanut yhtään\nThingsee stackiä käyttöön.';

  @override
  String get noResults => 'Ei tuloksia';

  @override
  String get filter => 'Rajaus';

  @override
  String get errorOccured => 'Virhe tapahtui';

  @override
  String get error => 'Virhe: ';

  @override
  String get problemConnectingToServers => 'Virhe yhdistäessä palvelimille';

  @override
  String get somethingWentWrong => 'Jokin meni pieleen';

  @override
  String get edit => 'Muokkaa';

  @override
  String get envProduction => 'pr - Tuotanto';

  @override
  String get envDevelopment => 'rd - Kehitys';

  @override
  String get envDemo => 'dm - Demo';

  @override
  String get envUnassigned => 'un - Määrittelemätön';

  @override
  String get environment => 'Ympäristö';

  @override
  String get selectEnvironment => 'Valitse ympäristö';

  @override
  String get country => 'Maa';

  @override
  String get selectCountry => 'Valitse maa';

  @override
  String get search => 'Etsi';

  @override
  String get name => 'Nimi';

  @override
  String get enterGroupName => 'Syötä ryhmän nimi';

  @override
  String get description => 'Kuvaus';

  @override
  String get enterGroupDescription => 'Syötä ryhmän kuvaus';

  @override
  String get environmentNameWillBe => 'Laiteryhmän nimi tulee olemaan';

  @override
  String get addGroup => 'Lisää ryhmä';

  @override
  String get addNewDeploymentGroup => 'Lisää uusi laiteryhmä';

  @override
  String get groupCreatedSuccessfully => 'Ryhmä luotiin onnistuneesti';

  @override
  String get groupDeletedSuccessfully => 'Ryhmä poistettiin onnistuneesti';

  @override
  String get areYouSureYouWantToDeleteGroup => 'Oletko varma että haluat poistaa tämän laiteryhmän? Kaikki tämän ryhmän laitteet siirretään ryhmään “Unassigned”.';

  @override
  String get removeDeploymentGroup => 'Poista laiteryhmä?';

  @override
  String get thereAreNoDeploymentGroups => 'Tässä stackissä ei ole\nyhtään laiteryhmää.';

  @override
  String get addNewGroup => 'Lisää uusi ryhmä';

  @override
  String get thereAreNoDevices => 'Tässä ryhmässä ei ole yhtään laitetta.';

  @override
  String get addNewDevice => 'Lisää uusi laite';

  @override
  String get deviceInfo => 'Laitteen tiedot';

  @override
  String get welcomeToThingseeInstaller => 'Tervetuloa käyttämään Thingsee Toolboxia!\n\nAloita syöttämällä stackin tiedot.';

  @override
  String get editDeploymentGroup => 'Muokkaa laiteryhmää';

  @override
  String get saveChanges => 'Tallenna muutokset';

  @override
  String get editDevice => 'Muokkaa laitetta';

  @override
  String get tuid => 'TUID';

  @override
  String get installed => 'Asennettu';

  @override
  String get newInstallation => 'Uusi';

  @override
  String get quarantine => 'Karanteenissa';

  @override
  String get retired => 'Poistettu käytöstä';

  @override
  String get uninstalled => 'Asentamaton';

  @override
  String get installationStatus => 'Asennuksen tila';

  @override
  String get visitorCounter => 'Vierailija laskuri';

  @override
  String get occupancy => 'Läsnäolo';

  @override
  String get eventBased => 'Tapahtumaan perustuva';

  @override
  String get locationIn => 'Sisällä';

  @override
  String get locationOut => 'Ulkona';

  @override
  String get defaultMode => 'Oletus';

  @override
  String get fixedInterval => 'Muuttumaton aikaväli';

  @override
  String get operatingMode => 'Toimintatila';

  @override
  String get disabled => 'Pois käytöstä';

  @override
  String get save => 'Tallenna';

  @override
  String get orientation => 'Suunta';

  @override
  String mumModeAccelerometer(String newline) {
    return 'MUM-tila$newline(kiihtyvyysanturi)';
  }

  @override
  String get installationLocation => 'Asennuspaikka';

  @override
  String get deploymentGroup => 'Laiteryhmä';

  @override
  String get replaceDevice => 'Korvaa laite';

  @override
  String get readQrCode => 'Lue QR-koodi';

  @override
  String hallModeMagneticSensor(String newline) {
    return 'Hall-tila$newline(magneettinen${newline}anturi)';
  }

  @override
  String get replace => 'Korvaa';

  @override
  String get deviceAddedSuccessfully => 'Laite lisättiin onnistuneesti';

  @override
  String get deviceDeletedSuccessfully => 'Laite poistettiin onnistuneesti';

  @override
  String get sameDevice => 'Sama laite. Ole hyvä ja lue QR koodi laitteesta joka korvaa tämän laitteen.';

  @override
  String get unknownQRcode => 'Tuntematon QR kood!\nVarmista, että luet vain yhden QR-koodin kerrallaan';

  @override
  String get cameraPermissionNotGranted => 'Et ole antanut lupaa käyttää kameraa.';

  @override
  String get areYouSureYouWantToDeleteDevice => 'Oletko varma että haluat poistaa laitteen? Se siirretään “Unassigned” ryhmään.';

  @override
  String get removeDevice => 'Poista laite';

  @override
  String get deviceReplacedSuccessfully => 'Laite korvattiin onnistuneesti';

  @override
  String get originalDevice => 'Alkuperäinen laite';

  @override
  String get replaceWith => 'Korvaa laitteella';

  @override
  String get deviceStatus => 'Laiteen tila';

  @override
  String get online => 'Päällä';

  @override
  String offlineLastSeen(String offline) {
    return 'Pois päältä, viimeksi verkossa: $offline';
  }

  @override
  String get batteryLevel => 'Paristo';

  @override
  String get deviceEvents => 'Viestit';

  @override
  String get deviceUpdated => 'Laitteen tiedot päivitetty onnistuneesti';

  @override
  String vibration(num? activityLevel, num? energyLevel) {
    return 'Tärinä: $activityLevel Energia: $energyLevel';
  }

  @override
  String get accConfig => 'Kiihtyvysmittaus konfiguraatio ';

  @override
  String get systemInfo => 'Järjestelmä data';

  @override
  String get infoRequest => 'Järjestelmä informaatio pyyntö';

  @override
  String get infoRequestUnv => 'Informaatiota ei ole saatavilla';

  @override
  String weatherInfoAirp(String airp) {
    return 'Ilmanpaine: $airp hPa ';
  }

  @override
  String weatherInfoHumd(num? humd) {
    return 'Ilmankosteus: $humd% ';
  }

  @override
  String weatherInfoTemp(num? temp) {
    return 'Lämpötila: $temp°C ';
  }

  @override
  String weatherInfoLght(num? lght) {
    return 'Valoisuus: $lght lux ';
  }

  @override
  String magnetoInfo(num? hall, num? hallCount) {
    return 'Magneetti: $hall Muutokset: $hallCount';
  }

  @override
  String leakageResistance(num? res) {
    return 'Vuoto resistanssi: $res';
  }

  @override
  String sensorConfig(int tsmId) {
    return 'Sensorin konfiguraatio viesti: $tsmId';
  }

  @override
  String get batteryInfo => 'Paristodata info';

  @override
  String get ping => 'Yhteyskokeilu';

  @override
  String moveCount(num? moveCount) {
    return 'Liike määrä: $moveCount';
  }

  @override
  String count(num? count) {
    return 'Määrä: $count';
  }

  @override
  String get heartbeat => 'Syke';

  @override
  String gatewayMessage(String gatewayMessage) {
    return 'Tukiaseman viesti: $gatewayMessage';
  }

  @override
  String get edgeCoreChange => 'Edge core tilan muutos';

  @override
  String get edgeCoreStats => 'Edge core statistiikan diagnostiikkan pyyntö';

  @override
  String get edgeCoreBinary => 'Edge core binääri tapahtuma';

  @override
  String get jamDetection => 'Tukos tunnistus info';

  @override
  String angle(num? angle) {
    return 'Kulma: $angle°';
  }

  @override
  String temperature(num? temperature) {
    return 'Lämpötila: $temperature°C';
  }

  @override
  String distance(num? dist) {
    return 'Etäisyys: $dist mm';
  }

  @override
  String beamInfo(num? dist) {
    return 'Etäisyys: $dist mm';
  }

  @override
  String get beam2d => 'Beam 2D alue';

  @override
  String get ledControl => 'LED kontrolli pyyntö';

  @override
  String get devices => 'Laitteet';

  @override
  String get logs => 'Lokit';

  @override
  String get more => 'Lisää';

  @override
  String get noBattery => 'Paristo dataa ei ole saatavilla';

  @override
  String neighbouringData(num? rssi) {
    return 'Sensoriverkon data\nRSSI:$rssi';
  }

  @override
  String get help => 'Ohje';

  @override
  String get goToHelp => 'Siirry Haltian support sivulle';

  @override
  String get licenses => 'Lisenssit';

  @override
  String get export => 'Luo csv';

  @override
  String get stopRecording => 'Lopeta tallennus';

  @override
  String get startRecording => 'Aloita tallennus';

  @override
  String get deleteLogFile => 'Poista lokitiedosto?';

  @override
  String get areYouSureDeleteLogFile => 'Oletko varma että haluat poistaa lokitiedoston?';

  @override
  String get recordingOn => 'Tallennus päällä';

  @override
  String get recordingOff => 'Tallennus pois päältä';

  @override
  String get logFileDeleted => 'Lokitiedosto poistettu';

  @override
  String get noEventsInThisLogFile => 'Tässä lokissa ei ole tapahtumia';

  @override
  String get addingADevice => 'Laitteen lisääminen';

  @override
  String get replacingADevice => 'Laitteen korvaaminen';

  @override
  String get editingADevice => 'Laitteen muokkaaminen';

  @override
  String get removingADevice => 'Laitteen poistaminen';

  @override
  String get deviceAdded => 'Laite lisätty';

  @override
  String get deviceReplaced => 'Laite korvattu';

  @override
  String get deviceEdited => 'Laitetta muokattu';

  @override
  String get deviceRemoved => 'Laite poistettu';

  @override
  String get title => 'Otsikko';

  @override
  String get enterTitle => 'Syötä otsikko';

  @override
  String get enterDescription => 'Syötä kuvaus';

  @override
  String get eventsIncludedInTheLog => 'Lokiin sisältyvät tapahtumat:';

  @override
  String get addNewLogFile => 'Lisää uusi lokitiedosto';

  @override
  String get editLogFile => 'Muokkaa lokitiedostoa';

  @override
  String get addLog => 'Lisää loki';

  @override
  String get deleteLogEntry => 'Poista lokimerkintä';

  @override
  String get goToLicenses => 'Käytössä tässä sovelluksessa';

  @override
  String version(String version) {
    return 'Versio: $version';
  }

  @override
  String copyright(String year) {
    return 'Tekijänoikeus $year Haltian';
  }

  @override
  String get removeLogEntry => 'Poista lokimerkintä?';

  @override
  String get areYouSureDeleteLogEntry => 'Oletko varma että haluat poistaa tämän lokimerkinnän?';

  @override
  String get device => 'Laite';

  @override
  String get note => 'Viesti';

  @override
  String get oldDevice => 'Vanha laite';

  @override
  String get installationNotes => 'Asennus viesti';

  @override
  String get logEntryDeleted => 'Lokimerkintä poistettu';

  @override
  String get thisNoteIsStoredInYourDevice => 'Tämä viesti tallennetaan laitteeseesi ja on vain näkyvissä lokissa.';

  @override
  String get newDevice => 'Uusi laite';

  @override
  String get offline => 'Pois päältä';

  @override
  String carbonInfo(num? carbonDioxide) {
    return 'CO2: $carbonDioxide ppm';
  }

  @override
  String tvocInfo(num? tvoc) {
    return 'TVOC: $tvoc ppm';
  }

  @override
  String get carbonConfig => 'Hiilidioksidien konfiguraatio';

  @override
  String get carbonManual => 'Hiilidioksidi tasojen manuaalinen kalibrointi';

  @override
  String get tvocConfig => 'Haihtuvat orgaaniset yhdisteiden konfiguraatio';

  @override
  String get carbonHardware => 'Hiilidioksidi antureiden komponentti versiot';

  @override
  String get tvocReset => 'Haihtuvat orgaaniset yhdiste resetointi ';

  @override
  String countInOut(int? countIn, int? out) {
    return 'Sisään: $countIn Ulos: $out';
  }

  @override
  String get group => 'Ryhmä';

  @override
  String get noLogsAdded => 'Ei lokeja';

  @override
  String get enterTuid => 'Syötä TUID';

  @override
  String batl(int? batl) {
    return 'Paristo taso: $batl %';
  }

  @override
  String orientationMsg(num? accx, num? accy, num? accz) {
    return 'Suunta - x: $accx - y: $accy - z: $accz';
  }

  @override
  String celluralRfDataRat(String? cellRat) {
    return 'Rat: $cellRat ';
  }

  @override
  String celluralRfDataRssi(num? cellRssi) {
    return 'RSSI: $cellRssi ';
  }

  @override
  String cellularInfoMccMnc(String? cellMccMnc) {
    return 'MccMnc: $cellMccMnc ';
  }

  @override
  String cellularInfoOperator(String? operatorName) {
    return 'Operaattori: $operatorName ';
  }

  @override
  String systemMessage(int msgId) {
    return 'Järjestelmäviesti: $msgId';
  }

  @override
  String occupancyMode(num? state) {
    return 'Tila: $state';
  }

  @override
  String get exportingCsvFailed => 'CSV:n luominen epäonnistui';

  @override
  String get csvSavedToDownloadsFolder => 'CSV tallennettu \'lataukset\' kansioon';

  @override
  String get csvSaved => 'CSV tallennettu';

  @override
  String get enterTuidOrReadQR => 'Syötä TUID tai lue QR-koodi';

  @override
  String get firmwareVersion => 'Laiteohjelmisto  versio';

  @override
  String get logFileUpdated => 'Lokitiedosto päivitetty';

  @override
  String get deviceNotFound => 'Laitetta ei löytynyt aktiivisesta stackistä';

  @override
  String get networkDisconnected => 'Verkkoyhteys katkennut';

  @override
  String get networkConnected => 'Verkko yhdistetty';

  @override
  String powerCoverMessage(String usbpwr) {
    return 'Power cover\nUSB-kytketty: $usbpwr';
  }

  @override
  String get wirepassNode => 'Wirepas noodi viesti';

  @override
  String get usbPowered => 'USB-virtajohto';

  @override
  String get never => 'Ei ikinä';

  @override
  String get yes => 'Kyllä';

  @override
  String get no => 'Ei';

  @override
  String celluralRfDataRsrp(num? cellRsrp) {
    return 'RSRP: $cellRsrp ';
  }

  @override
  String get addingStackFailed => 'Stackin lisäys epäonnistui';

  @override
  String get stackAlreadyExists => 'Stack on jo olemassa';

  @override
  String get clientDetails => 'Asiakastiedot';

  @override
  String get secret => 'Salasana';

  @override
  String get pathTitle => 'Polku';

  @override
  String get acceloremeter => 'MUM-tila';

  @override
  String get hallMode => 'Hall-tila';

  @override
  String get selectGroup => 'Valitse ryhmä';

  @override
  String get thingseeStack => 'Thingsee pino';

  @override
  String get replacementDeviceCantBeDifferentType => 'Korvaava laite ei voi olla eri laitetyyppiä';

  @override
  String get enabled => 'Käytössä';

  @override
  String amountIn(num? amountIn) {
    return 'Sisällä: $amountIn';
  }

  @override
  String get testMode => 'Testaustila, ole hyvä ja vaihda toimintatila';
}
