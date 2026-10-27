import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    property int selectedYear: (new Date()).getFullYear()
    property int resultCount: 0

    ListModel { id: searchModel }

    function pad2(value) { return value < 10 ? "0" + value : value.toString() }
    function formatDate(d) { return pad2(d.getDate()) + "." + pad2(d.getMonth() + 1) + "." + d.getFullYear() }
    function weekdayName(d) { return [qsTr("sunnuntai"), qsTr("maanantai"), qsTr("tiistai"), qsTr("keskiviikko"), qsTr("torstai"), qsTr("perjantai"), qsTr("lauantai")][d.getDay()] }
    function monthName(d) { return [qsTr("tammikuuta"), qsTr("helmikuuta"), qsTr("maaliskuuta"), qsTr("huhtikuuta"), qsTr("toukokuuta"), qsTr("kesäkuuta"), qsTr("heinäkuuta"), qsTr("elokuuta"), qsTr("syyskuuta"), qsTr("lokakuuta"), qsTr("marraskuuta"), qsTr("joulukuuta")][d.getMonth()] }
    function longDate(d) { return weekdayName(d) + " " + d.getDate() + ". " + monthName(d) + " " + d.getFullYear() }
    function offsetDate(d, days) { return new Date(d.getFullYear(), d.getMonth(), d.getDate() + days) }

    function easterSunday(year) {
        var a=year%19, b=Math.floor(year/100), c=year%100, d=Math.floor(b/4), e=b%4
        var f=Math.floor((b+8)/25), g=Math.floor((b-f+1)/3), h=(19*a+b-d-g+15)%30
        var i=Math.floor(c/4), k=c%4, l=(32+2*e+2*i-h-k)%7, m=Math.floor((a+11*h+22*l)/451)
        var month=Math.floor((h+l-7*m+114)/31), day=((h+l-7*m+114)%31)+1
        return new Date(year, month-1, day)
    }

    function nthWeekday(year, month, weekday, occurrence) {
        var d=new Date(year, month, 1)
        while (d.getDay() !== weekday) d.setDate(d.getDate()+1)
        d.setDate(d.getDate()+(occurrence-1)*7)
        return d
    }

    function lastWeekday(year, month, weekday) {
        var d=new Date(year, month+1, 0)
        while (d.getDay() !== weekday) d.setDate(d.getDate()-1)
        return d
    }

    function midsummerDay(year) { var d=new Date(year,5,20); while(d.getDay()!==6)d.setDate(d.getDate()+1); return d }
    function allSaintsDay(year) { var d=new Date(year,9,31); while(d.getDay()!==6)d.setDate(d.getDate()+1); return d }

    function holidayDescription(id) {
        switch(id) {
        case "new_year": return qsTr("Uudenvuodenpäivä aloittaa kalenterivuoden. Päivään liittyy uuden vuoden vastaanottaminen sekä tulevan vuoden toivotukset.")
        case "epiphany": return qsTr("Loppiainen päättää joulun kirkollisen juhlakauden. Päivä liittyy itämaan tietäjien vierailuun Jeesuksen luona.")
        case "good_friday": return qsTr("Pitkäperjantaina muistetaan Jeesuksen ristiinnaulitsemista ja kuolemaa.")
        case "easter": return qsTr("Pääsiäispäivä on kristillisen pääsiäisen pääjuhla ja Jeesuksen ylösnousemuksen päivä.")
        case "easter_monday": return qsTr("Toinen pääsiäispäivä jatkaa pääsiäisen juhlaa pääsiäissunnuntaita seuraavana maanantaina.")
        case "may_day": return qsTr("Vappu on kevään, opiskelijoiden ja suomalaisen työn juhla.")
        case "ascension": return qsTr("Helatorstaita vietetään 39 päivää pääsiäispäivän jälkeen. Päivä liittyy Kristuksen taivaaseenastumiseen.")
        case "pentecost": return qsTr("Helluntaipäivää vietetään 49 päivää pääsiäispäivän jälkeen. Päivä liittyy Pyhän Hengen vuodattamiseen.")
        case "midsummer_eve": return qsTr("Juhannusaatto aloittaa keskikesän juhlan. Se on Suomessa vakiintunut vapaapäivä, mutta ei varsinainen pyhäpäivä.")
        case "midsummer": return qsTr("Juhannuspäivä on keskikesän juhla ja samalla Suomen lipun päivä.")
        case "all_saints": return qsTr("Pyhäinpäivänä muistetaan pyhiä ja edesmenneitä läheisiä.")
        case "independence": return qsTr("Itsenäisyyspäivänä juhlistetaan Suomen itsenäisyyttä 6. joulukuuta.")
        case "christmas_eve": return qsTr("Jouluaatto aloittaa suomalaisen joulun pääjuhlan. Se on vakiintunut vapaapäivä, mutta ei varsinainen pyhäpäivä.")
        case "christmas": return qsTr("Joulupäivänä vietetään kristillisessä perinteessä Jeesuksen syntymän juhlaa.")
        case "boxing_day": return qsTr("Tapaninpäivä eli toinen joulupäivä jatkaa joulun juhlaa 26. joulukuuta.")
        }
        return qsTr("Suomalainen juhla- tai pyhäpäivä.")
    }

    function flagDescription(id) {
        switch(id) {
        case "runeberg": return qsTr("Päivä kunnioittaa kansallisrunoilija J. L. Runebergia ja suomalaista kirjallisuutta.")
        case "kalevala": return qsTr("Päivä juhlistaa Kalevalaa ja suomalaista kulttuuria.")
        case "canth": return qsTr("Päivä kunnioittaa kirjailija Minna Canthia ja tasa-arvotyötä.")
        case "agricola": return qsTr("Päivä kunnioittaa Mikael Agricolaa ja suomen kirjakielen kehitystä.")
        case "veterans": return qsTr("Päivänä kunnioitetaan Suomen sotien veteraaneja ja heidän työtään Suomen hyväksi.")
        case "may_day_flag": return qsTr("Vappu on suomalaisen työn päivä ja virallinen liputuspäivä.")
        case "europe": return qsTr("Eurooppa-päivä juhlistaa rauhaa ja eurooppalaista yhteistyötä.")
        case "snellman": return qsTr("Päivä kunnioittaa J. V. Snellmania ja suomalaisuutta.")
        case "mothers": return qsTr("Äitienpäivänä kunnioitetaan äitejä ja äitiyttä. Päivä on virallinen liputuspäivä.")
        case "fallen": return qsTr("Päivänä muistetaan sodissa ja palvelustehtävissä kaatuneita.")
        case "defence": return qsTr("Päivä on Suomen puolustusvoimien juhla- ja liputuspäivä.")
        case "flag_day": return qsTr("Juhannuspäivänä vietetään Suomen lipun päivää ja Suomen lippu voi olla salossa läpi valoisan yön.")
        case "leino": return qsTr("Päivä kunnioittaa Eino Leinoa, runoutta ja Suomen suvea.")
        case "nature": return qsTr("Päivänä juhlistetaan Suomen luontoa ja luonnon merkitystä.")
        case "sillanpaa": return qsTr("Päivä kunnioittaa Miina Sillanpäätä ja kansalaisvaikuttamista.")
        case "kivi": return qsTr("Päivä kunnioittaa Aleksis Kiveä ja suomalaista kirjallisuutta.")
        case "un": return qsTr("Yhdistyneiden kansakuntien päivä muistuttaa YK:n työstä rauhan ja kansainvälisen yhteistyön hyväksi.")
        case "swedish": return qsTr("Päivä juhlistaa Suomen ruotsinkielistä kulttuuria ja kaksikielisyyttä.")
        case "fathers": return qsTr("Isänpäivänä kunnioitetaan isiä ja isyyttä. Päivä on virallinen liputuspäivä.")
        case "children": return qsTr("Päivä muistuttaa lasten oikeuksista ja hyvinvoinnista.")
        case "independence_flag": return qsTr("Itsenäisyyspäivä on Suomen itsenäisyyden juhlapäivä ja virallinen liputuspäivä.")
        case "sibelius": return qsTr("Päivä kunnioittaa Jean Sibeliusta ja suomalaista musiikkia.")
        case "election_parliament": return qsTr("Eduskuntavaaleissa valitaan Suomen eduskunnan kansanedustajat. Vaalipäivä on virallinen liputuspäivä.")
        case "election_local": return qsTr("Alue- ja kuntavaaleissa valitaan aluevaltuustojen ja kuntien valtuustojen jäsenet. Vaalipäivä on virallinen liputuspäivä.")
        case "election_eu": return qsTr("Euroopan parlamentin vaaleissa valitaan Suomen edustajat Euroopan parlamenttiin. Vaalipäivä on virallinen liputuspäivä.")
        case "election_president": return qsTr("Presidentinvaalissa valitaan Suomen tasavallan presidentti. Vaalipäivä on virallinen liputuspäivä.")
        }
        return qsTr("Suomen virallinen tai vakiintunut liputuspäivä.")
    }

    function holidaysForYear(year) {
        var easter=easterSunday(year), midsummer=midsummerDay(year)
        return [
            {id:"new_year", name:qsTr("Uudenvuodenpäivä"), d:new Date(year,0,1), type:qsTr("Pyhäpäivä")},
            {id:"epiphany", name:qsTr("Loppiainen"), d:new Date(year,0,6), type:qsTr("Pyhäpäivä")},
            {id:"good_friday", name:qsTr("Pitkäperjantai"), d:offsetDate(easter,-2), type:qsTr("Pyhäpäivä")},
            {id:"easter", name:qsTr("Pääsiäispäivä"), d:easter, type:qsTr("Pyhäpäivä")},
            {id:"easter_monday", name:qsTr("Toinen pääsiäispäivä"), d:offsetDate(easter,1), type:qsTr("Pyhäpäivä")},
            {id:"may_day", name:qsTr("Vappu"), d:new Date(year,4,1), type:qsTr("Pyhäpäivä")},
            {id:"ascension", name:qsTr("Helatorstai"), d:offsetDate(easter,39), type:qsTr("Pyhäpäivä")},
            {id:"pentecost", name:qsTr("Helluntaipäivä"), d:offsetDate(easter,49), type:qsTr("Pyhäpäivä")},
            {id:"midsummer_eve", name:qsTr("Juhannusaatto"), d:offsetDate(midsummer,-1), type:qsTr("Aattopäivä")},
            {id:"midsummer", name:qsTr("Juhannuspäivä"), d:midsummer, type:qsTr("Pyhäpäivä")},
            {id:"all_saints", name:qsTr("Pyhäinpäivä"), d:allSaintsDay(year), type:qsTr("Pyhäpäivä")},
            {id:"independence", name:qsTr("Itsenäisyyspäivä"), d:new Date(year,11,6), type:qsTr("Pyhäpäivä")},
            {id:"christmas_eve", name:qsTr("Jouluaatto"), d:new Date(year,11,24), type:qsTr("Aattopäivä")},
            {id:"christmas", name:qsTr("Joulupäivä"), d:new Date(year,11,25), type:qsTr("Pyhäpäivä")},
            {id:"boxing_day", name:qsTr("Tapaninpäivä"), d:new Date(year,11,26), type:qsTr("Pyhäpäivä")}
        ]
    }

    function flagDaysForYear(year) {
        var list=[
            {id:"runeberg",name:qsTr("J. L. Runebergin päivä"),d:new Date(year,1,5),type:qsTr("Vakiintunut liputuspäivä")},
            {id:"kalevala",name:qsTr("Kalevalan päivä ja suomalaisen kulttuurin päivä"),d:new Date(year,1,28),type:qsTr("Virallinen liputuspäivä")},
            {id:"canth",name:qsTr("Minna Canthin päivä ja tasa-arvon päivä"),d:new Date(year,2,19),type:qsTr("Vakiintunut liputuspäivä")},
            {id:"agricola",name:qsTr("Mikael Agricolan päivä ja suomen kielen päivä"),d:new Date(year,3,9),type:qsTr("Vakiintunut liputuspäivä")},
            {id:"veterans",name:qsTr("Kansallinen veteraanipäivä"),d:new Date(year,3,27),type:qsTr("Vakiintunut liputuspäivä")},
            {id:"may_day_flag",name:qsTr("Vappu ja suomalaisen työn päivä"),d:new Date(year,4,1),type:qsTr("Virallinen liputuspäivä")},
            {id:"europe",name:qsTr("Eurooppa-päivä"),d:new Date(year,4,9),type:qsTr("Vakiintunut liputuspäivä")},
            {id:"mothers",name:qsTr("Äitienpäivä"),d:nthWeekday(year,4,0,2),type:qsTr("Virallinen liputuspäivä")},
            {id:"snellman",name:qsTr("J. V. Snellmanin päivä ja suomalaisuuden päivä"),d:new Date(year,4,12),type:qsTr("Vakiintunut liputuspäivä")},
            {id:"fallen",name:qsTr("Kaatuneitten muistopäivä"),d:nthWeekday(year,4,0,3),type:qsTr("Vakiintunut liputuspäivä")},
            {id:"defence",name:qsTr("Puolustusvoimain lippujuhlan päivä"),d:new Date(year,5,4),type:qsTr("Virallinen liputuspäivä")},
            {id:"flag_day",name:qsTr("Suomen lipun päivä"),d:midsummerDay(year),type:qsTr("Virallinen liputuspäivä")},
            {id:"leino",name:qsTr("Eino Leinon päivä ja runon ja suven päivä"),d:new Date(year,6,6),type:qsTr("Vakiintunut liputuspäivä")},
            {id:"nature",name:qsTr("Suomen luonnon päivä"),d:lastWeekday(year,7,6),type:qsTr("Vakiintunut liputuspäivä")},
            {id:"sillanpaa",name:qsTr("Miina Sillanpään päivä ja kansalaisvaikuttamisen päivä"),d:new Date(year,9,1),type:qsTr("Vakiintunut liputuspäivä")},
            {id:"kivi",name:qsTr("Aleksis Kiven päivä ja suomalaisen kirjallisuuden päivä"),d:new Date(year,9,10),type:qsTr("Vakiintunut liputuspäivä")},
            {id:"un",name:qsTr("Yhdistyneiden kansakuntien päivä"),d:new Date(year,9,24),type:qsTr("Vakiintunut liputuspäivä")},
            {id:"swedish",name:qsTr("Ruotsalaisuuden päivä"),d:new Date(year,10,6),type:qsTr("Vakiintunut liputuspäivä")},
            {id:"fathers",name:qsTr("Isänpäivä"),d:nthWeekday(year,10,0,2),type:qsTr("Virallinen liputuspäivä")},
            {id:"children",name:qsTr("Lapsen oikeuksien päivä"),d:new Date(year,10,20),type:qsTr("Vakiintunut liputuspäivä")},
            {id:"independence_flag",name:qsTr("Itsenäisyyspäivä"),d:new Date(year,11,6),type:qsTr("Virallinen liputuspäivä")},
            {id:"sibelius",name:qsTr("Jean Sibeliuksen päivä ja suomalaisen musiikin päivä"),d:new Date(year,11,8),type:qsTr("Vakiintunut liputuspäivä")}
        ]
        if(year===2027) list.push({id:"election_parliament",name:qsTr("Eduskuntavaalien vaalipäivä"),d:new Date(2027,3,18),type:qsTr("Virallinen liputuspäivä")})
        if(year===2029){
            list.push({id:"election_local",name:qsTr("Alue- ja kuntavaalien vaalipäivä"),d:new Date(2029,3,15),type:qsTr("Virallinen liputuspäivä")})
            list.push({id:"election_eu",name:qsTr("Euroopan parlamentin vaalien vaalipäivä"),d:new Date(2029,5,10),type:qsTr("Virallinen liputuspäivä")})
        }
        if(year===2030) list.push({id:"election_president",name:qsTr("Presidentinvaalin vaalipäivä"),d:new Date(2030,0,27),type:qsTr("Virallinen liputuspäivä")})
        if(year===2031) list.push({id:"election_parliament",name:qsTr("Eduskuntavaalien vaalipäivä"),d:new Date(2031,3,6),type:qsTr("Virallinen liputuspäivä")})
        return list
    }

    function buildModel() {
        searchModel.clear()
        var items=holidaysForYear(selectedYear), i
        for(i=0;i<items.length;i++) addItem(items[i],false)
        items=flagDaysForYear(selectedYear)
        for(i=0;i<items.length;i++) addItem(items[i],true)
        updateCount()
    }

    function addItem(item,isFlag) {
        searchModel.append({eventName:item.name,eventDateText:formatDate(item.d),eventLongDateText:longDate(item.d),eventTypeText:item.type,eventDescriptionText:isFlag?flagDescription(item.id):holidayDescription(item.id),eventIsFlagDay:isFlag,eventFlagDayTypeText:isFlag?item.type:""})
    }

    function matches(name,type) {
        var q=searchField.text.toLowerCase()
        return q==="" || name.toLowerCase().indexOf(q)>=0 || type.toLowerCase().indexOf(q)>=0
    }

    function updateCount(){var count=0;for(var i=0;i<searchModel.count;i++){var item=searchModel.get(i);if(matches(item.eventName,item.eventTypeText))count++}resultCount=count}

    function openDetail(name,dateText,longText,typeText,description,isFlag,flagType) {
        pageStack.push(Qt.resolvedUrl("DayDetailPage.qml"),{eventName:name,eventDateText:dateText,eventLongDateText:longText,eventType:typeText,eventDescription:description,eventIsFlagDay:isFlag,eventFlagDayType:flagType,eventFlagDayDescription:isFlag?description:""})
    }

    Component.onCompleted: buildModel()

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: contentColumn.height+Theme.paddingLarge
        VerticalScrollDecorator {}
        Column {
            id: contentColumn
            width: parent.width
            spacing: Theme.paddingMedium
            PageHeader { title: qsTr("Haku") }
            Row {
                id: yearRow
                width: parent.width-Theme.horizontalPageMargin*2
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingSmall
                Button { width:(yearRow.width-yearRow.spacing*2)/3; text:qsTr("Edellinen"); onClicked:{selectedYear--;buildModel()} }
                Label { width:(yearRow.width-yearRow.spacing*2)/3; height:parent.height; horizontalAlignment:Text.AlignHCenter; verticalAlignment:Text.AlignVCenter; font.bold:true; text:selectedYear.toString() }
                Button { width:(yearRow.width-yearRow.spacing*2)/3; text:qsTr("Seuraava"); onClicked:{selectedYear++;buildModel()} }
            }
            SearchField { id:searchField; width:parent.width-Theme.horizontalPageMargin*2; anchors.horizontalCenter:parent.horizontalCenter; placeholderText:qsTr("Hae pyhä-, aatto-, vaali- tai liputuspäivää"); onTextChanged:updateCount() }
            Label { width:parent.width; horizontalAlignment:Text.AlignHCenter; color:Theme.highlightColor; text:qsTr("%1 tulosta vuonna %2").arg(resultCount).arg(selectedYear) }
            Repeater {
                model: searchModel
                delegate: BackgroundItem {
                    visible: matches(eventName,eventTypeText)
                    width: parent.width
                    height: visible?resultColumn.height+Theme.paddingMedium*2:0
                    Column {
                        id: resultColumn
                        anchors.left:parent.left; anchors.right:parent.right; anchors.verticalCenter:parent.verticalCenter
                        anchors.leftMargin:Theme.horizontalPageMargin; anchors.rightMargin:Theme.horizontalPageMargin
                        spacing:Theme.paddingSmall
                        Row {
                            width:parent.width; spacing:Theme.paddingMedium
                            Image { visible:eventIsFlagDay; width:visible?48:0; height:visible?29:0; source:"../images/finnish_flag.png"; fillMode:Image.PreserveAspectFit; smooth:true }
                            Label { width:parent.width-(eventIsFlagDay?48+parent.spacing:0); text:eventName; font.bold:true; wrapMode:Text.WordWrap; verticalAlignment:Text.AlignVCenter }
                        }
                        Label { width:parent.width; text:eventLongDateText; color:Theme.secondaryColor; wrapMode:Text.WordWrap }
                        Label { width:parent.width; text:eventTypeText; color:eventIsFlagDay?"#4EA5FF":Theme.highlightColor }
                        Rectangle { width:parent.width; height:1; color:Theme.secondaryColor; opacity:0.3 }
                    }
                    onClicked:openDetail(eventName,eventDateText,eventLongDateText,eventTypeText,eventDescriptionText,eventIsFlagDay,eventFlagDayTypeText)
                }
            }
        }
    }
}
