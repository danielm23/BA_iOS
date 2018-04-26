# Anforderungen
Die Anwendung richtet sich an Veranstalter von Veranstaltungen an der Johannes-Gutenberg Universität Mainz. Die Bandbreite an Veranstaltungen erstreckt sich von einzelnen Terminen über mehrtägige Konferenzen bis hin zum Tag der offenen Tür mit vielfältigen Angeboten. 
Ziel ist dabei jedes mal, Gästen auf einfache Art und Weise Informationen vor und während der Veranstaltung anzubieten. Hauptsächlich wird eine Programmübersicht bereitgestellt, welche Informationen zu Ort und Zeit der Programmpunkte beinhaltet. Die Orte sind auf einer Karte visualisiert und eine Navigationsfunktion erlaubt das schnelle Auffinden des Veranstaltungsortes. Veranstaltungen können sich über mehrere Tage erstrecken, parallele Tracks beinhalten und Unterveranstaltungen beinhalten. Zu den einzelnen Programmpunkten stehen zusätzliche Informationen bereit (Beschreibungstext, beteiligte Personen, Kategorien, …). Benutzer können sich Favoriten auswählen und einen persönlichen Terminplan erstellen. Neben den Programmpunkten werden Gästen über die App auch allgemeine Informationen bereitgestellt. Während der Veranstaltung können Veranstalter Nachrichten veröffentlichen und Änderungen am Programm vornehmen. Der Zugang zu Konferenzen kann beispielsweise über QR Codes oder frei wählbare Kennungen angeboten werden.
Weiterführende Ideen sind eine erweiterte Navigation auf dem Campus (evt. mit Augmented Reality), Informationen rund um den Campus (Mensaangebot, Verkehrsanbindung, ...) oder Push-Nachrichten an Teilnehmende.
Neben der Anwendung für Konferenzen sind eine weitere Zielgruppe auch Studierende. Diese können über die App ihren Stundenplan verwalten und finden Räume einfacher. Auch unabhängige Gäste können ohne einen Login auf die Karte mit Suchfunktion zugreifen und bekommen einige Basisinformationen zum Campus.

# Entwicklungsprozess
Bei der Entwicklung möchte ich eine agile Herangehensweise wählen und Methoden aus Scrum adaptieren. Diese sind normalerweise für Teams gedacht, einige Grundideen möchte ich versuchen auch allein zu verfolgen, dazu gehören:
- Interaktive Herangehensweise statt Wasserfall,
- Zweiwöchige Sprints mit Release und Retrospektive am Ende
- Test Driven Development
- Reflexion (tägliche kurze Berichte über Fortschritt und Ziele)
- Verwaltung des Backlogs an Kanban angelehnt
- Sauberer, selbsterklärender, übersichtlicher, sicherer und performanter Code
Ich möchte einen Top-Down Ansatz in der Entwicklung wählen. Zu Beginn beschäftige ich mich intensive mit der Thematik und relativ entwickle ich einen Prototypen für die User Interaktion. Über diesen diskutiere ich mit Stakeholdern und generiere Requirements. Die Usability steht im Zentrum und gibt die Funktionen vor. Meiner Erfahrung nach ist eine zu sehr auf die Softwarearchitektur und das Datenmodel fixierte Entwicklung, bei der am Ende die Benutzeroberfläche erstellt wird, zu starr und es kommt kein optimales Produkt heraus. Tolle Algorithmen und viel Funktionalität sind wichtig, doch das Ziel sind zufriedene Benutzer. Auf der Grundlage eines durchdachten Konzeptes und Requirements werde ich iterativ über mehrere Sprints die Features implementieren und intensiv schriftlich dokumentieren.

