from flask import Flask, request, jsonify
from pipeline import ProcessingPipeline
import requests, json, os

class Node:
    def __init__(self, config):
        self.id = config['id']
        self.level = config['level']  # 1=Cloud, 2=Edge, 3=Device
        self.port = config['port']
        self.parents = config.get('parents', [])
        self.devices = {}  # {device_id: adapter}
        self.pipeline = ProcessingPipeline(config['processing'])
        self.local_queue = []

        self.app = Flask(self.id)
        self.setup_routes()

    def setup_routes(self):
        @self.app.route("/api/data", methods=["POST"])
        def receive_data():
            data = request.get_json()
            processed = self.process_incoming(data)
            self.publish_data(processed)
            return jsonify({"status": "ok"})

    def process_incoming(self, data):
        """Pipeline: validation → cleaning → aggregation → synthesis"""
        return self.pipeline.run(data)

    def publish_data(self, data):
        """Forward vers parents avec fallback queue"""
        for parent in self.parents:
            try:
                # POST vers parent['url'] (ex: http://127.0.0.1:5000/api/data)
                pass
            except:
                self.local_queue.append(data)  # fallback

    def run(self):
        self.app.run(port=self.port)
    
    def publish_data(self, data):
        for parent in self.parents:
            try:
                url = f"http://{parent['host']}:{parent['port']}/api/data"
                r = requests.post(url, json=data, timeout=2)
                if r.status_code == 200:
                    return True
            except:
                continue

        # Si tous échouent
        self.local_queue.append(data)
        os.makedirs("queue", exist_ok=True)
        with open("queue/pending.json", "w") as f:
            json.dump(self.local_queue, f)
        return False