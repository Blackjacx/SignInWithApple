theme: Letters From Sweden, 4
build-lists: true
autoscale: true
footer: Stefan Herold • ioki • 04.12.2019
footer-style: alignment(center)
slidenumbers: true
slidenumber-style: alignment(right)

[.text: alignment(center)]

<br/>
<br/>

![filtered inline center 100%](media/logo.png)

## Sicher, schnell und einfach zum neuen Account

---

# Agenda

1. Wer bin ich & Was ist ioki?
2. Sign in with Apple - Überblick & Merkmale
3. Registrierung vs. Login
4. Backend
5. Setup Sign in with Apple & Demo
6. Summary

---

# About Me

- Stefan Herold • *@blackjacxxx 🐦*
- Mobile Dev seit 2009
- WWDC Session Notes • 2K ⭐️
- Konzern, Agentur und Startup
- Seit 2017 bei *ioki* im Herzen Frankfurts

^ 
- DTAG, N&L und flinc 
- haben sich mit ride sharing befasst
- das hat mich zu ioki geführt

---

# ioki
[.build-lists: false]

![fill](media/ioki-bg-7.jpg)

- Autonomous Driving
- Erster fahrerloser Service Deutschlands
- Bad Birnbach • Bayern
- 2 km • Stadtzentrum - Bahnhof

^
1. Tochtergesellschaft DB
1. 3 Säulen

---

# ioki
[.build-lists: false]

![fill](media/ioki-bg-8.jpg)

- Demand Responsive Transport
- Fahrzeuge nach Bedarf verteilt
- Leuchtturmprojekt mit HVV Hamburg

^
- HVV -> Deutscher Mobilitätspresi 2019

---

# ioki
[.build-lists: false]

![fill](media/ioki-bg-5.jpg)

- Whitelabel
- Passenger App (iOS & Android nativ)
- Driver App (Android Tablets mit React Native)

---

# Sign in with Apple

- schnell, einfach, sicher und privat
- kein Tracking durch Apple
- Registrierung und Login
- App erhält 
  - stabile, eindeutige *userID*
  - *Vor- und Nachame*
  - verifizierte *Email Adresse*

--- 

# Sign in with Apple

| Platform | Apple ID  |
| --- | --- |
| iOS 13+<br />iPadOS 13+<br />tvOS 13+<br />watchOS 6+<br />macOS Catalina 10.15+ | iCloud Nutzer |
| Web<br />Windows<br />Android | beliebige Apple ID |

---

# Sicher

- ~~Passwort~~
- Anti-Fraud
  - On-Device Machine Learning & Account History
  - 1-Bit-Info über Echtheit des Users
  - iOS only
- Zwei-Faktor-Authentisierung 

---

# Privat

![right 75%](media/apps-lambus-settings.jpeg)

Eindeutige, zufällige Email-Adresse
*privaterelay.appleid.com*

- App sieht nur *diese* Adresse
- Kommunikation mit *genau einem* Developer
- Zwei-Wege-Kanal
- Über Einstellungen änder-/deaktivierbar
-  speichert keine Emails

^
- Facebook $ Co leiten original Email weiter
- Rückschlüsse auf Nutzerverhalten erschwert

---

# Wer's braucht[^1]

Apps die exklusiv third-party login service nutzen

- Facebook Login
- Google Sign-In
- Sign in with Twitter
- Sign In with Linked-In
- Login with Amazon
- WeChat Login

---

# Wer nicht

- App nutzt firmeneigenes Login-System
- App nutzt Ausweisbasiertes Login-System
- App ist Client für 3rd party / social service
- Bildungs-, Enterprise- oder Business-App mit existierendem Firmen-Account

^
- Email / Password
- Ausweis, Reisepass, E-ID
- Facebook oder Twitter Client
- Mitarbeiterportal von Konzernen

---

# Apps

![right 75%](media/apps-bird.jpeg)

| App          | Email  | Name  |
| ------------ | :----: | :---: |
| Bird         | ✅     | ✅   | 
| Lambus       | ✅     | ✅   | 
| Bring        | ✅     | ✅   | 
| Blinkist     | ✅     | ❌   | 
| Parcel       | ❌     | ❌   | 

^
- E-Scooter Verleih
- Travel Planner
- Einkaufslistenapp mit Kundenkarten Wallet
- Kurze Zusammenfassungen beliebter Sachbücher
- Tracken von Versandstati

--- 

# Apps

![inline](media/apps-fretello.png) ![inline](media/apps-bird.jpeg) ![inline](media/apps-lambus.jpeg) ![inline](media/apps-bring.jpeg) ![inline](media/apps-blinkist.jpeg) 

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

# Registrierung

Authorization Request returns:

