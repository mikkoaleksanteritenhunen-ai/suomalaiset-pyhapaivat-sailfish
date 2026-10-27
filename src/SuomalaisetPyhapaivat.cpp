#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>

#include <QCoreApplication>
#include <QDebug>
#include <QDir>
#include <QGuiApplication>
#include <QLocale>
#include <QProcess>
#include <QQuickView>
#include <QScopedPointer>
#include <QString>
#include <QStringList>
#include <QTranslator>
#include <QUrl>

#include <cstdlib>

namespace
{

const QString ApplicationName =
        QStringLiteral("harbour-suomalaisetpyhapaivat");

const QString LanguageSettingKey =
        QStringLiteral("/apps/suomalaisetpyhapaivat/language");

const QString RestartRequestedKey =
        QStringLiteral("/apps/suomalaisetpyhapaivat/restartRequested");

QString removeDConfQuotes(QString value)
{
    value = value.trimmed();

    if (value.length() >= 2) {
        const bool singleQuoted =
                value.startsWith(QLatin1Char('\'')) &&
                value.endsWith(QLatin1Char('\''));

        const bool doubleQuoted =
                value.startsWith(QLatin1Char('"')) &&
                value.endsWith(QLatin1Char('"'));

        if (singleQuoted || doubleQuoted) {
            value = value.mid(1, value.length() - 2);
        }
    }

    return value.trimmed();
}

QString readDConfValue(
        const QString &key,
        const QString &defaultValue)
{
    QProcess process;

    process.start(
        QStringLiteral("dconf"),
        QStringList()
            << QStringLiteral("read")
            << key
    );

    if (!process.waitForStarted(3000)) {
        qWarning()
                << "dconf-komentoa ei voitu käynnistää. Avain:"
                << key;
        return defaultValue;
    }

    if (!process.waitForFinished(3000)) {
        qWarning()
                << "DConf-asetuksen lukeminen aikakatkaistiin. Avain:"
                << key;

        process.kill();
        process.waitForFinished();
        return defaultValue;
    }

    if (process.exitStatus() != QProcess::NormalExit ||
            process.exitCode() != 0) {
        qWarning()
                << "DConf-asetuksen lukeminen epäonnistui. Avain:"
                << key
                << "Virhe:"
                << process.readAllStandardError();
        return defaultValue;
    }

    const QString value = removeDConfQuotes(
        QString::fromUtf8(process.readAllStandardOutput())
    );

    if (value.isEmpty()) {
        return defaultValue;
    }

    return value;
}

bool writeDConfBoolean(const QString &key, bool value)
{
    QProcess process;

    process.start(
        QStringLiteral("dconf"),
        QStringList()
            << QStringLiteral("write")
            << key
            << (value
                ? QStringLiteral("true")
                : QStringLiteral("false"))
    );

    if (!process.waitForStarted(3000)) {
        qWarning()
                << "dconf-komentoa ei voitu käynnistää kirjoittamista varten. Avain:"
                << key;
        return false;
    }

    if (!process.waitForFinished(3000)) {
        qWarning()
                << "DConf-asetuksen kirjoittaminen aikakatkaistiin. Avain:"
                << key;

        process.kill();
        process.waitForFinished();
        return false;
    }

    if (process.exitStatus() != QProcess::NormalExit ||
            process.exitCode() != 0) {
        qWarning()
                << "DConf-asetuksen kirjoittaminen epäonnistui. Avain:"
                << key
                << "Virhe:"
                << process.readAllStandardError();
        return false;
    }

    return true;
}

QString readLanguageSetting()
{
    const QString language = readDConfValue(
        LanguageSettingKey,
        QStringLiteral("system")
    ).toLower();

    qDebug()
            << "DConfista luettu kieliasetus:"
            << language;

    return language;
}

bool readRestartRequested()
{
    const QString value = readDConfValue(
        RestartRequestedKey,
        QStringLiteral("false")
    ).toLower();

    return value == QStringLiteral("true") ||
           value == QStringLiteral("1");
}

QString systemLanguage()
{
    QString language =
            QLocale::system().name().left(2).toLower();

    if (language == QStringLiteral("no")) {
        language = QStringLiteral("nb");
    }

    return language;
}

QString resolveLanguage()
{
    QString language = readLanguageSetting();

    if (language == QStringLiteral("system")) {
        language = systemLanguage();
    }

    const QStringList supportedLanguages = {
        QStringLiteral("fi"),
        QStringLiteral("da"),
        QStringLiteral("de"),
        QStringLiteral("en"),
        QStringLiteral("es"),
        QStringLiteral("fr"),
        QStringLiteral("it"),
        QStringLiteral("nb"),
        QStringLiteral("sv"),
        QStringLiteral("uk")
    };

    if (!supportedLanguages.contains(language)) {
        qWarning()
                << "Kielikoodia ei tueta:"
                << language
                << "- käytetään suomea.";
        return QStringLiteral("fi");
    }

    return language;
}

QStringList translationDirectories()
{
    const QString installedApplicationDirectory =
            QStringLiteral(
                "/usr/share/harbour-suomalaisetpyhapaivat"
            );

    const QString executableRelativeDirectory =
            QDir::cleanPath(
                QDir(QCoreApplication::applicationDirPath())
                    .filePath(
                        QStringLiteral("../share/") +
                        ApplicationName +
                        QStringLiteral("/translations")
                    )
            );

    return QStringList()
            << QDir(installedApplicationDirectory)
                   .filePath(QStringLiteral("translations"))
            << executableRelativeDirectory
            << installedApplicationDirectory;
}

QStringList translationBaseNames(const QString &language)
{
    return QStringList()
            << ApplicationName + QStringLiteral("-") + language
            << ApplicationName + QStringLiteral("_") + language
            << QStringLiteral("SuomalaisetPyhapaivat-") + language
            << QStringLiteral("SuomalaisetPyhapaivat_") + language;
}

bool loadApplicationTranslation(
        QTranslator &translator,
        const QString &language)
{
    if (language == QStringLiteral("fi")) {
        qDebug()
                << "Käytetään QML-tiedostojen alkuperäistä suomen kieltä.";
        return true;
    }

    const QStringList directories = translationDirectories();
    const QStringList baseNames = translationBaseNames(language);

    for (const QString &directory : directories) {
        for (const QString &baseName : baseNames) {
            qDebug()
                    << "Yritetään ladata käännös:"
                    << baseName
                    << "hakemistosta:"
                    << directory;

            if (translator.load(baseName, directory)) {
                qDebug()
                        << "Käännös ladattu:"
                        << baseName
                        << "hakemistosta:"
                        << directory;
                return true;
            }
        }
    }

    qWarning()
            << "Käännöstiedostoa ei löytynyt."
            << "Valittu kieli:"
            << language
            << "Kokeillut nimet:"
            << baseNames
            << "Kokeillut hakemistot:"
            << directories;

    return false;
}

bool restartApplication()
{
    const QString executable =
            QCoreApplication::applicationFilePath();

    const QStringList arguments =
            QCoreApplication::arguments().mid(1);

    qDebug()
            << "Käynnistetään sovellus uudelleen:"
            << executable
            << arguments;

    const bool started =
            QProcess::startDetached(executable, arguments);

    if (!started) {
        qWarning()
                << "Sovelluksen uudelleenkäynnistäminen epäonnistui.";
    }

    return started;
}

} // namespace

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> application(
        SailfishApp::application(argc, argv)
    );

    if (application.isNull()) {
        qCritical()
                << "QGuiApplication-oliota ei voitu luoda.";
        return EXIT_FAILURE;
    }

    const QString language = resolveLanguage();

    qDebug()
            << "Tallennettu tai ratkaistu sovelluskieli:"
            << language;

    QTranslator applicationTranslator;

    if (language != QStringLiteral("fi")) {
        if (loadApplicationTranslation(
                applicationTranslator,
                language)) {
            application->installTranslator(
                &applicationTranslator
            );

            qDebug()
                    << "QTranslator asennettu kielelle:"
                    << language;
        } else {
            qWarning()
                    << "Valitun kielen käännöstä ei voitu ladata."
                    << "Käytetään alkuperäisiä suomenkielisiä tekstejä.";
        }
    }

    QScopedPointer<QQuickView> view(
        SailfishApp::createView()
    );

    if (view.isNull()) {
        qCritical()
                << "QQuickView-näkymää ei voitu luoda.";
        return EXIT_FAILURE;
    }

    const QUrl mainQmlUrl =
            SailfishApp::pathTo(
                QStringLiteral(
                    "qml/SuomalaisetPyhapaivat.qml"
                )
            );

    qDebug()
            << "Ladataan QML-päänäkymä:"
            << mainQmlUrl;

    view->setSource(mainQmlUrl);

    if (view->status() == QQuickView::Error) {
        qCritical()
                << "QML-päänäkymän lataaminen epäonnistui:"
                << mainQmlUrl;
        return EXIT_FAILURE;
    }

    view->showFullScreen();

    const int result = application->exec();

    const bool restartRequested = readRestartRequested();

    qDebug()
            << "Sovellus sulkeutui. Paluukoodi:"
            << result
            << "Uudelleenkäynnistyspyyntö:"
            << restartRequested;

    if (restartRequested) {
        if (!writeDConfBoolean(RestartRequestedKey, false)) {
            qWarning()
                    << "Uudelleenkäynnistyspyyntöä ei voitu tyhjentää."
                    << "Uudelleenkäynnistystä ei tehdä silmukan välttämiseksi.";
            return EXIT_FAILURE;
        }

        if (!restartApplication()) {
            return EXIT_FAILURE;
        }

        return EXIT_SUCCESS;
    }

    return result;
}
