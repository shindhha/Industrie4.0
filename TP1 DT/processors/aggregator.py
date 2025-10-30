import numpy as np
from collections import deque

class Aggregator:
    def __init__(self, window_size=10):
        self.window = deque(maxlen=window_size)

    def aggregate(self, data):
        val = data["value"]
        self.window.append(val)
        return {
            "mean": np.mean(self.window),
            "min": np.min(self.window),
            "max": np.max(self.window)
        }
