import random

class SimulatedAdapter:
    def __init__(self, config):
        self.noise = config.get("noise", 0.1)
        self.value = 22.0  # valeur initiale du capteur simulé

    def read(self):
        # Génère une valeur avec un petit bruit
        self.value += random.uniform(-self.noise, self.noise)
        return self.value

    def write(self, value):
        # Simule l'action d'un actionneur
        self.value = value
        print(f"[SimulatedAdapter] write value: {value}")
