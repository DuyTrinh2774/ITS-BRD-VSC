# PrimzahlSieb: Konzept

## 1. Analyse der Aufgabenstellung
    Der Algorithmus von Eratosthenes basiert darauf, nicht Primzahlen zu "suchen", sondern Nicht-Primzahlen systematisch zu "streichen". Wir arbeiten mit einer Obergrenze von 1000. Da jede Zahl ihren eigenen Platz im Speicher erhalten soll, nutzen wir den Index des Feldes als Zahlwert. Eine 1 im Feld bedeutet "ist Primzahl", eine 0 bedeutet "ist keine Primzahl".

## 2. Speicheraufbau
    siebArray (1001 Bytes): Hier liegt das "Sieb". Index 0 bis 1000 repräsentieren die jeweiligen Zahlen. Wir nutzen Bytes, um Speicherplatz zu sparen.

    primzahlenArray: Hier speichern wir später nur die gefundenen Primzahlen (als Word/Integer), um sie weiterverwenden zu können.

## 3. Javaprogramm
    public class PrimzahlSieb {
        // Definition des Limits
        private static final int LIMIT = 1000;
        // Das Sieb-Feld: Index 0-1000, Inhalt Byte (1 oder 0)
        private static byte[] sieb = new byte[LIMIT + 1];

        public static void main(String[] args) {
            // SCHRITT 1: Initialisierung
            // Alle Zahlen ab 2 erst einmal auf 1 (true) setzen, da wir anfangs jede Zahl als potenzielle Primzahl betrachten.
            for (int i = 2; i <= LIMIT; i++) {
                sieb[i] = 1;
            }

            // SCHRITT 2: Siebung
            // Wir gehen von 2 bis zur Wurzel aus 1000 (ca. 31).
            for (int p = 2; p * p <= LIMIT; p++) {
                // Wenn an Stelle p eine 1 steht, ist p eine Primzahl.
                if (sieb[p] == 1) {
                    // Streiche alle Vielfachen von p. Starten bei p * p, da das kleinere Vielfache bereits durch kleinere Primzahlen gestrichen wurden.
                    for (int i = p * p; i <= LIMIT; i += p) {
                        sieb[i] = 0; // 0 bedeutet "keine Primzahl"
                    }
                }
            }

            // SCHRITT 3: Abspeichern
            // Sieb durchgehen und schreiben jeden Index, der noch eine 1 enthält, in ein neues Feld für die gefundenen Primzahlen.
            int count = 0;
            for (int i = 2; i <= LIMIT; i++) {
                if (sieb[i] == 1) {
                    // Hier würde in Assembler das Abspeichern ins primzahlenArray erfolgen
                    count++;
                }
            }
        }
    }
