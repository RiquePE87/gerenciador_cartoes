const String keyCreditCardTable = "creditCard";
const String keyDebitTable = "debit";
const String keyOwnerTable = "owner";
const String keyOwnerDebitTable = "owner_debit";

const String keyIdCreditCard = "id";
const String keyNameCreditCard = "name";
const String keyPayDayCreditCard = "payday";
const String keyUsedLimitCreditCard = "usedlimit";
const String keyLimitCreditCard = "limitcredit";
//const String keyDebitListCreditCard = "debitList";

const String keyIdDebit = "id";
const String keyDescriptionDebit = "description";
const String keyValueDebit = "value";
const String keyQuotaDebit = "quota";
const String keyCreditCardIdDebit = "creditCardID";
//

const String keyIdOwner = "id";
const String keyNameOwner = "name";

const String keyIDdOwnerDebit = "id";
const String keyDebitIDOwnerDebit = "debit_id";
const String keyOwnerIDOwnerDebit = "owner_id";

const String DATABASE = "database.db";

const String CREATE_CREDIT_CARD_TABLE = "CREATE TABLE $keyCreditCardTable"
    "($keyIdCreditCard INTEGER PRIMARY KEY AUTOINCREMENT,"
    " $keyNameCreditCard TEXT,"
    " $keyPayDayCreditCard INTEGER,"
    " $keyUsedLimitCreditCard REAL,"
    " $keyLimitCreditCard REAL)";

const String CREATE_DEBIT_TABLE = "CREATE TABLE $keyDebitTable"
    "($keyIdDebit INTEGER PRIMARY KEY AUTOINCREMENT,"
    "$keyDescriptionDebit TEXT,"
    "$keyValueDebit REAL,"
    "$keyQuotaDebit INTEGER,"
    "$keyCreditCardIdDebit INTEGER NOT NULL,"
    "FOREIGN KEY ($keyCreditCardIdDebit) REFERENCES $keyCreditCardTable($keyIdCreditCard))";

const String CREATE_OWNER_TABLE = "CREATE TABLE $keyOwnerTable ("
    "$keyIdOwner INTEGER PRIMARY KEY AUTOINCREMENT,"
    "$keyNameOwner TEXT)";

const String CREATE_OWNER_DEBIT_TABLE = "CREATE TABLE $keyOwnerDebitTable ("
    "$keyIDdOwnerDebit INTEGER PRIMARY KEY AUTOINCREMENT,"
    "$keyDebitIDOwnerDebit INTEGER NOT NULL,"
    "$keyOwnerIDOwnerDebit INTEGER NOT NULL,"
    "FOREIGN KEY ($keyDebitIDOwnerDebit) REFERENCES $keyDebitTable($keyIdDebit),"
    "FOREIGN KEY ($keyOwnerIDOwnerDebit) REFERENCES $keyOwnerTable($keyIdOwner))";

const String SELECT_DEBITS =
    "select * from $keyDebitTable left join $keyOwnerDebitTable on "
    "$keyOwnerDebitTable.$keyDebitIDOwnerDebit = $keyDebitTable.$keyIdDebit";
