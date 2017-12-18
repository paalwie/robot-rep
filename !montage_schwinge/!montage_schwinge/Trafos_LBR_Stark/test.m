function test
%Testfunktion für Vor-/Rücktrafo, G. Stark, 18.8.15

% function test (ZF)
robot=LBR_PLAT_DAT;     %Einlesen Roboterparameter

ZF=[    0 1 0 0.4;      % Zielframe
        1 0 0 0; 
        0 0 -1 0.56; 
        0 0 0 1];
kf=[0 0 0]  ;            % Wird nicht ausgewertet, fest eingestellt!!
[q err]=rtraf_7_6_gelenk(ZF,kf,robot); % Rücktrafo
q                                      % Anzeige Winkel in Kommandozeile (falls mit ";" abgeschlossen nicht!)
[model kf_neu] = dkin_7(q, robot);     % Vorwärtstrafo
figure;                                % Jede Grafikausgabe ein neues Bild
zeichne_kin_kette(model,0.1)            % Zeichne Strichmodell
view(50,20);                            % Blickrichtung
TCP=model{8}                            % Anzeige TCP, muss mit ZF übereinstimmen   
end
