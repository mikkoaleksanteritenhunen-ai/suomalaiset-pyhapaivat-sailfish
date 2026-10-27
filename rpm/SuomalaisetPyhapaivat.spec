Name:           harbour-suomalaisetpyhapaivat
Summary:        Suomalaiset Pyhäpäivät
Version:        0.5
Release:        1
License:        MIT
URL:            https://www.mikko-tenhunen.com/sovellukset/jolla-sovellukset
Source0:        %{name}-%{version}.tar.bz2

Requires:       sailfishsilica-qt5 >= 0.10.9
Requires:       nemo-qml-plugin-configuration-qt5
Requires:       nemo-qml-plugin-notifications-qt5

BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Gui)
BuildRequires:  pkgconfig(Qt5Network)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  qt5-qttools-linguist
BuildRequires:  desktop-file-utils
BuildRequires:  cmake

%description
Suomalaiset Pyhäpäivät näyttää suomalaiset pyhäpäivät,
liputuspäivät, vaalipäivät, viikkonumerot ja kalenteritiedot
Sailfish OS -laitteella.

Sovelluksella voi viedä valitun vuoden pyhäpäivät,
liputuspäivät tai molemmat iCalendar-tiedostoon. Luotu ICS-tiedosto
voidaan avata yhteensopivassa kalenterisovelluksessa.

Sovellus toimii kokonaan offline-tilassa eikä kerää tai lähetä
käyttäjän tietoja.

%prep
%setup -q -n %{name}-%{version}

%build
%cmake
%make_build

%install
rm -rf %{buildroot}
%make_install

desktop-file-install \
    --delete-original \
    --dir=%{buildroot}%{_datadir}/applications \
    %{buildroot}%{_datadir}/applications/%{name}.desktop

%files
%defattr(-,root,root,-)

%{_bindir}/%{name}
%{_datadir}/%{name}/
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/86x86/apps/%{name}.png
%{_datadir}/icons/hicolor/108x108/apps/%{name}.png
%{_datadir}/icons/hicolor/128x128/apps/%{name}.png
%{_datadir}/icons/hicolor/172x172/apps/%{name}.png

%changelog
* Fri Oct 23 2026 Mikko Tenhunen <mikko.tenhunen@kiinteistomestarit.com> - 0.5-1
- Päivitetty sovelluksen versioksi 0.5
- Lisätty uusi Vie kalenteriin -sivu
- Lisätty pyhäpäivien vienti iCalendar ICS -tiedostoon
- Lisätty liputuspäivien vienti iCalendar ICS -tiedostoon
- Lisätty pyhäpäivien ja liputuspäivien vienti samaan ICS-tiedostoon
- Lisätty vietävän vuoden valinta
- Lisätty vietävien tapahtumatyyppien valinta
- Lisätty ICS-tiedostonimen automaattinen muodostaminen
- Lisätty ICS-tiedostojen tallentaminen Downloads-hakemistoon
- Lisätty mahdollisuus avata viety ICS-tiedosto kalenterisovelluksessa
- Lisätty CalendarExporter C++ -taustaluokka
- Lisätty calendarexporter.cpp-lähdetiedosto
- Lisätty calendarexporter.h-otsikkotiedosto
- Lisätty CalendarExportPage.qml-sivu
- Lisätty HolidayData.js-tapahtumalaskentakirjasto
- Lisätty kalenterivientisivu sovelluksen vetovalikkoon
- Lisätty tapahtumille pysyvät ja toistettavat UID-tunnisteet
- Lisätty vietäville tapahtumille iCalendar-kategoriat
- Lisätty vietäville pyhäpäiville kuvaukset
- Lisätty vietäville liputuspäiville kuvaukset
- Lisätty koko päivän tapahtumien DTSTART- ja DTEND-arvot
- Lisätty UTF-8-tuki vietäville tapahtumatiedoille
- Lisätty kuukauden liputuspäivien luettelo kalenterisivulle
- Lisätty kuukauden liputuspäivät pyhäpäivien alapuolelle
- Lisätty ilmoitus kuukausille, joissa ei ole pyhäpäiviä
- Lisätty ilmoitus kuukausille, joissa ei ole liputuspäiviä
- Lisätty kuukausiluetteloiden automaattinen päivitys
- Lisätty liputuspäiväluettelon piilottaminen asetuksen perusteella
- Parannettu kuukauden pyhäpäivien laskentaa
- Parannettu kuukauden liputuspäivien laskentaa
- Parannettu valitun päivän tietojen päivittämistä
- Parannettu kuukausien välillä siirtymistä
- Korjattu ISO-viikkonumeroiden laskenta
- Poistettu Date.UTC-kutsut ISO-viikkonumeron laskennasta
- Lisätty AI-SCORE-luokitus Tietoa sovelluksesta -sivulle
- Lisätty AI-SCORE V -kuva
- Lisätty tekoälyn käyttöä koskeva kuvaus
- Lisätty maininta Copilot GPT-5.6 Sol Think -tekoälytyökalusta
- Lisätty avattavat AI-SCORE-luokitusten kuvaukset
- Päivitetty sovelluksen verkkosivun osoite
- Lisätty kalenteriviennin C++-tiedostot CMake-rakennukseen
- Lisätty kalenteriviennin QML- ja JavaScript-tiedostot CMake-rakennukseen
- Lisätty kalenteriviennin tiedostot lähdepakettiin
- Lisätty kalenteriviennin pakollisten tiedostojen CMake-tarkistukset
- Päivitetty CMakeLists.txt uusille lähdetiedostoille
- Parannettu kalenterivientisivun käännöstukea
- Parannettu virheilmoituksia
- Parannettu käyttöliittymän vakautta
- Säilytetty sovelluksen toiminta kokonaan ilman internetyhteyttä

