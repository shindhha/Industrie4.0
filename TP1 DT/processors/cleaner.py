import numpy as np

class Cleaner:
    def __init__(self, z_threshold=3.0):
        self.values = []
        self.z_threshold = z_threshold

    def clean(self, data):
        val = data["value"]
        self.values.append(val)
        if len(self.values) < 2:
            return data
        mean = np.mean(self.values)
        std = np.std(self.values)
        z_score = abs((val - mean) / (std if std > 0 else 1))
        if z_score > self.z_threshold:
            # Outlier detected
            return None
        return data
