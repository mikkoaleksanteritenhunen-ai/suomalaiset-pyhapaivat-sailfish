.pragma library

function offsetDate(date, days) {
    return new Date(
        date.getFullYear(),
        date.getMonth(),
        date.getDate() + days
    )
}

function easterSunday(year) {
    var a = year % 19
    var b = Math.floor(year / 100)
    var c = year % 100
    var d = Math.floor(b / 4)
    var e = b % 4
    var f = Math.floor((b + 8) / 25)
    var g = Math.floor((b - f + 1) / 3)
    var h = (19 * a + b - d - g + 15) % 30
    var i = Math.floor(c / 4)
    var k = c % 4
    var l = (32 + 2 * e + 2 * i - h - k) % 7
    var m = Math.floor((a + 11 * h + 22 * l) / 451)

    var month = Math.floor((h + l - 7 * m + 114) / 31)
    var day = ((h + l - 7 * m + 114) % 31) + 1

    return new Date(year, month - 1, day)
}

function nthWeekday(year, month, weekday, occurrence) {
    var date = new Date(year, month - 1, 1)

    while (date.getDay() !== weekday)
        date.setDate(date.getDate() + 1)

    date.setDate(date.getDate() + (occurrence - 1) * 7)
    return date
}

function lastWeekday(year, month, weekday) {
    var date = new Date(year, month, 0)

    while (date.getDay() !== weekday)
        date.setDate(date.getDate() - 1)

    return date
}

function dateForRule(event, year) {
    switch (event.ruleType) {
    case "fixed":
        return new Date(year, event.month - 1, event.day)

    case "easter_offset":
        return offsetDate(
            easterSunday(year),
            event.offsetDays
        )

    case "nth_weekday":
        return nthWeekday(
            year,
            event.month,
            event.weekday,
            event.occurrence
        )

    case "last_weekday":
        return lastWeekday(
            year,
            event.month,
            event.weekday
        )

    default:
        console.warn("Tuntematon päivämääräsääntö:", event.ruleType)
        return null
    }
}
