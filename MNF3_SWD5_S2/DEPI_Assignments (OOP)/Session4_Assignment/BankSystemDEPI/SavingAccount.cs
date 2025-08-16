using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BankSystemDEPI
{
    internal class SavingAccount : Account
    {
        private double _InterestRate;

        public SavingAccount():base()
        {
            InterestRate = 1.0;
        }
        public double InterestRate
        {
            get { return _InterestRate; } set { _InterestRate = value; }
        }

        public double CalculateInterestRate()
        {
            return (Balance * InterestRate) / 100;
        }

        public override void FillData(Customer Customer)
        {
            Console.WriteLine("Enter Balance : ");
            Balance = Convert.ToDouble(Console.ReadLine());

            Console.WriteLine("Enter Interest Rate : ");
            InterestRate = Convert.ToDouble(Console.ReadLine());

            this.customer = Customer;
        }
    }
}
