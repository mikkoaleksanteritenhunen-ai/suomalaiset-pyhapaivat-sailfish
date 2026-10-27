Name:       harbour-suomalaisetpyhapaivat
Summary:    Suomalaiset Pyhäpäivät
Version:    0.3
Release:    1
License:    MIT
URL:        https://www.mikko-tenhunen.com/sovellukset/suomalaiset-pyhapaivat-kalenteri
Source0:    %{name}-%{version}.tar.bz2

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
Sailfish OS -laitteella. Sovellus toimii kokonaan offline-tilassa.

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
* Sat Sep 05 2026 Mikko Tenhunen <mikko.tenhunen@kiinteistomestarit.com> - 0.3-1
- Päivitetty sovelluksen versioksi 0.3
- Korjattu sovelluksen kansikortti
- Lisätty tämän päivän pyhäpäivän ja liputuspäivän näyttäminen kansikortissa
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
- Lisätty ISO-viikkonumeroiden näyttö
- Uudistettu kuukausikalenteri
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
- Lisätty käyttäjäasetusten pysyvä tallennus
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
