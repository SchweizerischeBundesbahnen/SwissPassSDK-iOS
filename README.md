# SwissPassClient SDK für iOS

Copyright (C) Schweizerische Bundesbahnen SBB, 2016-2018

## Übersicht

Das SwissPassClient SDK wird dazu verwendet Mobile Apps mit dem SwissPass-Login auszustatten. Neben dem eigentlichen Login können Benutzer-Attribute abgefragt werden und mit den vom SwissPass ausgestellten OAuth 2.0-Tokens kann auf weitere, geschützte Ressourcen zugegriffen werden. 

Das SDK erfüllt dabei u.a. folgende Anforderungen:

* Die User Credentials werden im SafariViewController eingegeben, ein Zugriff auf die Credentials von der App aus ist nicht möglich.
* User Credentials, Tokens und Client Secrets werden getrennt verwaltet um das Risiko bei Exploits zu minimieren.
* Wird ein Jailbreak festgestellt, dann wird der Benutzer gefragt ob er das SDK weiterhin verwenden möchte. 

### OAuth 2.0

Die Authentifizierung eines Benutzers beim SwissPass basiert auf dem Protokoll OAuth 2.0 und dem sogenannten Authorization Code Grant. Dieser wurde für die Verwendung mit nativen Apps umgesetzt. Dabei werden folgende Schritte durchlaufen:

1. Die App erstellt den Authentication Request via SwissPassClient SDK.
2. Das SwissPassClient SDK sendet den Request via SafariViewController zum SwissPass Authorization Server.
3. Der SwissPass Authorization Server authentisiert den Benutzer basierend auf Username und Passwort.
4. Der SwissPass Authorization Server holt sich die Benutzereinwilligung für die gewünschte Anwendung ein (optional, aktuell nicht konfiguriert).
5. Der SwissPass Authorization Server sendet dem SwissPass-Backend (via HTTP Redirect) einen Authorization Code und informiert das SwissPassClient SDK in der App (via HTTP Redirect).
6. Bei positivem Verlauf holt sich das SwissPassClient SDK beim SwissPass-Backend sowohl das Access Token als auch das Refresh Token und übergibt das Access Token der App (das Refresh Token wird verschlüsselt abgelegt). Die Tokens werden vom SwissPass-Backend jeweils mittels des Authorization Codes beim SwissPass Token-Endpoint eingefordert.

Der OAuth-Client ist in diesem Fall also eine Kombination aus App und Backend, welches die eigens vom SwissPassClient SDK spezifizierten Endpoints zur Verfügung stellt. Dieses Backend wird dabei vom SwissPass für alle Clients zur Verfügung gestellt.

Wird das Access Token für den Zugriff auf weitere Services resp. Daten verwendet, dann muss dieses den entsprechenden Requests als Bearer Token mitgegeben werden. Siehe dazu RFC 6750 unter https://tools.ietf.org/html/rfc6750.

## Verwendung des Frameworks

* Das SDK basiert auf den Best Practices und allgemeinen Entwicklungsrichtlinien für die iOS-Plattform. Es ist in Swift 3.2 geschrieben und [kann auch von Objective-C aus verwendet werden](https://developer.apple.com/library/content/qa/qa1881/_index.html). Dabei muss sichergestellt werden, dass die *Swift Standard Libraries* auf jeden Fall mit integriert werden. D.h. die Einstellung *Embedded Content Contains Swift Code* (EMBEDDED_CONTENT_CONTAINS_SWIFT) muss auf *YES* gesetzt werden.
* Das kompilierte Framework kommt mit der Unterstützung für arm64, arm7 sowie x86_64 und i386 (für den Simulator). Beim Upload nach iTunes Connect müssen vorgängig die Architekturen x86_64 und i386 entfernt werden (z.B. mit 'lipo'), ansonsten gibt es einen Fehler itms-90087. 
* Bitcode wird aktuell noch nicht unterstützt.
* Die allenfalls auftretende Warnung itms-90080 kann ignoriert werden, da Frameworks immer PIE sind; siehe auch [Position Independent Executable](https://developer.apple.com/library/content/qa/qa1788/_index.html#/apple_ref/doc/uid/DTS40013354)
* Die HTTP-Redirects in die App sollen mittels [Universal Links](https://developer.apple.com/library/content/documentation/General/Conceptual/AppSearch/UniversalLinks.html) realisiert werden. Dies bedingt die Verfügbarkeit einer entsprechenden Domain (WebServer).

Beispiel lipo:

```
lipo "${SRCROOT}/SwissPassClient.framework/SwissPassClient" -remove "i386" -output "${SRCROOT}/SwissPassClient.framework/SwissPassClient"
lipo "${SRCROOT}/SwissPassClient.framework/SwissPassClient" -remove "x86_64" -output "${SRCROOT}/SwissPassClient.framework/SwissPassClient"
```

### Anforderungen
* iOS 9+
* Swift 3.2 (Xcode 9)

## Weiterführende Informationen

### SDK

Das SwissPassClient SDK ist inklusive einer Demo App unter https://code-ext.sbb.ch/projects/SID zu finden.