* Thu Oct 22 2026 Mikko Tenhunen <mikko.tenhunen@kiinteistomestarit.com> - 0.4.1-1
- Päivitetty sovelluksen versioksi 0.4.1
- Parannettu tulevien pyhäpäivien taustailmoituksia
- Parannettu tulevien liputuspäivien taustailmoituksia
- Lisätty mahdollisuus valita liputuspäivämuistutuksen näyttöaika
- Parannettu ilmoitusten ajastamista
- Parannettu muistutusten aikalaskentaa
- Parannettu pyhäpäivämuistutusten käsittelyä
- Parannettu liputuspäivämuistutusten käsittelyä
- Parannettu kalenterinavigointia
- Parannettu päivämäärä- ja aikalaskentaa
- Parannettu käännöksiä
- Parannettu kielivalinnan käsittelyä
- Parannettu asetusten pysyvää tallennusta
- Parannettu käyttöliittymän vakautta
- Korjattu pieniä kalenterin näyttövirheitä
- Korjattu pieniä ilmoitus- ja muistutusvirheitä
- Säilytetty sovelluksen toiminta kokonaan ilman internetyhteyttä

* Wed Oct 21 2026 Mikko Tenhunen <mikko.tenhunen@kiinteistomestarit.com> - 0.4-1
- Päivitetty sovelluksen versioksi 0.4
- Lisätty tulevien pyhäpäivien taustamuistutukset
- Lisätty tulevien liputuspäivien taustamuistutukset
- Lisätty muistutusten kellonaika-asetukset
- Lisätty ilmoitusten tausta-ajastus
- Lisätty ilmoitusten käsittely ilman avoinna olevaa pääsivua
- Parannettu pyhäpäivien ja liputuspäivien laskentaa
- Parannettu ilmoitusasetuksia
- Parannettu kalenterinavigointia
- Parannettu sovelluksen vakautta
- Parannettu käännösten ja kieliasetusten käsittelyä
- Säilytetty sovelluksen toiminta kokonaan ilman internetyhteyttä

