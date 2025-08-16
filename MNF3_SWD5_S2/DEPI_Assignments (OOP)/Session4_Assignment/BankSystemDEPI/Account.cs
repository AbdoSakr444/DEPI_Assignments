using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace BankSystemDEPI
{
    internal class Account
    {
        private DateTime _createdDate;
        private int _accountNumber;
        private double _balance;

        public Account()
        {
           AccountNumber = 0;
            _createdDate = DateTime.Now;
            Balance = 0;
        }
        public DateTime CreatedDate
        {
            get { return _createdDate; }
        }
        public int AccountNumber 
        { 
            set { _accountNumber = value; }
            get { return _accountNumber; } 
        }
        public double Balance 
            { 
            get { return _balance; }
            set { _balance = value; }
            }
        public Customer customer { get; set; } = new Customer();
        public void Deposit()
        {
            Console.WriteLine("Enter The Deposit Amount : ");
            double DAmount = ReturnPositiveNumber();
            Balance += DAmount;
        }
        public void Withdraw()
        {
            Console.WriteLine("Enter The Withdraw Amount : ");
            double WAmount = ReturnPositiveNumber();
            if (WAmount > Balance)
            {
                Console.WriteLine("Invalid Amount");
            }
            else
            {
                Balance-=WAmount;
            }

        }
        public void Transfer(Account DestenationAccount)
        {
            Console.WriteLine("Enter Transfer Amount :");
            double TAmount = ReturnPositiveNumber();
            if (TAmount > Balance)
            {
                Console.WriteLine("Invalid Transfer");
            }
            else
            {
                DestenationAccount.Balance += TAmount;
                Balance-=TAmount;
            }
        }
        private double ReturnPositiveNumber()
        {
            double Amount;
            do
            {
               Amount = Convert.ToDouble(Console.ReadLine());

            } while (Amount <= 0);

            return Amount;
        }
        public void Display()
        {
            Console.WriteLine("========== Account Details ==========");
            Console.WriteLine($"Account Number : {AccountNumber}");
            Console.WriteLine($"Created Date : {CreatedDate}");
            Console.WriteLine($"Balance : {Balance}");
            Console.WriteLine($"Customer Name : {customer.FullName}");
            Console.WriteLine("=====================================");
        }
        public virtual void FillData(Customer Customer)
        {
            Console.WriteLine("Enter Balance : ");
            Balance = Convert.ToDouble(Console.ReadLine());

            this.customer = Customer;

        }

    }
}
