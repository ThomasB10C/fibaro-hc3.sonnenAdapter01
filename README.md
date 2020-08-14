|sbAdapter für Fibaro HC3               |für sonnenBatterie Eco8.0 und Eco10.0    |
|:-------------------------------------:|:------------------------------------:|
|![sbAdapterLogo](/Images/sbAdapter-Icon.png)   |![sonnenLogo](/Images/sonnenLogo450.png)             |

# sonnenAdapter01 für Fibaro HC3
QuickApp für die sonnenBatterie EC8.0 und Eco10.0

## Kurzbeschreibung
Die QuickApp liest ausgewählte Betriebsdaten der sonnenBatterie über deren API-Schnittstelle aus und stellt diese in der QuickApp als Übersicht zur Verfügung. Die Daten werden regelmäßig zyklisch aus der API ausgelesen.

## Settings
In den Variablen der QuickApp können die folgenden Parameter voreingestellt werden:

1. **ip:** - IP-Adresse der sonnenBatterie in der Form 999:999:999:999
2. **wait:** - Schalter, damit kann die QuickApp in den Leerlauf versetzt werden (wait= **yes**)
3. **interval:** - Zeiteinstellung für den Abfragezyklus der Batteriedaten (interval= **60** steht für 60 Sekunden = 1 Minute)

Hinweis: der Parameter **interval** wird im unteren Bereich auf mindestens 60 Sekunden begrenzt, damit die Batterie noch weitere Datenabfragen bedienen kann.

## Globale Variablen
Die folgenden Livedaten werden von der QuickApp auch simultan im zentralen Bereich für globale Variablen abgespeichert. Damit wird die Möglichkeit geschaffen, die Werte bzw. die Zustandswerte der Variablen auch für Automatisierungen in Szenen zu verwenden.

1. **sbTimeStamp:** - Zeitstempel für die letzte Messung. Der Zeitstempel zeigt das Datum in der Form <yyyy-mm-dd> und die Uhrzeit in der Form <hh:mm:ss> an.  

2. **sbSystemstatus:** - Systemstatus der sonnenBatterie. Die Statuswerte *OnGrid* bzw.*OffGrid* werden aus der API übernommen.

3. **sbProduction:** - Erzeugung der Photovoltaikanlage in kW zum Zeitpunkt der Datenabfrage.

4. **sbConsumption:** - Verbrauch in kW zum Zeitpunkt der Datenabfrage.

5. **sbGridFeedIn:** - Netzeinspeisung (**positiver Wert**) bzw. **Netzbezug** (**negativer Wert**) in kW zum Zeitpunkt der Datenabfrage.

6. **sbPac_total:** - Ladung bzw. Entladung der sonnenBatterie in kWh zum Zeitpunkt der Datenabfrage. Bei **Ladung** der Batterie wird ein **negativer Wert** angezeigt, bei **Entladung** der Batterie wird ein **positiver Wert** angezeigt.

7. **sbRSOC:** - Ladezustand der sonnenBatterie in %. Der Ladezustand der Batterie greift auf die API-Daten zurück, der Wertebereich liegt zwischen 0% und 100%.
  
## Voraussetzungen
Für die Nutzung des sonnenAdapters01 ist ein SmartHome-System von Fibaro HC3 erforderlich. QuickApps sind Erweiterungen des Funktionsumfangs des Hubs, diese werden dort als "Geräte" verwaltet.

## Ansichten
**Datenübersicht**

Die QuickApp stellt eine Datenübersicht zur Verfügung, die ermittelten Leistungsdaten der sonnenBatterie werden als Livedaten angezeigt.

![dataview](/Images/sbA1-LivedatenÜbersicht450.png "Datenübersicht")

**Globale Variablen**

Die QuickApp speichert im zentralen Bereich des HC3 für Variablen jeweils die aktuell ermittelten Werte der sonnenBatterie ab. Voraussetzung dafür ist es, das vom Benutzer diese Variablen dort hinzugefügt wurden und der interne Parameter "globaleValues" in der QucikApp auf "yes" gesetzt worden ist. Weiterhin müssen die hinzugefügten Variablennamen in der gleichen Schreibweise eingegeben werden, wie sie hier darunter vorgegeben wurden!

