---
title: Offrez le WiFi à votre Arduino
slug: offrez-le-wifi-votre-arduino
description: "Connecter une carte à microcontrôleur de type Arduino au web est un besoin récurrent en particulier lorsqu’on veut collecter les données de capteurs autonomes. Les circuits intégrés ESP du fabriquant chinois Espressif répondent depuis quelques années à cette attente grâce à des modules WiFi à faible coût."
date: 2020-01-13
draft: false
in_search_index: true
tags:
- iot
---

Connecter une carte à microcontrôleur de type Arduino au web est un besoin récurrent en particulier lorsqu’on veut collecter les données de capteurs autonomes. Les circuits intégrés ESP du fabriquant chinois [Espressif](https://www.espressif.com/en/products/hardware/esp8266ex/overview) répondent depuis quelques années à cette attente grâce à des modules WiFi à faible coût.<!--more-->

Nous avons eu l’opportunité d’explorer les différentes manières de mettre à profit ce type de module dans le cadre d’un projet de badgeuse connectée à destination des tiers lieux. Le contexte est le suivant : un Arduino pilote un shield NFC (pour le badgeage) ainsi qu’un écran LCD pour l’affichage. Lorsqu’un badge est détecté, on poste les données au backend (serveur web) qui enregistre l’heure du passage et renvoie des informations mises à jour (crédits restants, par exemple).

Dans notre cas, on souhaite conserver la souplesse de l’Arduino Uno pour ce qui concerne les modules i/o nécessaires au projet. On ne s’appuiera sur l’ESP (ici un module ESP-01 à base d'ESP8266, voir figure 1) que pour les échanges avec le serveur web.

![module ESP-01](esp8266_esp-01.jpg)

Pour mettre en place ces échanges, nous avons plusieurs options.

## Commandes AT

Nous testons d’abord une approche « native » qui consiste à communiquer sur le port série grâce à des [commandes AT](https://cdn.sparkfun.com/assets/learn_tutorials/4/0/3/4A-ESP8266__AT_Instruction_Set__EN_v0.30.pdf) (Hayes), ce que permet le firmware par défaut.

Pour les premiers tests, ces commandes peuvent être envoyées via le moniteur série de l’IDE Arduino, par exemple, en connectant les pins TX/RX de l’ESP sur ceux d’un Arduino (branchement croisé). On peut notamment se référer au [montage décrit par Robin Thomas](https://create.arduino.cc/projecthub/ROBINTHOMAS/programming-esp8266-esp-01-with-arduino-011389).

Notez que nous avons rencontré des problèmes en utilisant le _baud rate_ natif de l’ESP (qui semble varier en fonction des séries, ici 115200 bauds). Il a fallu le modifier grâce à la commande :

`AT+UART_DEF=9600,8,1,0,0`

Les commandes peuvent ensuite être envoyées de manière automatisée par un Arduino. Le code suivant permet par exemple d'initialiser la connexion du module ESP à un réseau Wifi dans le `setup()`.

```arduino
#include <SoftwareSerial.h>

SoftwareSerial wifiSerial(10, 11); // RX, TX
bool DEBUG = true;

String WifiSSID = "monSSID";
String WifiPWD  = "monPWD";

/* Setup function */
void setup() {
  Serial.begin(9600);
  while (!Serial) {
    ;
  }
  wifiSerial.begin(9600);
  sendToESP("AT+RST", 2000, DEBUG);
  sendToESP("AT+CWMODE=3", 2000, DEBUG);
  sendToESP("AT+CWJAP=""+ WifiSSID + "","" + WifiPWD +""", 10000, DEBUG);
  sendToESP("AT+CIFSR", 2000, DEBUG);
  sendToESP("AT+CIPMUX=1", 2000, DEBUG);
} 

/* Main loop */
void loop() {}

/* sendToESP
* Send data to ESP8266 / ESP-01.

* Params:
* command - data/command to send;
* timeout - time to wait for a response;
* debug mode (true = yes, false = no)
* 
* Returns: Response from the esp8266 (if there is a reponse)
*/
String sendToESP(String command, const int timeout, boolean debug) {
  String response = "";
  wifiSerial.println(command); // send command to esp8266
  long int time = millis();
  while( (time+timeout) > millis()) {
    while(wifiSerial.available())   {
    char c = wifiSerial.read(); // read next character.
    response+=c;
    }  
  }
  if(debug) {
    Serial.println("< ------ réponse : ------ >");
    Serial.println(response);
  }
  return response;
}
```

Notre objectif est de réaliser des requêtes HTTP (GET / POST) vers une API RESTful, et de récupérer des données en réponse.  
C'est plutôt lourd avec cette méthode, puisqu'il faut construire les requêtes HTTP et parser l'ensemble de la réponse.

Nous avons donc choisi de déléguer cette partie à l'ESP lui-même, qui peut être programmé comme un Arduino via l'IDE habituel et bénéficier de la plupart de ses bibliothèques.

## Comme un Arduino

Nous cherchons à rendre l'ESP autonome dans sa gestion du WiFi et des requêtes.  
Il doit recevoir un identifiant d'utilisateur via le port série, puis répondre sur le même canal avec des données pertinentes qui seront affichées à l'utilisateur (nom, crédit restant, entrée ou sortie).

Pour le programmer, plusieurs possibilités :

-   construire votre propre carte de programmation, telle que décrite par [Sébastien Warin](https://sebastien.warin.fr/2016/07/12/4138-decouverte-des-esp8266-le-microcontroleur-connecte-par-wifi-pour-2-au-potentiel-phenomenal-avec-constellation/ "carte de programmation ESP-01") ;
-   Utiliser une carte du commerce, telle que [celle-ci](https://www.gotronic.fr/art-module-de-programmation-pour-esp8266-26573.htm "carte 35315 Gotronic") (la 35315 de chez GoTronic, ou son équivalent chez un distributeur chinois).

Nous avons choisi cette dernière option qui permet de rentrer rapidement dans le vif du sujet.  
Notez que le chipset CH340G de cette carte a fait planter l'un de nos Macbook pro ; une [mise à jour du driver](https://github.com/adrianmihalko/ch340g-ch34g-ch34x-mac-os-x-driver "ch340g-ch34g-ch34x-mac-os-x-driver") a résolu le problème.

**Attention** : avant chaque téléversement du croquis depuis l'IDE Arduino, pensez à basculer la carte de programmation en mode "PROG" ([cf. mode d'emploi](https://www.gotronic.fr/pj-1542.pdf "mode d'emploi 35315 Gotronic")).

Voici ci-dessous un exemple de code pour que l'ESP se connecte automatiquement au démarrage, écoute les commandes série, réalise les requêtes sur une URL donnée et transmette les données reçues.

```arduino
#include <Arduino.h>

#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>

#include <ESP8266HTTPClient.h>

#include <WiFiClientSecureBearSSL.h>

#include <ArduinoJson.h>

#ifndef STASSID
#define STASSID "monSSID" // nom du WiFi
#define STAPSK  "monPWD" // mot de passe WiFi
#endif

const char* ssid = STASSID;
const char* password = STAPSK;

ESP8266WiFiMulti WiFiMulti;

const char* postUrl = "https://www.mondomaine.fr/api/"; // url de base des requêtes, ici en POST
const int httpsPort = 443;

const byte serialInNumChars = 10;
char serialInReceivedChars[serialInNumChars];   // tableau pour le stockage des commandes séries
boolean serialInNewData = false;
boolean serialInChanged = false;

void setup() {

  Serial.begin(9600);

  for (uint8_t t = 4; t > 0; t--) {
    Serial.printf("[SETUP] WAIT %d...\n", t);
    Serial.flush();
    delay(1000);
  }

  WiFi.mode(WIFI_STA);
  WiFiMulti.addAP(ssid, password);
  Serial.printf("[SETUP] WiFi connected!");
}

void loop() {
  recvWithEndMarker();
  showNewData();
   
  if (serialInChanged) {
    if ((WiFiMulti.run() == WL_CONNECTED)) {
  
      std::unique_ptr<BearSSL::WiFiClientSecure>client(new BearSSL::WiFiClientSecure);
  
      client->setInsecure();
  
      HTTPClient https;

      Serial.println(serialInReceivedChars);
      if (https.begin(*client, postUrl)) {  // HTTPS
        https.setTimeout(10000); // timeout de 10 sec, à ajuster
        https.addHeader("Content-Type", "application/json");

        // JSON POST payload
        char payloadBuf[255];
        strcpy(payloadBuf,"{"userId": ");
        strcat(payloadBuf,serialInReceivedChars);
        strcat(payloadBuf,"}");
        int httpCode = https.POST(payloadBuf);
  
        if (httpCode > 0) {
          Serial.printf("[HTTPS] GET... code: %d
", httpCode);
          if (httpCode == HTTP_CODE_OK || httpCode == HTTP_CODE_MOVED_PERMANENTLY) {
            String payload = https.getString();
            DynamicJsonDocument jsonResponse(600); // fonction de la taille de la réponse attendue
            DeserializationError error = deserializeJson(jsonResponse, payload);
            if (error) {
              Serial.print(F("deserializeJson() failed: "));
              Serial.println(error.c_str());
            } else {
              JsonObject results_1_0 = jsonResponse["results"][1][0];
              const char* name = results_1_0["name"];
              const char* lastBadgingType = results_1_0["lastBadgingType"];
              const double totalCredit = results_1_0["totalCredit"];
              Serial.println(payload);
              Serial.print(name);
              Serial.print(" (");
              Serial.print(totalCredit);
              Serial.print(" min) ");
              Serial.println(lastBadgingType);
            }
          }
        } else {
          Serial.printf("[HTTPS] GET... failed, error: %s
", https.errorToString(httpCode).c_str());
        }
  
        https.end();
      } else {
        Serial.printf("[HTTPS] Unable to connect
");
      }
    }
    serialInChanged = false;
  }
  delay(2000);
}

void recvWithEndMarker() {
    static byte ndx = 0;
    char endMarker = '
';
    char rc;
   
    while (Serial.available() > 0 && serialInNewData == false) {
        rc = Serial.read();

        if (rc != endMarker) {
            serialInReceivedChars[ndx] = rc;
            ndx++;
            if (ndx >= serialInNumChars) {
                ndx = serialInNumChars - 1;
            }
        }
        else {
            serialInReceivedChars[ndx] = ''; // terminate the string
            ndx = 0;
            serialInNewData = true;
        }
        serialInChanged = true;
    }
}

void showNewData() {
    if (serialInNewData == true) {
        Serial.println(serialInReceivedChars);
        serialInNewData = false;
    }
}
```

_Nota Bene : L’ESP8266 est disponible sous différentes formes en fonction du rôle qu’il doit jouer dans votre projet. [Cet article](https://sebastien.warin.fr/2016/07/12/4138-decouverte-des-esp8266-le-microcontroleur-connecte-par-wifi-pour-2-au-potentiel-phenomenal-avec-constellation/ "différentes formes d'ESP8266") détaille bien les différentes possibilités._

## ESP32, l'alternative de luxe

Pour ce projet précis nous sommes tombés sur un os : le module implémentait SSL d'une manière qui n'était pas compatible avec notre infrastructure. Il reste néanmoins pertinent pour toute une gamme de projets qui mettent en oeuvre des capteurs autonomes, avec un impératif de sobriété énergétique.

Notre choix final s'est porté sur un ESP32 (une carte [Wipy 3.0 de Pycom](https://pycom.io/product/wipy-3-0/ "carte Wipy 3.0 Pycom"), précisément) qui permet de s'affranchir de l'Arduino et de tout implémenter en [micropython](http://micropython.org/ "micropython").

Ceci fera l'objet d'un prochain billet !
