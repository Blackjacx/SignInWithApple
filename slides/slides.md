theme: Letters From Sweden, 4
build-lists: false
autoscale: true
footer-style: alignment(center)
slidenumbers: true
slidenumber-style: alignment(left)

<!-- footer: Stefan Herold • ioki • 04.12.2019 -->

[.text: alignment(center)]

<br/>
<br/>

![filtered inline center 100%](media/logo.png)

## Sicher, schnell und einfach zum neuen Account

---

# About Me

- Stefan Herold • *@blackjacxxx 🐦*
- Mobile Dev seit 2009
- Seit 2017 bei *ioki* im Herzen Frankfurts

---

# ioki

[.build-lists: true]

![fill](media/ioki-bg-8.jpg)

- Demand Responsive Transport
- Leuchtturmprojekt mit HVV Hamburg
- Whitelabel Passenger App • iOS & Android
- Driver App • React Native
- Backend • Ruby

^
- Tochtergesellschaft DB
- Kunden: Landkreise, Verkehrsbertriebe, Firmen
  - Autonomes Fahren
  - Consulting durch Analytics Team mit Hilfe von Simulationen -> Bedarfsfelder für Kunden
  - Demand Responsive Transport
    - Transport von Personen von einem Ort zum Anderen
    - Fahrzeuge nach Bedarf verteilen & dynamisch skalieren

---

# Sign in with Apple

[.build-lists: true]

- Registrierung und Login
- schnell, sicher und privat
- kein Tracking durch Apple
- App erhält:
  - stabile, eindeutige *userID*
  - *Vor- und Nachname*
  - *Email Adresse*

^
- Facebook & Co leiten weit mehr Informationen weiter

--- 

# Sign in with Apple

| Platform | Apple ID  |
| --- | --- |
| iOS 13+<br />iPadOS 13+<br />tvOS 13+<br />watchOS 6+<br />macOS Catalina 10.15+ | iCloud Nutzer |
| Web<br />Windows<br />Android | beliebige Apple ID |

---

# Sicherheit

- Kein Passwort
- Zwei-Faktor-Authentisierung 
- Anti-Fraud

^
- 1-Bit-Info über Echtheit des Users
- Jahrelang entwickelter Algorithmus
- On-Device Machine Learning / Account History
- iOS only

---

# Privatsphäre

[.build-lists: true]

![right 130%](media/apps-checkmark-settings.jpeg)

Eindeutige, zufällige Email
*privaterelay.appleid.com*

App sieht nur *diese* Email

- Kommunikation mit *genau einem* Developer
- Zwei-Wege-Kanal
- Kein speichern von Emails
- Weiterleitung deaktivierbar

^
- Facebook & Co leiten original Email weiter
- Rückschlüsse auf Nutzerverhalten erschwert

---

# Wer's braucht

Apps die exklusiv 3rd-Party Login-Services nutzen

- *Facebook*, *Google*, *Twitter*, *Linked-In*, *Amazon*, ...
- Pflicht für neue Apps: *ab heute*
- Pflicht für existierende Apps: *ab April 2020*

---

# Wer nicht

[.build-lists: true]

- App nutzt firmeneigenes Login-System
- App nutzt ausweisbasiertes Login-System
- App ist Client für 3rd party / social service
- Bildungs-, Enterprise- oder Business-App mit existierendem Firmen-Account

^
- Email / Password
- Ausweis, Reisepass, E-ID
- Facebook oder Twitter Client
- Mitarbeiterportal von Konzernen

--- 

# Apps

![inline](media/apps-fretello.png) ![inline](media/apps-lambus.jpeg) ![inline](media/apps-bring.jpeg) ![inline](media/apps-blinkist.jpeg) 

---

# Registrierung

![right 95%](media/apps-bird.jpeg)

| App          | Email  | Name  |
| ------------ | :----: | :---: |
| Bird         | ✅     | ✅   | 
| Lambus       | ✅     | ✅   | 
| Bring        | ✅     | ✅   | 
| Blinkist     | ✅     | ❌   | 
| Parcel       | ❌     | ❌   | 

^
• Name editierbar
• Nutzer entscheidet über Email
• Keine lästigen Formulare
• Keine Verifizierung
• 2FA einfach wie Touch- / FaceID

---

# Registrierung

[.build-lists: true]

Folgendes bekommen wir:

