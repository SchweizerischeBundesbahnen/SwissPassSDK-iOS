# SwissPassClient SDK für iOS

Copyright (C) Schweizerische Bundesbahnen SBB, 2016-2019

## Übersicht

Das SwissPassClient SDK ermöglicht den mobilen Zugriff auf die SwissPass-Funktionalitäten SwissPass Login und SwissPassMobile.

### SwissPass Login

Die Authentifizierung eines Benutzers beim SwissPass Login basiert auf dem Protokoll OAuth 2.0 und dem sogenannten Authorization Code Grant. Dieser wurde für die Verwendung mit nativen Apps umgesetzt. Dabei gilt es folgende Punkte zu beachten:

* Wird ein vom SwissPass Login ausgestelltes Access Token für den Zugriff auf weitere Services resp. Daten verwendet, dann muss dieses den entsprechenden Requests als Bearer Token mitgegeben werden. Siehe dazu RFC 6750 unter https://tools.ietf.org/html/rfc6750. Die App muss in diesem Fall das Fehlerhandling gemäss OAuth 2.0 implementieren.
* OAuth Bearer Tokens können via Token Introspection beim SwissPass IAM validiert werden, siehe dazu RFC 7662 unter https://tools.ietf.org/html/rfc7662.
* Wird ein vom SwissPass Login ausgestelltes Access Token via SDK erneuert, dann kann es in seltenen Fällen vorkommen, dass diese Operation fehlschlägt. In diesem Fall wird entweder ein SwissPassLoginError.invalidToken oder ein SwissPassLoginError.invalidGrant vom SDK zurückgegeben und die App muss ein erneutes Login für den Benutzer durchführen. Tritt ein ein SwissPassLoginError.invalidJSON oder ein SwissPassLoginError.unknownError auf, dann kann ein Retry ausgeführt werden (tritt das Problem länger auf, dann sollte SwissPass kontaktiert  werden).

### SwissPassMobile

Der SwissPassMobile ist eine virtualisierte SwissPass-Karte. Dieser kann mit dem SDK durch den SwissPassMobileViewController angezeigt werden, dabei gilt es folgende Punkte zu beachten:

* Der SwissPassMobile kann vom Benutzer in bis zu 10 Apps gleichzeitig aktiviert werden. Bei mehr als 10 Aktivierungen werden bereits bestehende Aktivierungen automatisch gelöscht.
* Bei einem Logout wird die bestehende Aktivierung auf dem SwissPass deaktiviert. Dies funktioniert aber nur bei einer bestehenden Internet-Verbindung; lokal ist die Instanz aber auf jeden Fall nicht mehr aktiv.

## Verwendung des Frameworks

Das SDK ist in Swift 5 geschrieben. Es muss darum sichergestellt werden, dass die *Swift Standard Libraries* auf jeden Fall mit integriert werden. D.h. die Einstellung *Embedded Content Contains Swift Code* (EMBEDDED_CONTENT_CONTAINS_SWIFT) muss auf *YES* gesetzt werden.

* Bitcode wird ab Version 2.0 unterstützt. 
* Die allenfalls auftretende Warnung itms-90080 kann ignoriert werden, da Frameworks immer PIE sind; siehe auch [Position Independent Executable](https://developer.apple.com/library/content/qa/qa1788/_index.html#/apple_ref/doc/uid/DTS40013354)
* Um die FaceID bei der Device Owner Authentication in `requestAuthentication()` verwenden zu können muss im info.plist der Key `NSFaceIDUsageDescription` definiert sein - siehe https://developer.apple.com/documentation/localauthentication/lacontext

### CPU-Architekturen

Das kompilierte Framework kommt mit der Unterstützung für arm64, arm7 sowie x86_64 und i386 (für den Simulator). Beim Upload nach iTunes Connect müssen vorgängig die Architekturen x86_64 und i386 entfernt werden (z.B. mit 'lipo'), ansonsten gibt es einen Fehler itms-90087.

```
lipo "${SRCROOT}/SwissPassClient.framework/SwissPassClient" -remove "i386" -output "${SRCROOT}/SwissPassClient.framework/SwissPassClient"
lipo "${SRCROOT}/SwissPassClient.framework/SwissPassClient" -remove "x86_64" -output "${SRCROOT}/SwissPassClient.framework/SwissPassClient"
```
### CocoaPods

Das Framework kann mit CocoaPods direkt in den Build-Prozess integriert werden.

```
platform :ios, '9.0'
inhibit_all_warnings!

source 'https://github.com/SchweizerischeBundesbahnen/SBBCocoaPods-Ext.git'

target 'MyAppUsingSwissPassClient' do
pod 'SwissPassClient', '~> 2.2.0'
end
```

### Anforderungen

Grundsätzlich gelten folgende Anforderungen:
* iOS 9+
* Swift 5 (Xcode 10.2) 

## Weiterführende Informationen

### Kontakt

Allgemeine Anfragen, Anregungen und Feedback können über die NOVA UserGroup resp. den SwissPass gemacht werden.

### Beispiele

Eine Demo App ist unter https://code-ext.sbb.ch/projects/SID/repos/swisspassclientsdk/browse zu finden.
