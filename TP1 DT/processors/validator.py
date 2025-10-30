class Validator:
    def __init__(self, min_temp=-40, max_temp=60):
        self.min_temp = min_temp
        self.max_temp = max_temp

    def validate(self, data):
        # data = {"device_id": ..., "value": ...}
        val = data.get("value")
        if val is None:
            raise ValueError("Missing value")
        if not (self.min_temp <= val <= self.max_temp):
            raise ValueError(f"Value {val} out of range")
        return data
