using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BankSystemDEPI
{
    internal class CurrentAccount : Account
    {
        private double _OverDraftLimit;

        public CurrentAccount() : base()
        {
            OverDraftLimit = 0;
        }
        public double OverDraftLimit
        {
            get { return _OverDraftLimit; }
            set { _OverDraftLimit = value; }
        }

        public override void FillData(Customer Customer)
        {
            Console.WriteLine("Enter Balance : ");
            Balance = Convert.ToDouble(Console.ReadLine());

            Console.WriteLine("Enter Over Draft Limit: ");
            OverDraftLimit = Convert.ToDouble(Console.ReadLine());

            this.customer = Customer;
        }
    }
}
