import json
import os

DATA_FILE = "data/devices.json"

# Devices par défaut si le fichier n'existe pas
DEFAULT_DEVICES = [
    {
        "id": "led-001",
        "name": "LED Bureau",
        "type": "actuator",
        "location": "Salle A101",
        "state": "off"
    },
    {
        "id": "temp-001",
        "name": "Capteur Température",
        "type": "sensor",
        "location": "Salle A101",
        "value": 22.5
    }
]

def load_devices():
    """Charge les devices depuis le fichier JSON ou crée le fichier si absent."""
    if not os.path.exists("data"):
        os.makedirs("data")
    if not os.path.isfile(DATA_FILE):
        save_devices(DEFAULT_DEVICES)
        return DEFAULT_DEVICES
    with open(DATA_FILE, "r", encoding="utf-8") as f:
        return json.load(f)

def save_devices(devices):
    """Sauvegarde la liste des devices dans le fichier JSON."""
    with open(DATA_FILE, "w", encoding="utf-8") as f:
        json.dump(devices, f, indent=2)

def get_device(devices, device_id):
    """Retourne le device correspondant à l'ID ou None si inexistant."""
    return next((d for d in devices if d["id"] == device_id), None)