# Szenarien
## Tagung
Der Hochschulevaluierungsverbund veranstaltet eine Tagung zu »Bildung in der digitalen Welt«. Sie findet vom 21. bis 22. März  2018 in Räumlichkeiten der Hochschule für Musik an der Universität Mainz statt. Die Veranstaltung wird von verschiedenen Teilnehmenden besucht, die auch teilweise zum ersten Mal den Campus besuchen. Einer davon ist Dr. Blum, in einer Einladungsmail bekommt er einen Link zugesandt, mit welchem er zu einer Webseite gelangt, wo grundlegende Informationen zum Programmablauf stehen. Dort findet er auch den Hinweis, dass er sich eine App herunterladen kann, um die relevanten Informationen für die Tagung auf seinem Smartphone zugänglich zu haben. Dies macht er und nachdem er die App gestartet hat, wird er aufgefordert, einen QR-Code zu scannen, der ebenfalls auf der Webseite zu finden ist. Dieses Prozedere funktioniert und Dr. Blum startet die App nicht mehr, bis zum Vortag der Tagung. Dann möchte er sich nochmals genauer mit dem Programm beschäftigen. In der App wird ihm eine Meldung angezeigt, dass sich am zweiten Tag um 13:00 Uhr ein Workshop geändert hat. Er nimmt dies zur Kenntnis, liest den Ablaufplan durch und überlegt sich bereits, welche Workshops er besuchen möchte. Hilfreich ist dabei sowohl der Beschreibungstest, als auch die zusätzlichen Informationen über die Referent*innen. Dadurch stellt er fest, dass eine Referentin die Kollegin eines ihm bekannten Professors ist, mit dem er oft zu tun hat. Er nimmt sich vor, diese am Rande der Konferenz anzusprechen, da sie auch an einem spannenden Thema arbeitet. 
Nachdem er das Programm studiert hat, wechselt er in die Kartenansicht und stellt fest, dass sich die Hochschule für Musik in unmittelbarere Nähe zur Haltestelle Friedrich von Pfeiffer Weg und der Zentralmensa befindet. Er wird am Morgen um  10:16 am Mainzer Hauptbahnhof ankommen und durch klicken auf die Haltestelle in der App, bekommt er die Information, dass er mit der Straßenbahn zum Campus gelangen kann. Am nächsten Morgen am Bahnhof schaut er nochmals nach, welche Linien er wählen kann und wie er von der Haltestelle zum Veranstaltungsort gelangt. Am Abend ist er in einem Hotel, ruft nochmals das Veranstaltungsprogramm auf und informiert sich ein wenig über die Referent*innen des zweiten Tages. Er wirft auch einen Blick auf das Angebot der Mensa. 

## Stundenplan
Marlene S. beginnt im Wintersemester 2018/19 ihr Soziologie Studium an der Johannes Gutenberg Universität Mainz. Sie stammt aus Passau und kennt die Stadt bisher nicht. Bevor das Semester beginnt, legt sie sich einen Account bei XZY an, um dort ihren Stundenplan anzulegen. Sie kann die entsprechenden Orte im Eingabeformular auswählen, ansonsten übernimmt sie die Informationen von der Anmeldesoftware der Uni Jogustine. Um sich in den ersten Tagen über ihr Smartphone dort ständig anzumelden und nachzusehen, wo sie als nächstes hin muss, scheint ihr die Seite aber nicht sonderlich geeignet. 
Während der ersten Semesterwoche hilft ihr die App, den Überblick über ihren Stundenplan zu behalten und sich auf dem Campus zurechtzufinden. Die App ist auch hilfreich, um den MuWi-Hörsaal zu finden, wo die erste Probe des Sinforma stattfindet. 

## Hochschulgruppe
Ann ist Mitglied der Hochschulgruppe Kreidestaub, die von Zeit zu Zeit auch spannende Veranstaltungen für die Öffentlichkeit, insbesondere Lehramtstudierende organisiert. Über die XYZ Webseite legt sie die bisher geplanten Veranstaltungen für das Wintersemester 2018/19 an. Der zugehörige QR Code wird auf den Flyer gedruckt, der an verschiedenen Stellen der Uni ausgelegt ist. So kann etwa auch Marlene diesen Code scannen, gelangt auf eine Webseite mit weiteren Informationen, wo sie auch einen QR Code für die App findet. So hat sie nun neben ihrem persönlichen Stundenplan auch die Veranstaltungen von Kreidestaub in der App. Wenn neue hinzugefügt werden, bekommt sie eine Nachricht in der App, kann sich den Beschreibungstext durchlesen und sieht den Veranstaltungsort auf einer Karte. 

