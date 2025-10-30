class Synthesizer:
    def compute(self, aggregated):
        mean = aggregated["mean"]
        # Exemple: confort thermique simple
        comfort = "ok" if 20 <= mean <= 26 else "alert"
        return {"mean": mean, "min": aggregated["min"], "max": aggregated["max"], "comfort": comfort}
