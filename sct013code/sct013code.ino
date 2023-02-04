#include "EmonLib.h"
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <Wire.h>

EnergyMonitor SCT013;

//atualize SSID e senha WiFi
const char* ssid = "HackaTruckVisitantes";
const char* password = "";

//Atualize os valores de Org, device type, device id e token
#define ORG "bl64vm"
#define DEVICE_TYPE "sensorCorrente"
#define DEVICE_ID "sensorCorrente01"

//broker messagesight server
char server[] = ORG ".messaging.internetofthings.ibmcloud.com";
char topic[] = "iot-2/evt/status/fmt/json";
char authMethod[] = "use-token-auth";
char token[] = TOKEN;
char clientId[] = "d:" ORG ":" DEVICE_TYPE ":" DEVICE_ID;
 
int pinSCT = A0;   //Pino analógico conectado ao SCT-013

float Irms = 0.0;
float altitude = 0.0;

char potenciastr[6];
char correntestr[6];
 
int tensao = 127;
int potencia;

WiFiClient wifiClient;
PubSubClient client(server, 1883, NULL, wifiClient);

 
void setup()
{
  Serial.begin(115200);
  Serial.println();
  Serial.println("Iniciando...");

  Serial.print("Conectando na rede WiFi "); Serial.print(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("[INFO] Conectado WiFi IP: ");
  Serial.println(WiFi.localIP());

   //--------------------------SENSOR DE CORRENTE------------------------

 

  SCT013.current(pinSCT, 60.607);
  
}
 
void loop()
{
  
  if (!!!client.connected()) {
    Serial.print("Reconnecting client to ");
    Serial.println(server);
    while (!!!client.connect(clientId, authMethod, token)) {
      Serial.print(".");
      delay(500);
    }
    Serial.println();
  }            

  Serial.begin(115200);

  Irms = (float)(SCT013.calcIrms(1480)/100); // Calcula o valor da Corrente
  potencia = (float)Irms*tensao; // Calcula o valor da Potencia Instantanea

  Serial.print("Corrente = ");
  Serial.print(Irms);
  Serial.println (" A");
  
  Serial.print("Potencia = ");
  Serial.print(potencia);
  Serial.println (" W");

  digitalWrite(LED_BUILTIN, LOW);   
  delay(1000);
  digitalWrite(LED_BUILTIN, HIGH);
  delay(500);
  getData();

    // Conversao Floats para Strings
  char TempString[32];  //  array de character temporario

  // dtostrf( [Float variable] , [Minimum SizeBeforePoint] , [sizeAfterPoint] , [WhereToStoreIt] )
  dtostrf(Irms, 2, 1, TempString);
  String correntestr =  String(TempString);
  dtostrf(potencia, 2, 2, TempString);
  String potenciastr =  String(TempString);

  // Prepara JSON para IOT Platform
  int length = 0;

  String payload = "{\"corrente\": \"" + String(correntestr) + "\",\"potencia\":\"" + String(potenciastr) + "\"}";

  length = payload.length();
  Serial.print(F("\nData length"));
  Serial.println(length);

  Serial.print("Sending payload: ");
  Serial.println(payload);

  if (client.publish(topic, (char*) payload.c_str())) {
    Serial.println("Publish ok");
    digitalWrite(LED_BUILTIN, LOW);
    delay(1000);
    digitalWrite(LED_BUILTIN, HIGH);
    delay(1000);
  } else {
    Serial.println("Publish failed");
  }
  
  delay(1000);
}

void getData() {

  
  Irms = (float)(SCT013.calcIrms(1480)/100); // Calcula o valor da Corrente
  potencia = (float)Irms*tensao; // Calcula o valor da Potencia Instantanea
  dtostrf(Irms, 6, 0, correntestr);
  dtostrf(potencia, 6, 0, potenciastr);
}
