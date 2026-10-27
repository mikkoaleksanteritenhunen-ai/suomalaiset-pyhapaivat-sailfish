import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: changeColumn.height + Theme.paddingLarge
        VerticalScrollDecorator { flickable: flickable }

        Column {
            id: changeColumn
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader { title: qsTr("Muutosloki") }

            SectionHeader { text: qsTr("Versio 0.5") }
            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                text: qsTr(
                    "• Lisätty kalenterivienti iCalendar-tiedostoon\n" +
                    "• Lisätty pyhä- ja liputuspäivien vienti valitulle vuodelle\n" +
                    "• Lisätty kuukauden liputuspäivien luettelo\n" +
                    "• Korjattu ISO-viikkonumeroiden laskentaa\n" +
                    "• Lisätty AI-SCORE-luokitus ja oma lisätietosivu\n" +
                    "• Siirretty muutosloki omalle sivulle\n" +
                    "• Parannettu käännöksiä, virheilmoituksia ja käyttöliittymän vakautta"
                )
            }

            SectionHeader { text: qsTr("Versio 0.4.1") }
            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                text: qsTr(
                    "• Parannettu tulevien pyhäpäivien ja liputuspäivien taustailmoituksia\n" +
                    "• Lisätty liputuspäivämuistutuksen näyttöajan valinta\n" +
                    "• Parannettu kalenterinavigointia ja aikalaskentaa\n" +
                    "• Parannettu käännöksiä ja käyttöliittymän vakautta"
                )
            }

            SectionHeader { text: qsTr("Versio 0.3") }
            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                text: qsTr(
                    "• Lisätty monikielinen käyttöliittymä ja kielivalinta\n" +
                    "• Lisätty tuki 12 käyttöliittymäkielelle\n" +
                    "• Lisätty seuraava pyhäpäivä ja liputuspäivä kansikorttiin\n" +
                    "• Parannettu ilmoituksia, asetusten tallennusta ja tapahtumatietoja"
                )
            }

            SectionHeader { text: qsTr("Versio 0.2") }
            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                text: qsTr(
                    "• Päivitetty sovelluksen versioksi 0.2\n" +
                    "• Uudistettu kuukausikalenterin näkymä\n" +
                    "• Korjattu kalenterin tasaus, kun viikkonumerot ovat pois käytöstä\n" +
                    "• Lisätty ISO-viikkonumeroiden näyttöasetus\n" +
                    "• Lisätty pyhäpäivien värin valinta\n" +
                    "• Lisätty liputuspäivien värin valinta\n" +
                    "• Lisätty viikonloppujen korostusasetus\n" +
                    "• Lisätty tämän päivän korostusasetus\n" +
                    "• Lisätty menneiden päivien himmennysasetus\n" +
                    "• Lisätty suuremman kalenterinäkymän asetus\n" +
                    "• Lisätty käyttäjäasetusten pysyvä tallennus\n" +
                    "• Lisätty suomalaisen kalenterikäytännön mukainen maanantaista alkava viikko\n" +
                    "• Lisätty dynaaminen seuraavan pyhäpäivän laskenta\n" +
                    "• Lisätty dynaaminen seuraavan liputuspäivän laskenta\n" +
                    "• Lisätty pääsiäisen ja siihen liittyvien liikkuvien pyhäpäivien laskenta\n" +
                    "• Lisätty juhannuspäivän vuosittainen laskenta\n" +
                    "• Lisätty pyhäinpäivän vuosittainen laskenta\n" +
                    "• Lisätty tarkat päivämäärät ja viikonpäivät pyhäpäiville\n" +
                    "• Lisätty vuosivalinta pyhäpäivien ja liputuspäivien näkymiin\n" +
                    "• Lisätty pyhäpäivien ja aattopäivien erottelu\n" +
                    "• Lisätty pyhäpäivien omat tietosivut\n" +
                    "• Lisätty liputuspäivien omat tietosivut\n" +
                    "• Lisätty juhla- ja liputuspäivien merkitysten kuvaukset\n" +
                    "• Lisätty hakutuloksista avautuvat päivien tietosivut\n" +
                    "• Poistettu erillinen haku liputuspäiväsivulta\n" +
                    "• Uudistettu pyhä- ja liputuspäivien yhteinen hakusivu\n" +
                    "• Lisätty virallisten ja vakiintuneiden liputuspäivien erottelu\n" +
                    "• Lisätty äitienpäivä ja isänpäivä virallisiin liputuspäiviin\n" +
                    "• Lisätty vaalipäivien liputustiedot\n" +
                    "• Lisätty vaalipäivät Vuoden pyhäpäivät -sivulle\n" +
                    "• Lisätty vuoden 2027 eduskuntavaalien vaalipäivä 18.4.2027\n" +
                    "• Lisätty vuoden 2029 alue- ja kuntavaalien vaalipäivä 15.4.2029\n" +
                    "• Lisätty vuoden 2029 Euroopan parlamentin vaalien vaalipäivä 10.6.2029\n" +
                    "• Lisätty vuoden 2030 presidentinvaalin vaalipäivä 27.1.2030\n" +
                    "• Lisätty vuoden 2031 eduskuntavaalien vaalipäivä 6.4.2031\n" +
                    "• Lisätty vaalipäiville omat selitystekstit\n" +
                    "• Lisätty vaalipäiville virallisen liputuspäivän merkintä\n" +
                    "• Lisätty vaalipäiville Suomen lipun kuvake\n" +
                    "• Lisätty tasavallan presidentin toimeenastumispäivää koskeva tieto\n" +
                    "• Lisätty vuosittain suositeltuja liputuspäiviä koskeva huomautus\n" +
                    "• Lisätty oikea Suomen lipun PNG-kuva\n" +
                    "• Lisätty Euroopan unionin lipun PNG-kuva\n" +
                    "• Lisätty Suomen lippu pyhäpäivien ja liputuspäivien näkymiin\n" +
                    "• Lisätty Suomen lippu liputuspäivän tietosivulle\n" +
                    "• Lisätty Suomen lippu pyhäpäiville, jotka ovat samalla virallisia liputuspäiviä\n" +
                    "• Lisätty liputuspäivätieto pyhäpäivän tarkennussivulle\n" +
                    "• Lisätty Made in Finland- ja Made in Europe -merkinnät\n" +
                    "• Siirretty sovelluksen tiedot omalle Tietoa sovelluksesta -sivulle\n" +
                    "• Lisätty version 0.2 muutosloki Tietoa-sivulle\n" +
                    "• Päivitetty tietosuojaseloste\n" +
                    "• Päivitetty sovelluksen verkkosivun osoite\n" +
                    "• Yhtenäistetty sivujen vetovalikot\n" +
                    "• Lisätty ilmoitusasetukset\n" +
                    "• Lisätty käynnistyksen yhteydessä julkaistavat ilmoitukset\n" +
                    "• Lisätty ilmoitusten testipainike\n" +
                    "• Lisätty Nemo Configuration -moduulin pakettiriippuvuus\n" +
                    "• Lisätty Nemo Notifications -moduulin pakettiriippuvuus\n" +
                    "• Korjattu sovelluksen kansikortti\n" +
                    "• Lisätty seuraavan pyhäpäivän näyttäminen kansikortissa\n" +
                    "• Lisätty seuraavan liputuspäivän näyttäminen kansikortissa\n" +
                    "• Lisätty pyhäpäivien ja liputuspäivien laskenta kansikorttiin\n" +
                    "• Lisätty Suomen lippu kansikortin liputuspäivän tietoihin\n" +
                    "• Lisätty kansikortin tietojen automaattinen päivitys\n" +
                    "• Lisätty käyttöliittymätekstien qsTr-käännöstuki\n" +
                    "• Päivitetty FirstPage-sivun käyttäjälle näkyvät tekstit käännettäviksi\n" +
                    "• Päivitetty FlagDaysPage-sivun käyttäjälle näkyvät tekstit käännettäviksi\n" +
                    "• Päivitetty SearchPage-sivun käyttäjälle näkyvät tekstit käännettäviksi\n" +
                    "• Päivitetty SettingsPage-sivun käyttäjälle näkyvät tekstit käännettäviksi\n" +
                    "• Päivitetty YearHolidaysPage-sivun käyttäjälle näkyvät tekstit käännettäviksi\n" +
                    "• Päivitetty DayDetailPage-sivun käyttäjälle näkyvät tekstit käännettäviksi\n" +
                    "• Päivitetty AboutPage-sivun käyttäjälle näkyvät tekstit käännettäviksi\n" +
                    "• Päivitetty CoverPage-kansikortin tekstit käännettäviksi\n" +
                    "• Lisätty viikonpäivien ja kuukausien nimien käännöstuki\n" +
                    "• Lisätty viikonpäivien ja viikkonumeron lyhenteiden käännöstuki\n" +
                    "• Lisätty pyhäpäivien, aattopäivien ja liputuspäivien nimien käännöstuki\n" +
                    "• Lisätty vaalipäivien nimien ja kuvausten käännöstuki\n" +
                    "• Lisätty päivien merkitysten ja kuvausten käännöstuki\n" +
                    "• Lisätty Qt LinguistTools -rakennustuki\n" +
                    "• Lisätty TS-käännöstiedostojen automaattinen tunnistaminen\n" +
                    "• Lisätty TS-tiedostojen automaattinen muuntaminen QM-tiedostoiksi\n" +
                    "• Lisätty QM-käännöstiedostojen asentaminen sovelluksen datahakemistoon\n" +
                    "• Lisätty mahdollisuus usean kielipaketin käyttämiseen\n" +
                    "• Säilytetty suomi käyttöliittymän lähdekielenä fi_FI; erillistä suomen QM-pakettia ei tarvita\n" +
                    "• Lisätty englannin kielipaketti en_GB\n" +
                    "• Lisätty ruotsin kielipaketti sv_SE\n" +
                    "• Lisätty saksan kielipaketti de_DE\n" +
                    "• Lisätty viron kielipaketti et_EE\n" +
                    "• Lisätty norjan bokmålin kielipaketti nb_NO\n" +
                    "• Lisätty tanskan kielipaketti da_DK\n" +
                    "• Lisätty ranskan kielipaketti fr_FR\n" +
                    "• Lisätty espanjan kielipaketti es_ES\n" +
                    "• Lisätty italian kielipaketti it_IT\n" +
                    "• Lisätty ukrainan kielipaketti uk_UA\n" +
                    "• Lisätty venäjän kielipaketti ru_RU\n" +
                    "• Lisätty yleisten käyttöliittymätekstien käännökset tuetuille kielille\n" +
                    "• Lisätty viikonpäivien, kuukausien ja kalenterilyhenteiden käännökset\n" +
                    "• Merkitty tarkistusta vaativat pitkät käännökset keskeneräisiksi\n" +
                    "• Lisätty qt5-qttools-linguist-rakennusriippuvuus\n" +
                    "• Lisätty käännöstiedostot Qt Creatorin projektipuuhun\n" +
                    "• Lisätty kehitystyökalu qsTr-merkintöjen päivittämiseen\n" +
                    "• Päivitetty CMakeLists.txt uusille QML-sivuille, kuvatiedostoille ja käännöksille\n" +
                    "• Lisätty uusien TS-kielitiedostojen automaattinen tunnistaminen CMake-rakennuksessa\n" +
                    "• Korjattu CMake-generaattorilausekkeen HTML-merkit\n" +
                    "• Poistettu tarpeeton automaattisen muutoshistorian changes.run-viittaus\n" +
                    "• Päivitetty RPM SPEC -tiedoston versioksi 0.2\n" +
                    "• Päivitetty Desktop-tiedosto\n" +
                    "• Säilytetty sovelluksen kalenteri- ja päivätietojen käsittely offline-tilassa\n" +
                    "• Valmisteltu sovellus kahdentoista käyttöliittymäkielen käyttämiseen"
                )
            }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("Julkaistu 25.7.2026 • Mikko Tenhunen")
            }

            SectionHeader { text: qsTr("Versio 0.1") }
            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                text: qsTr(
                    "• Ensimmäinen julkaisu\n" +
                    "• Kalenteri- ja pyhäpäiväsovellus Sailfish OS:lle\n" +
                    "• Vuoden pyhäpäivien listaus\n" +
                    "• Suomen liputuspäivien listaus\n" +
                    "• Hakutoiminto pyhä- ja liputuspäiville\n" +
                    "• Asetussivu\n" +
                    "• Sovelluksen kansikortti\n" +
                    "• Kuukausinäkymä\n" +
                    "• Viikkonumerot\n" +
                    "• Tuki vuosille 2020–2100\n" +
                    "• Haku kirjaimilla A–Ö\n" +
                    "• Tietosuojaseloste\n" +
                    "• Offline-toiminta ilman internetyhteyttä"
                )
            }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("Julkaistu 22.7.2026 • Mikko Tenhunen")
            }

            Item { width: 1; height: Theme.paddingLarge }
        }
    }
}