![viewGlobaleVariablen](/Images/sbAdapter-GlobaleVariablen450.png "Globale Variablen")

Die folgenden globalen Variablen sollte der Nutzer im Fibaro HC3 als globale Variablen hinzufügen.

1. **sbTimestamp** - Zeitstempel der letzten Datenabfrage.
2. **sbSystemStatus** - Systemstatus der Batterie.
3. **sbProduction** - Erzeugung der Photovoltaik-Anlage in kW.
4. **sbConsumption** - Verbrauch des Hauses in kW.
5. **GridFeedIn** - Einspeisung bzw. Bezug von Strom in kW, ein negativer Wert steht für einen Strombezug aus dem öffentlichen Stromnetz bzw. der sonnen-Community.
6. **sbPac_total** - Ladung bzw. Entladung der Batterie in kW, ein negativer Wert steht für die Ladung der Batterie.
7. **sbRSOC** - Dieser Wert zeigt den Ladestand der Batterie an; die Werte haben einen Bereich von 0% bis 100%.

**Lokale Variablen und Parameter der QuickApp**

Zur Inbetriebnahme der QuickApp ist es erforderlich, in den **lokalen Variablen** der QuickApp mehrere der unten angegebenen Parameter festzulegen. 

Die **Parameter** der QuickApp sind auf die folgenden Standardwerte voreingestellt:

1. **ip** = **change-id**. Dieser Parameter ist durch die IP-Adresse der eigenen sonnenBatterie zu ersetzen. Dafür rechts das Symbol mit dem Bleistift wählen, die IP-Adresse eingeben und den Wert abspeichern.

2. **interval** = **60**. Dieser Standardwert steht für einen Abfragezyklus von ca. 60 Sekunden bzw. 1 Minute. Es kann auch ein größer Wert eingegeben werden. Dieses wird empfohlen, um die Performance des HC3-Hubs nicht unnötig zu belasten, bspw. hat sich ein Interval von 120 Sec. bewährt (interval= 120).

3. **wait** = **no**. Mit diesem Parameter kann der Benutzer den Wartezustand für die Datenabfrage aktivieren, die QuickApp fragt dann die Batteriedaten nicht mehr ab (diese Funktion wurde eingebaut, weil im HC3 ein Schalter zum Deaktivieren der QuickApp fehlt, wodurch die App ständig läuft).

4. **globaleValues** = **no**. Dieser Parameter kann auf **yes** gestellt werden, wenn der Nutzer die Speicherung der Livedaten im zentralen Bereich den globalen Variablen herbeiführen möchte und vorher diese Variablen dort hinzugefügt hat.

![viewlokaleVariablen](/Images/sbAdapter-lokaleParameterundDaten450mask.png "lokale Variablen")

## Szenen und Automatisierungen

Mit SmartHome-Systemen können Automatisierungen im Haus, in Wohnungen oder auch in anderen Locations aufgebaut werden. Das System Fibaro HC3 steht für ein System, mit dem man sehr umfangreiche Automatisierungen realisieren kann. Automatisierungen können dort mit s.g. **Szenen** aufgebaut werden. Ein versierter Nutzer entwickelt in der Regel mehrere bis über 100 Szenen, mit denen er in seinem Haus automatische Abläufe realisiert.

**Szenen** sind nach dem Muster **If** - **Then** - **Else** strukturiert und können so verstanden werden: **Wenn** ein Zustand eines Gerätes, einer Variablen oder ein Ereignis eintritt, bspw. *die Haustür wurde geöffnet*, **dann** werden die folgenden Aktionen ausgelöst, bspw. *die Flurlampen angeschaltet*.

