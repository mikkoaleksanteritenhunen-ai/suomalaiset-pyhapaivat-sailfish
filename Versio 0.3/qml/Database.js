.pragma library

.import QtQuick.LocalStorage 2.0 as Sql

var database = null

function openDatabase() {
    if (database !== null)
        return database

    database = Sql.LocalStorage.openDatabaseSync(
        "HolidayCalendar",
        "1.0",
        "Holiday and reminder database",
        5000000
    )

    return database
}

function initialize() {
    var db = openDatabase()

    db.transaction(function(tx) {
        tx.executeSql(
            "CREATE TABLE IF NOT EXISTS countries (" +
            "code TEXT PRIMARY KEY," +
            "name TEXT NOT NULL," +
            "language_code TEXT NOT NULL DEFAULT 'fi'," +
            "flag_image TEXT," +
            "enabled INTEGER NOT NULL DEFAULT 1" +
            ")"
        )

        tx.executeSql(
            "CREATE TABLE IF NOT EXISTS events (" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT," +
            "event_key TEXT NOT NULL," +
            "country_code TEXT NOT NULL," +
            "name TEXT NOT NULL," +
            "description TEXT DEFAULT ''," +
            "event_type TEXT NOT NULL," +
            "flag_day_type TEXT DEFAULT ''," +
            "rule_type TEXT NOT NULL," +
            "month INTEGER," +
            "day INTEGER," +
            "weekday INTEGER," +
            "occurrence INTEGER," +
            "offset_days INTEGER DEFAULT 0," +
            "valid_from INTEGER," +
            "valid_until INTEGER," +
            "enabled INTEGER NOT NULL DEFAULT 1," +
            "UNIQUE(event_key, country_code)," +
            "FOREIGN KEY(country_code) REFERENCES countries(code)" +
            ")"
        )

        tx.executeSql(
            "CREATE TABLE IF NOT EXISTS reminders (" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT," +
            "event_id INTEGER NOT NULL," +
            "event_date TEXT NOT NULL," +
            "remind_at TEXT NOT NULL," +
            "advance_minutes INTEGER NOT NULL DEFAULT 0," +
            "system_event_id TEXT," +
            "enabled INTEGER NOT NULL DEFAULT 1," +
            "created_at TEXT NOT NULL," +
            "UNIQUE(event_id, event_date)," +
            "FOREIGN KEY(event_id) REFERENCES events(id)" +
            ")"
        )

        tx.executeSql(
            "CREATE TABLE IF NOT EXISTS settings (" +
            "setting_key TEXT PRIMARY KEY," +
            "setting_value TEXT" +
            ")"
        )

        tx.executeSql(
            "CREATE INDEX IF NOT EXISTS idx_events_country " +
            "ON events(country_code)"
        )

        tx.executeSql(
            "CREATE INDEX IF NOT EXISTS idx_reminders_date " +
            "ON reminders(event_date)"
        )
    })

    insertDefaultData()
}