- *UserID* • eindeutig, stabil über alle Geräte mit gleicher AppleID
- *Identity Token* • Nutzerverifizierung 
- *Auth Code* • Refresh Token
- *Real User Indicator* - Boolean: User / Unknown
- *Credential State* - authorized, revoked, notFound
- *Vor- und Zuname* als PersonNameComponents[^3]
- *Verifizierte Email* - entfällt beim Onboarding[^3]

[^3]: Facebook & Co leiten weit mehr Informationen weiter

^
- userID: Bleibt unverändert • selbst nach Trennung von App & AppleID (Settings)
- userID: Authorisierungs-Status, Accouint Recovery, Account Lockout, Customer Support

---

# Registrierung

![right 25%](media/apps-checkmark.png)

- Name editierbar
- Nutzer entscheidet über verwendete Email
- Fake Email per Relays
- ~~Lästige Formulare~~
- ~~Keyboard~~
- ~~Verifizierung~~
- ~~2FA~~

---

# Login

Beim Appstart:

```swift
let provider = ASAuthorizationAppleIDProvider()

// Very fast API to be called on app launch to handle log-in state appropriately.
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

---

# Demo

- Vorbereitung von Xcode
- *Sign in with Apple* Button hinzufügen
- Registrierung neuer Nutzer
- Login registrierter Nutzer
- Statuscheck beim Appstart
- Logout Handling, z.B. von anderem Gerät
- Tokeninvalidierung durch Nutzer über iOS Settings

^
1. SIWA Capability ➡️ Xcode
1. Xcode erzeugt App ID mit SIWA Capability ➡️ Dev Portal
1. CODE DEMO
1. Revoke
- Settings.app ➡️ your Apple ID ➡️ Password & Security ➡️ Apps Using your Apple ID
- If a user revokes Sign in with Apple, but then goes back to register with it in your app, 
so far in my testing the user value stays the same. 
This is great news for account recovery / lockout / customer support. 
Consider this revoke action more of a "log out" than a deletion or something.

---

# Backend Good To Know

[.build-lists: false]

- Identity Token zur Verifizierung der *userID*
- Private Key zum Entschlüsseln des Tokens
- Token nur bei Registrierung - 10 min gültig
- OAuth Flow (Access-/Refresh-Token) notwendig[^2]

---

# Backend - OAuth

![inline](media/oauth.png)

---

# Zusammenfassung

- Überblick über Vorteile
- Was bedeuten Sicher & Privat
- *Theorie:* Registrierung & Login
- *Praxis:* Erweitern einer bestehenden App
  - Einrichten von Developer Portal & Xcode
  - Registrierung, Login, Statusänderungen
- Exkurs Backend: *Fallstricke*

---

# Vielen Dank Für's Zuhören 🎉

👩‍💻 Apple Docs
*https://developer.apple.com/sign-in-with-apple*
👨‍⚖️ Review Guidelines
*https://developer.apple.com/app-store/review/guidelines/#sign-in-with-apple*
👨‍💻 REST API
*https://developer.apple.com/documentation/signinwithapplerestapi*
🧐 Demo App Code
*https://github.com/Blackjacx/SignInWithApple*
📺 Introducing Sign In with Apple - Session Video Notes
*https://github.com/Blackjacx/WWDC#introducing-sign-in-with-apple*
🔑 Token Handling im Backend
*https://blog.curtisherbert.com/so-theyve-signed-in-with-apple-now-what*

🐦 Twitter
*@blackjacxxx*

---

# Backup - Mehr Links

- Answers to your bruning questions
*https://techcrunch.com/2019/06/07/answers-to-your-burning-questions-about-how-sign-in-with-apple-works*
- Ray Wenderlich Tutorial mit SwiftUI
*https://www.raywenderlich.com/4875322-sign-in-with-apple-using-swiftui*
- Erzeugen des Private Keys
*https://developer.apple.com/account/resources/authkeys/add*
- Konfiguration erlaubter Email-Adressen
*https://developer.apple.com/account/resources/services/configure*
- Sign in with Apple für Web
*https://developer.okta.com/blog/2019/06/04/what-the-heck-is-sign-in-with-apple*
- 9To5Mac Artikel
*https://9to5mac.com/2019/10/15/how-to-use-sign-in-with-apple-iphone-ipad-mac*

---

# Backup - Todo

- OAuth Diagramm in Sketch
- create backup videos demoing all steps from Demo section

- use ioki iPhone 7 Plus phone number as trusted number
- send the PDF presentation including the github url to ane@ix.de (due 27.11.)

[^1]: https://developer.apple.com/app-store/review/guidelines/#sign-in-with-apple

[^2]: https://blog.curtisherbert.com/so-theyve-signed-in-with-apple-now-what