- *UserID* • eindeutig, stabil über alle Geräte mit gleicher AppleID
- *Identity Token* • JWT zur Nutzerverifizierung • 10 min
- *Auth Code* • Refresh Token
- *Verifizierte Email* • entfällt beim Onboarding
- *Vor- und Zuname* • PersonNameComponents
- *Real User Indicator* • Enum: likelyReal, unknown, unsupported

^
UserID unverändert
- selbst nach Trennung der App von SIWA > iOS Settings
- ermöglich Backend-Features wie Account Recovery, Account Lockout
- Customer Support stark vereinfacht
- Verhindert Nutzer Duplikate in DB

---

# Demo 👨‍💻

^
- Capability ➡️ Xcode
\> Xcode erzeugt AppID mit SIWA Cap
- SIWA Button
- Registrierung neuer Nutzer
- Login registrierter Nutzer
- Statuscheck beim Appstart
- Auf Tokeninvalidierung reagieren

^
- Revoke von *appleid.apple.com*

---

# Vielen Dank Für's Zuhören 🎉

🧐 Demo App Code & Slides
*https://github.com/Blackjacx/SignInWithApple*
📺 Introducing Sign In with Apple - Session Video Notes
*https://github.com/Blackjacx/WWDC#introducing-sign-in-with-apple*


👩‍💻 Apple Docs
*https://developer.apple.com/sign-in-with-apple*
👨‍⚖️ Review Guidelines
*https://developer.apple.com/app-store/review/guidelines/#sign-in-with-apple*
👨‍💻 REST API
*https://developer.apple.com/documentation/signinwithapplerestapi*


🐦 Twitter
*@blackjacxxx*

---

# Mehr Links

- Answers to your bruning questions
*https://techcrunch.com/2019/06/07/answers-to-your-burning-questions-about-how-sign-in-with-apple-works*
- Token Handling im Backend
*https://blog.curtisherbert.com/so-theyve-signed-in-with-apple-now-what*
- Ray Wenderlich Tutorial mit SwiftUI
*https://www.raywenderlich.com/4875322-sign-in-with-apple-using-swiftui*
- Sign in with Apple für Web
*https://developer.okta.com/blog/2019/06/04/what-the-heck-is-sign-in-with-apple*
- 9To5Mac Artikel
*https://9to5mac.com/2019/10/15/how-to-use-sign-in-with-apple-iphone-ipad-mac*
- How to integrate Sign In with Apple in your iOS app
*https://benoitpasquier.com/how-to-integrate-sign-in-with-apple-ios/*
- Auth0 - Sign In With Apple
*https://auth0.com/docs/quickstart/native/ios-swift-siwa/00-login*
- Why sign-in with apple may take you more than 5 minutes and how it works?
*https://dev.to/michalrogowski/why-sign-in-with-apple-may-take-you-more-than-5-minutes-and-how-it-works-55p6*

- Erzeugen des Private Keys
*https://developer.apple.com/account/resources/authkeys/add*
- Konfiguration erlaubter Email-Adressen
*https://developer.apple.com/account/resources/services/configure*
- Why isn't the user data being returned every time?
*https://forums.developer.apple.com/thread/119826*

---

# Backup

---

# ioki

![fill](media/ioki-bg-7.jpg)

- Autonomous Driving
- Erster fahrerloser Service Deutschlands
- Bad Birnbach • Bayern
- 2 km • Stadtzentrum - Bahnhof

^
1. Tochtergesellschaft DB
2. 3 Säulen

---

# Registrierung

```swift
func didPressSignInWithApple(_ sender: UIButton) {

  let provider = ASAuthorizationAppleIDProvider()
  let request = provider.createRequest()
  request.requestedScopes = [.email, .fullName] // optional - only request what's required

  let controller = ASAuthorizationController(authorizationRequests: [request])
  controller.delegate = self
  controller.presentationContextProvider = self
  controller.performRequests()
}
```

---

# Login

Beim Appstart:

```swift
let provider = ASAuthorizationAppleIDProvider()

provider.getCredentialState(forUserID: userId) { (state, error) in
  // evaluate state
}
```

State-Änderungen:

```swift
let name = ASAuthorizationAppleIDProvider.credentialRevokedNotification
center.addObserver(forName: name, object: nil, queue: nil) { [weak self] _ in
  self?.performSignOut()
}
```

^
- getCredentialState läuft lokal (mit conditioner 100% loss)
