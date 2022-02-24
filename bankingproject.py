from random import randint


class Customer:

    # {account_number: xxxxx, name: "xxxxxx", deposits: xxxx}
    account = {}

    def __init__(self, name, deposit):
        self.account['account_number'] = randint(10000, 99999)
        self.account['name'] = name
        self.account['deposits'] = deposit

    def withdraw(self, amount):
        if self.account['deposits'] >= amount:
            self.account['deposits'] -= amount
            print()
            print("The sum of {} has been withdrawn from your account balance.".format(amount))
            self.balance()
        else:
            print()
            print("Not enough funds!")
            self.balance()

    def deposit(self, amount):
        self.account['deposits'] += amount
        print()
        print("The sum of {} has been added to your account balance.".format(amount))
        self.balance()

    def balance(self):
        print()
        print("Your current account balance is: {} ".format(self.account['deposits']))

class Bank:

    name = 'International Bank'
    Customers = []

    def update_db(self, Customer):
        self.Customers.append(Customer)

    def authentication(self, name, account_number):
        for i in range(len(self.Customers)):
            if name in self.Customers[i].account.values() and account_number in self.Customers[i].account.values():
                print(self.Customers[i])
                print("Authentication successful!")
            return self.Customers[i]

bank = Bank()
print()
print("Welcome to {}!".format(bank.name))
print()
running = True
while running:
    print()
    print("""Choose an option:
    
    1. Open new bank account
    2. Open existing bank account
    3. Exit
    """)

    choice = int(input("1, 2 or 3: "))

    if choice == 1:
        print()
        print("To create an account, please fill in the information below.")
        print()
        Customer = Customer(input("Name: "), int(input("Deposit amount: ")))
        bank.update_db(Customer)
        print()
        print("Account created successfully! Your account number is: ", Customer.account['account_number'])
    elif choice == 2:
        print()
        print("To access your account, please enter your credentials below.")
        print()
        name = input("Name: ")
        account_number = int(input("Account number: "))
        current_Customer = bank.authentication(name, account_number)
         if current_Customer:
            print()
            print("Welcome {}!".format(current_Customer.account['name']))
            acc_open = True
            while acc_open:
                print()
                print("""Choose an option:
                
    1. Withdraw
    2. Deposit
    3. Balance
    4. Exit
                    """)
                acc_choice = int(input("1, 2, 3 or 4: "))
                if acc_choice == 1:
                    print()
                    current_Customer.withdraw(int(input("Withdraw amount: ")))
                elif acc_choice == 2:
                    print()
                    current_Customer.deposit(int(input("Deposit amount: ")))
                elif acc_choice == 3:
                    print()
                    current_Customer.balance()
                elif acc_choice == 4:
                    print()
                    print("Thank you for visiting!")
                    current_Customer = ''
                    acc_open = False
        else:
            print()
            print("Authentication failed!")
            print("Reason: account not found.")
            continue
    elif choice == 3:
        print()
        print("Goodbye!")
        running = False
        

       
