from flask import Flask, jsonify, request
from flask_cors import CORS
from storage import load_devices, save_devices, get_device

app = Flask(__name__)
CORS(app)

# --- Charger les devices au démarrage ---
devices = load_devices()

# --- Endpoints CRUD existants ---
@app.route("/api/devices", methods=["GET", "POST"])
def devices_list():
    if request.method == "GET":
        return jsonify(devices)
    elif request.method == "POST":
        data = request.get_json()
        # Validation minimale
        if not data or "id" not in data or "name" not in data or "type" not in data or "location" not in data:
            return jsonify({"error": "Champs manquants"}), 400
        # Vérifie ID unique
        if get_device(devices, data["id"]):
            return jsonify({"error": "ID déjà existant"}), 400
        new_device = {
            "id": data["id"],
            "name": data["name"],
            "type": data["type"],
            "location": data["location"]
        }
        # Si c’est un actuator on initialise state
        if data["type"] == "actuator":
            new_device["state"] = "off"
        # Si c’est un sensor on initialise value
        if data["type"] == "sensor":
            new_device["value"] = 0
        devices.append(new_device)
        save_devices(devices)
        return jsonify(new_device), 201

@app.route('/api/devices/<device_id>', methods=['GET'])
def get_device_by_id(device_id):
    device = get_device(devices, device_id)
    if device:
        return jsonify(device)
    return jsonify({"error": "Device not found"}), 404

@app.route('/api/devices/<device_id>/read', methods=['GET'])
def read_device_value(device_id):
    device = get_device(devices, device_id)
    if device:
        if device["type"] == "sensor":
            return jsonify({"value": device.get("value", None)})
        elif device["type"] == "actuator":
            return jsonify({"value": device.get("state", None)})
    return jsonify({"error": "Device not found"}), 404

@app.route('/api/devices/<device_id>/write', methods=['POST'])
def write_device(device_id):
    device = get_device(devices, device_id)
    if not device:
        return jsonify({"error": "Device not found"}), 404
    data = request.json
    if device["type"] == "actuator" and "state" in data:
        device["state"] = data["state"]
    save_devices(devices)
    return jsonify({"success": True})

# --- NOUVEAUX Endpoints CRUD ---

def create_device():
    data = request.json
    # Vérification des champs obligatoires
    required_fields = ["id", "name", "type", "location"]
    missing = [f for f in required_fields if f not in data or not data[f].strip()]
    if missing:
        return jsonify({"error": f"Missing or empty fields: {', '.join(missing)}"}), 400
    if data["type"] not in ["sensor", "actuator"]:
        return jsonify({"error": "Type must be 'sensor' or 'actuator'"}), 400
    if get_device(devices, data["id"]):
        return jsonify({"error": "Device ID already exists"}), 400

    new_device = {
        "id": data["id"],
        "name": data["name"],
        "type": data["type"],
        "location": data["location"]
    }
    if new_device["type"] == "sensor":
        new_device["value"] = 0
    else:
        new_device["state"] = "off"

    devices.append(new_device)
    save_devices(devices)
    return jsonify(new_device), 201

# --- Update device avec validation ---
@app.route('/api/devices/<device_id>', methods=['PUT'])
def update_device(device_id):
    device = get_device(devices, device_id)
    if not device:
        return jsonify({"error": "Device not found"}), 404
    data = request.json
    if "name" in data and not data["name"].strip():
        return jsonify({"error": "Name cannot be empty"}), 400
    if "type" in data and data["type"] not in ["sensor", "actuator"]:
        return jsonify({"error": "Type must be 'sensor' or 'actuator'"}), 400

    for key in ("name", "location"):
        if key in data:
            device[key] = data[key]
    if device["type"] == "sensor" and "value" in data:
        device["value"] = data["value"]
    elif device["type"] == "actuator" and "state" in data:
        device["state"] = data["state"]

    save_devices(devices)
    return jsonify(device)

# Delete device
@app.route('/api/devices/<device_id>', methods=['DELETE'])
def delete_device(device_id):
    global devices
    device = get_device(devices, device_id)
    if not device:
        return jsonify({"error": "Device not found"}), 404
    devices = [d for d in devices if d["id"] != device_id]
    save_devices(devices)
    return jsonify({"success": True})

if __name__ == '__main__':
    app.run(debug=True)
