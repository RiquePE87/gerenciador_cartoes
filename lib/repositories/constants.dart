const String keyCreditCardTable = "creditCard";
const String keyDebitTable = "debit";
const String keyOwnerTable = "owner";
const String keyOwnerDebitTable = "owner_debit";

const String keyIdCreditCard = "id";
const String keyNameCreditCard = "name";
const String keyPayDayCreditCard = "payday";
const String keyBestDayCreditCard = "bestday";
const String keyUsedLimitCreditCard = "usedlimit";
const String keyLimitCreditCard = "limitcredit";

const String keyIdDebit = "id";
const String keyDescriptionDebit = "description";
const String keyValueDebit = "value";
const String keyQuotaDebit = "quota";
const String keyPurchaseDate = "purchasedate";
const String keyCreditCardIdDebit = "creditCardID";
const String keyBestDayDebit = "bestday";
//

const String keyIdOwner = "id";
const String keyNameOwner = "name";

const String keyIDdOwnerDebit = "id";
const String keyDebitIDOwnerDebit = "debit_id";
const String keyOwnerIDOwnerDebit = "owner_id";
const String keyCreditCardIDOwnerDebit = "credit_card_id";

const String DATABASE = "database.db";

const List<String> MONTHS = ["Nulo", "Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul","Ago", "Set", "Out", "Nov", "Dez"];

const String CREATE_CREDIT_CARD_TABLE = "CREATE TABLE $keyCreditCardTable"
    "($keyIdCreditCard INTEGER PRIMARY KEY AUTOINCREMENT,"
    " $keyNameCreditCard TEXT NOT NULL,"
    " $keyPayDayCreditCard INTEGER NOT NULL,"
    " $keyBestDayCreditCard INTEGER NOT NULL,"
    " $keyUsedLimitCreditCard REAL NOT NULL,"
    " $keyLimitCreditCard REAL NOT NULL)";

const String CREATE_DEBIT_TABLE = "CREATE TABLE $keyDebitTable"
    "($keyIdDebit INTEGER PRIMARY KEY AUTOINCREMENT,"
    "$keyDescriptionDebit TEXT NOT NULL,"
    "$keyValueDebit REAL NOT NULL,"
    "$keyQuotaDebit INTEGER NOT NULL,"
    "$keyPurchaseDate STRING NOT NULL,"
    "$keyBestDayDebit STRING NOT NULL,"
    "$keyCreditCardIdDebit INTEGER NOT NULL,"
    "FOREIGN KEY ($keyCreditCardIdDebit) REFERENCES $keyCreditCardTable($keyIdCreditCard) ON DELETE CASCADE)";

const String CREATE_OWNER_TABLE = "CREATE TABLE $keyOwnerTable ("
    "$keyIdOwner INTEGER PRIMARY KEY AUTOINCREMENT,"
    "$keyNameOwner TEXT NOT NULL)";

const String CREATE_OWNER_DEBIT_TABLE = "CREATE TABLE $keyOwnerDebitTable ("
    "$keyIDdOwnerDebit INTEGER PRIMARY KEY AUTOINCREMENT,"
    "$keyDebitIDOwnerDebit INTEGER NOT NULL,"
    "$keyOwnerIDOwnerDebit INTEGER NOT NULL,"
    "$keyCreditCardIDOwnerDebit INTEGER NOT NULL,"
    "FOREIGN KEY ($keyDebitIDOwnerDebit) REFERENCES $keyDebitTable($keyIdDebit) ON DELETE CASCADE "
    "FOREIGN KEY ($keyOwnerIDOwnerDebit) REFERENCES $keyOwnerTable($keyIdOwner)"
    "FOREIGN KEY ($keyCreditCardIDOwnerDebit) REFERENCES $keyCreditCardTable($keyIdCreditCard) ON DELETE CASCADE)";

const String SELECT_DEBITS =
    "SELECT * FROM $keyDebitTable LEFT JOIN $keyOwnerDebitTable ON "
    "$keyOwnerDebitTable.$keyDebitIDOwnerDebit = $keyDebitTable.$keyIdDebit WHERE $keyCreditCardIdDebit = ";

const String SELECT_DEBITS2 = "SELECT * FROM $keyOwnerDebitTable LEFT JOIN "
    "$keyDebitTable ON $keyDebitTable.$keyIdDebit = $keyOwnerDebitTable.$keyDebitIDOwnerDebit WHERE $keyCreditCardIdDebit = ";

const String SELECT_DEBITS_WHERE = "SELECT * FROM $keyDebitTable LEFT JOIN $keyOwnerDebitTable ON "
    "$keyOwnerDebitTable.$keyDebitIDOwnerDebit = $keyDebitTable.$keyIdDebit WHERE $keyDebitIDOwnerDebit = ?";

const String SELECT_DEBITS_WHERE2 = "SELECT * FROM $keyOwnerDebitTable LEFT JOIN $keyDebitTable ON "
    "$keyOwnerDebitTable.$keyDebitIDOwnerDebit = $keyDebitTable.$keyIdDebit WHERE $keyDebitIDOwnerDebit = ?";

const String SELECT_DEBITS_WHERE_OWNER = "SELECT * FROM $keyDebitTable LEFT JOIN $keyOwnerDebitTable ON "
    "$keyOwnerDebitTable.$keyDebitIDOwnerDebit = $keyDebitTable.$keyIdDebit WHERE $keyCreditCardIDOwnerDebit = ?"
    " AND $keyOwnerIDOwnerDebit = ?";

const String SELECT_DEBITS_WHERE_OWNER2 = "SELECT * FROM $keyOwnerDebitTable LEFT JOIN $keyDebitTable ON "
    "$keyOwnerDebitTable.$keyDebitIDOwnerDebit = $keyDebitTable.$keyIdDebit WHERE $keyCreditCardIDOwnerDebit = ?"
    " AND $keyOwnerIDOwnerDebit = ?";
