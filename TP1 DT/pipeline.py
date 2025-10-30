class ProcessingPipeline:
    def __init__(self, steps):
        self.steps = steps  # ["validate", "clean", "aggregate", "synthesize"]

    def run(self, data):
        for step in self.steps:
            if step == "validate":
                data = self.validate(data)
            elif step == "clean":
                data = self.clean(data)
            elif step == "aggregate":
                data = self.aggregate(data)
            elif step == "synthesize":
                data = self.synthesize(data)
        return data

    def validate(self, data): return data
    def clean(self, data): return data
    def aggregate(self, data): return data
    def synthesize(self, data): return data