Für den Aufbau von Szenen stehen im Fibaro HC3 zwei Editoren zur Verfügung. Ein grafischer Blockeditor, mit dem auch nicht programmieraffine Nutzer Automatisierungen aufbauen können, und ein LUA-Editor, mit dem ein Nutzer mit Neigung zur Programmierung, Kenntnissen der Programmiersprache **LUA** und von speziellen Systemfunktionen des Fibaro-Systems, dann auch sehr komplexe Steuerungen von Geräten, Schaltern, Lampen, Sirenen o.ä. Equipment realisieren kann. 

Solche Geräte, die im Fibaro-System noch nicht standardmäßig implementiert werden können, steht das Instrument **QuickApp** zur Verfügung. Mit QuickApps können somit zusätzliche Geräte in ein SmartHome-System eingebunden werden.

Hier setzt die QuickApp **sonnenAdapter01** für die sonnenBatterie an. Diese QuickApp wird als zusätzliches Gerät in das System eingefügt und fragt nach der Inbetriebnahme ausgewählte Betriebsdaten einer sonnen-Batterie über deren API-Schnittstelle ab (wie oben bereits erläutert). 

Um nun die ermittelten Livedaten der sonnen-Batterie auch für Automatisierungen nutzen zu können, stellt der sonnenAdapter1 die ermittelten Daten als Variablenwerte, a) zur Anzeige und b) für die Verwendung in Szenen zur Verfügung.

Damit kann man jetzt, bspw. bei dem Erreichen eines festgelegten Erzeugungswertes für die Produktion einer Photovoltaikanlage, einen zusätzlichen Verbraucher zuschalten, auch eine Nachricht an ein Handy oder eine Mitteilung an einen Mail-Account versenden lassen, um diesen Sachverhalt mitzuteilen.

Das folgende Bild zeigt ein Beispiel für eine grafische Blockszene, die gestartet (getriggert) wird, wenn die PV-Anlage abgeregelt wurde, bspw. bei dem Erreichen der 70% Grenze für die maximale Einspeisemenge in das öffentliche Stromnetz. Dafür werden die Leistungsdaten für die Produktion, die Einspeisung und die aktuellen Daten eines SolarEdge-Wechselrichters (siehe seAdapter01) benutzt (Bedingung **If**). Sobald alle Bedingungen erfüllt sind (**Trigger/On + UND**), wird ein Verbraucher, hier ist es ein WallPlug, oder ein Verbaucher mit einer hohen Leistung (**Then**) angeschaltet. Gleichzeitig wird an den Anlagenbetreiber eine Mitteilung versendet, mit deren Hilfe der Anlagenbetreiber die Information erhält, dass die PV-Anlage gerade abgeregelt worden ist. Welche Geräte nach Erfüllung der Bedingungen hinzu geschaltet werden, kann der Nutzer mit Blockszenen frei festlegen.

![SampleSzene](/Images/SampleSzene450.png "Beispiel für eine Szene")

Ein anderes Beispiel für eine sinnvolle Szene wäre die Übermittlung einer Nachricht, wenn die Batterie leer ist oder die Batterie bereits am 2. Tag keinen Ladevorgang mehr durchgeführt hat, obwohl an diesen Tagen von der PV-Anlage Strom erzeugt wurde. Diese Automatisierung würde man in einer LUA-Szene aufbauen und ausführen lassen.

## API-Schnittstelle der sonnenBatterie

Die QuickApp sonnenAdapter1 nutzt die folgende Abfragesyntax zur zyklischen Erfassung der Livedaten der sonnenBatterie:

````http://<ip-sonnenBatterie>:8080/api/v1/status````

Diese Daten werden zur Anzeige gebracht und in den lokalen bzw. globalen Variablen als Momentanwerte gespeichert; eine Langzeitspeicherung der Daten, bspw. in einer Datenbank, erfolgt nicht.

Die folgenden API-Daten der Batterie werden verarbeitet:

##### JSON

````
{
...,
"Consumption_W":358,
...,
"GridFeedIn_W":5065,
...,
"Pac_total_W":-1031,
"Production_W":6458,
"RSOC":58,
...,
"SystemStatus":"OnGrid",
"Timestamp":"2020-08-05 13:18:30",
...
}
````
