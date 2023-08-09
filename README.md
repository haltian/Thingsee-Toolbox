# Thingsee Toolbox

## To generate JSON factory classes

create new class for json according the example in https://pub.dev/packages/json_serializable/example and then execute:

flutter pub run build_runner build --delete-conflicting-outputs

to generate factory classes from serializing JSON


## To update Localizations
edit the file 'lib/l10n/app_en.arb' and 'lib/l10n/app_fi.arb' and then run the application

## To run tests
execute 'flutter test test/unit_tests' in thingsee-installer directory