* Sat Sep 05 2026 Mikko Tenhunen <mikko.tenhunen@kiinteistomestarit.com> - 0.3-1
- Päivitetty sovelluksen versioksi 0.3
- Korjattu sovelluksen kansikortti
- Lisätty tämän päivän pyhäpäivän näyttäminen kansikortissa
- Lisätty tämän päivän liputuspäivän näyttäminen kansikortissa
- Lisätty seuraavan pyhäpäivän näyttäminen kansikortissa
- Lisätty seuraavan liputuspäivän näyttäminen kansikortissa
- Lisätty kansikortin tietojen automaattinen päivitys
- Lisätty liputuspäivän animaatio kansikorttiin
- Korjattu tyhjän tapahtumatiedon käsittely kansikortissa
- Estetty tapahtuman nimen lukeminen tyhjästä arvosta
- Lisätty käyttöliittymän kielivalinta
- Lisätty kielivalinnan pysyvä tallennus
- Lisätty sovelluksen uudelleenkäynnistys kielenvaihdon jälkeen
- Lisätty Qt LinguistTools -rakennustuki
- Lisätty TS-tiedostojen automaattinen muuntaminen QM-kielipaketeiksi
- Lisätty QM-kielipakettien asentaminen sovelluksen datahakemistoon
- Lisätty englannin kielipaketti en_GB
- Lisätty ruotsin kielipaketti sv_SE
- Lisätty saksan kielipaketti de_DE
- Lisätty viron kielipaketti et_EE
- Lisätty norjan bokmålin kielipaketti nb_NO
- Lisätty tanskan kielipaketti da_DK
- Lisätty ranskan kielipaketti fr_FR
- Lisätty espanjan kielipaketti es_ES
- Lisätty italian kielipaketti it_IT
- Lisätty ukrainan kielipaketti uk_UA
- Lisätty venäjän kielipaketti ru_RU
- Säilytetty suomi käyttöliittymän lähdekielenä fi_FI
- Lisätty tuki yhteensä 12 käyttöliittymäkielelle
- Lisätty ISO-viikkonumeroiden näyttö
- Uudistettu kuukausikalenteri
- Parannettu pyhäpäivien tietoja
- Parannettu liputuspäivien tietoja
- Parannettu vaalipäivien tietoja
- Päivitetty CMake-rakennusjärjestelmä uusille kielipaketeille
- Korjattu CMake-generaattorilauseke
- Lisätty venäjän kielipaketti CMake-käännöslistaan
- Päivitetty RPM-pakettimääritykset
- Säilytetty sovelluksen toiminta kokonaan ilman internetyhteyttä

* Sat Jul 25 2026 Mikko Tenhunen <mikko.tenhunen@kiinteistomestarit.com> - 0.2-1
- Päivitetty sovelluksen versioksi 0.2
- Uudistettu kuukausikalenterin näkymä
- Lisätty ISO-viikkonumerot
- Lisätty kalenterin näyttöasetukset
- Lisätty pyhäpäivien ja liputuspäivien väriasetukset
- Lisätty viikonloppujen ja tämän päivän korostaminen
- Lisätty menneiden päivien himmennysasetus
- Lisätty suuremman kalenterinäkymän asetus
- Lisätty käyttäjäasetusten pysyvä tallennus
- Lisätty suomalaisen käytännön mukainen maanantaista alkava viikko
- Lisätty dynaaminen seuraavan pyhäpäivän laskenta
- Lisätty dynaaminen seuraavan liputuspäivän laskenta
- Lisätty pääsiäisen liikkuvien pyhäpäivien laskenta
- Lisätty juhannuspäivän vuosittainen laskenta
- Lisätty pyhäinpäivän vuosittainen laskenta
- Lisätty pyhäpäivien ja liputuspäivien tietosivut
- Lisätty pyhäpäivien ja liputuspäivien yhteinen haku
- Lisätty vaalipäivät ja niiden liputustiedot
- Lisätty Suomen ja Euroopan unionin lippukuvat
- Lisätty ilmoitusasetukset ja testi-ilmoitus
- Lisätty Nemo Configuration -moduulin pakettiriippuvuus
- Lisätty Nemo Notifications -moduulin pakettiriippuvuus
- Lisätty käyttöliittymätekstien qsTr-käännöstuki
- Lisätty useiden käyttöliittymäkielten rakennustuki
- Päivitetty tietosuojaseloste
- Päivitetty sovelluksen verkkosivun osoite
- Päivitetty Desktop-tiedosto
- Päivitetty RPM SPEC -tiedosto
- Säilytetty sovelluksen offline-toiminta

* Wed Jul 22 2026 Mikko Tenhunen <mikko.tenhunen@kiinteistomestarit.com> - 0.1-1
- Ensimmäinen julkaisu
- Kalenteri- ja pyhäpäiväsovellus Sailfish OS:lle
- Vuoden pyhäpäivien listaus
- Suomen liputuspäivien listaus
- Hakutoiminto pyhä- ja liputuspäiville
- Asetussivu
- Sovelluksen kansikortti
- Kuukausinäkymä
- Viikkonumerot
- Tuki vuosille 2020–2100
- Haku kirjaimilla A–Ö
- Tietosuojaseloste
- Offline-toiminta ilman internetyhteyttä
