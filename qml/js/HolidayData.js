.pragma library

function sameDate(a, b) {
    return a.getFullYear() === b.getFullYear() && a.getMonth() === b.getMonth() && a.getDate() === b.getDate()
}

function dateWithOffset(dateValue, days) {
    return new Date(dateValue.getFullYear(), dateValue.getMonth(), dateValue.getDate() + days)
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

function nthWeekday(year, monthIndex, weekday, occurrence) {
    var d = new Date(year, monthIndex, 1)
    while (d.getDay() !== weekday) d.setDate(d.getDate() + 1)
    d.setDate(d.getDate() + (occurrence - 1) * 7)
    return d
}

function lastWeekday(year, monthIndex, weekday) {
    var d = new Date(year, monthIndex + 1, 0)
    while (d.getDay() !== weekday) d.setDate(d.getDate() - 1)
    return d
}

function midsummerDay(year) {
    var d = new Date(year, 5, 20)
    while (d.getDay() !== 6) d.setDate(d.getDate() + 1)
    return d
}

function allSaintsDay(year) {
    var d = new Date(year, 9, 31)
    while (d.getDay() !== 6) d.setDate(d.getDate() + 1)
    return d
}

function holidayName(year, month, day) {
    var testDate = new Date(year, month - 1, day)
    var easter = easterSunday(year)
    if (month === 1 && day === 1) return qsTr("Uudenvuodenpäivä")
    if (month === 1 && day === 6) return qsTr("Loppiainen")
    if (sameDate(testDate, dateWithOffset(easter, -2))) return qsTr("Pitkäperjantai")
    if (sameDate(testDate, easter)) return qsTr("Pääsiäispäivä")
    if (sameDate(testDate, dateWithOffset(easter, 1))) return qsTr("Toinen pääsiäispäivä")
    if (month === 5 && day === 1) return qsTr("Vappu")
    if (sameDate(testDate, dateWithOffset(easter, 39))) return qsTr("Helatorstai")
    if (sameDate(testDate, dateWithOffset(easter, 49))) return qsTr("Helluntaipäivä")
    if (sameDate(testDate, midsummerDay(year))) return qsTr("Juhannuspäivä")
    if (sameDate(testDate, allSaintsDay(year))) return qsTr("Pyhäinpäivä")
    if (month === 12 && day === 6) return qsTr("Itsenäisyyspäivä")
    if (month === 12 && day === 24) return qsTr("Jouluaatto")
    if (month === 12 && day === 25) return qsTr("Joulupäivä")
    if (month === 12 && day === 26) return qsTr("Tapaninpäivä")
    return ""
}

function flagDayName(year, month, day) {
    var testDate = new Date(year, month - 1, day)
    var easter = easterSunday(year)
    if (month === 2 && day === 5) return qsTr("J. L. Runebergin päivä")
    if (month === 2 && day === 28) return qsTr("Kalevalan päivä ja suomalaisen kulttuurin päivä")
    if (month === 3 && day === 19) return qsTr("Minna Canthin päivä ja tasa-arvon päivä")
    if (month === 4 && day === 9) return qsTr("Mikael Agricolan päivä ja suomen kielen päivä")
    if (month === 4 && day === 27) return qsTr("Kansallinen veteraanipäivä")
    if (month === 5 && day === 1) return qsTr("Vappu ja suomalaisen työn päivä")
    if (month === 5 && day === 9) return qsTr("Eurooppa-päivä")
    if (month === 5 && day === 12) return qsTr("J. V. Snellmanin päivä ja suomalaisuuden päivä")
    if (sameDate(testDate, nthWeekday(year, 4, 0, 2))) return qsTr("Äitienpäivä")
    if (sameDate(testDate, nthWeekday(year, 4, 0, 3))) return qsTr("Kaatuneitten muistopäivä")
    if (sameDate(testDate, dateWithOffset(easter, 49))) return qsTr("Helluntaipäivä")
    if (month === 6 && day === 4) return qsTr("Puolustusvoimain lippujuhlan päivä")
    if (sameDate(testDate, midsummerDay(year))) return qsTr("Suomen lipun päivä")
    if (month === 7 && day === 6) return qsTr("Eino Leinon päivä ja runon ja suven päivä")
    if (sameDate(testDate, lastWeekday(year, 7, 6))) return qsTr("Suomen luonnon päivä")
    if (month === 10 && day === 1) return qsTr("Miina Sillanpään päivä ja kansalaisvaikuttamisen päivä")
    if (month === 10 && day === 10) return qsTr("Aleksis Kiven päivä ja suomalaisen kirjallisuuden päivä")
    if (month === 10 && day === 24) return qsTr("Yhdistyneiden kansakuntien päivä")
    if (month === 11 && day === 6) return qsTr("Ruotsalaisuuden päivä")
    if (sameDate(testDate, nthWeekday(year, 10, 0, 2))) return qsTr("Isänpäivä")
    if (month === 11 && day === 20) return qsTr("Lapsen oikeuksien päivä")
    if (month === 12 && day === 6) return qsTr("Itsenäisyyspäivä")
    if (month === 12 && day === 8) return qsTr("Jean Sibeliuksen päivä ja suomalaisen musiikin päivä")
    if (year === 2027 && month === 4 && day === 18) return qsTr("Eduskuntavaalien vaalipäivä")
    if (year === 2029 && month === 4 && day === 15) return qsTr("Alue- ja kuntavaalien vaalipäivä")
    if (year === 2029 && month === 6 && day === 10) return qsTr("Euroopan parlamentin vaalien vaalipäivä")
    if (year === 2030 && month === 1 && day === 27) return qsTr("Presidentinvaalin vaalipäivä")
    if (year === 2031 && month === 4 && day === 6) return qsTr("Eduskuntavaalien vaalipäivä")
    return ""
}