## Tag der offenen Tür
Florian B. ist in der Oberstufe des Gymnasiums in Ingelheim und noch keinen festen Plan für seine Zeit nach dem Abitur. Am Tag der offenen Tür besucht er die Universität Mainz und möchte sich über verschiedene Studiengänge informieren. Über die Webseite der Uni erfährt er über eine App, in der das Programm des Tags der offenen Tür aufgeführt ist. Nachdem er auf der Webseite in einem PDF Dokument ein wenig stöbert und zunächst erschlagen von den vielen Studiengängen und Angeboten ist, lädt er sich die App auf sein iPhone. Die Angebote sind dort in Fachbereiche unterteilt und er wirft einen genaueren Blick auf diejenigen, die er interessant findet. Dort fügt er bereits einzelne Programmpunkte zu seinen Favoriten hinzu, um sie schnell wieder finden zu können. 
Am Tag der offenen Tür kommt Florian auf den Campus und nutzt die App, um sich zum SB II und anschliessend zur Chemie navigieren zu lassen. Dabei nutzt er seine zuvor ausgewählten Favoriten, um stets zu wissen, wo er nun hin muss. Um 14 Uhr hat er einen Programmpunkt der Philosophie und der Informatik in seinen Favoriten, da er beides äußerst interessant findet. Vor Ort entscheidet er sich für die Philosophie, da eine Bekanntschaft, die er an dem Tag gemacht hat, auch dorthin geht. 

# Architektur
Das System umfasst im wesentlichen drei Hauptkomponenten.
1. Eine Clientsoftware
2. Ein Backend Server
3. Ein Webinterface für die Konfiguration
Die unten aufgeführten Technologien sind als vage Ideen zu verstehen. 

## Server
### Aufgabe
Der Server ist die zentrale Komponente der Architektur. Hier laufen alle Informationen zusammen, werden verarbeitet und weitergereicht. Für die verschiedenen Clients werden die Informationen über eine REST API als JSON Datensätze bereitgestellt. 

### Technologie
Das Betriebssystem des Servers dient Ubuntu. Als Backend des Systems wird das Swift Framework Vapor 3 verwendet. 

### Security
Die Daten zu den Veranstaltungen sind prinzipiell über das REST URL Schema öffentlich zugänglich und abfragbar. 
Für das Anlegen von Veranstaltungen ist ein Account nötig. Nach Login mit Benutzernamen und Passwort. 

## Datenbank
### Aufgabe
Die Datenbank enthält alle Daten zu Veranstaltungen, sowie Orten und Benutzern. Das Backend abstrahiert den Zugriff darauf über eine API.
### Technologie
Als Datenbanksystem ist MariaDB vorstellbar.
## Mobile Clients
### Aufgabe
Die Clientanwendungen sind die Hauptkomponente der Architektur. Hierüber bekommen Benutzer die Inhalte dargestellt und interagieren mit dem System.
### Technologie
Es gibt eine native iOS Anwendung, die alle Dienste unterstützt. Perspektivisch ist eine Android Applikation angedacht, die zunächst wohl aber nur als ein Webview realisiert wird. Dieser kann dann auch unabhängig auf einer Webseite bereitgestellt werden.
## Webanwendung
### Aufgabe
Die Webanwendung richtet sich an Veranstaltern, die ihre Konferenz darüber abbilden können. Auch Zugänge für Gäste können hier erstellt werden.
### Technologie
Vermutlich eignet sich ein modernes Java Script Framework (Angular, Vue.js, ...)hierfür ganz gut. Über eine REST Schnittstelle können die Daten an das Backend übermittelt werden.