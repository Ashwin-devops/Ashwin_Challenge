import re as r
#Please run this python code using python version - 3 or above
class ValidateCardService:

	def __init__(self):
		self.regx = r'^([456][0-9]{3})-?([0-9]{4})-?([0-9]{4})-?([0-9]{4})$'

	def is_card_valid(self, credit_card):
		res = r.match(self.regx, credit_card)
		if not res or not self.validate_seq(credit_card) or self.is_valid_hypens(credit_card):
			return False
		return True
		
	def is_valid_hypens(self, credit_card):
		if credit_card.count('-') != 0 or credit_card.count('-') != 3:
			return False
		return True
		
	def validate_seq(self, credit_card):
		credit_card = credit_card.replace("-", "")
		flag = True
		card_numbers = list(credit_card)
		
		for i in range(len(card_numbers)-3):
			if card_numbers[i+1] is card_numbers[i] and card_numbers[i+1] is card_numbers[i+2] and card_numbers[i+2] is card_numbers[i+3]:
				flag = False
				break
		return flag


if __name__ == '__main__':
    num = int(input())
    
    cards = []
    for index in range(num):
        cards.append(input())
    validateCardService = ValidateCardService()
    for card in cards:
        if validateCardService.is_card_valid(card):
            print('Valid')
        else:
            print('Invalid')
