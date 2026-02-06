# Models

class Bet:
    def __init__(self, amount, odds):
        self.amount = amount
        self.odds = odds
        self.payout = self.calculate_payout()

    def calculate_payout(self):
        return self.amount * self.odds


class BettingModel:
    def __init__(self, model_name):
        self.model_name = model_name

    def predict(self, data):
        # Simulate a prediction
        return sum(data) / len(data)
