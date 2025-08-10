using System.Net;
using System.Threading.Channels;

namespace DEPI

{

    internal class Program
    {
        public class BankAccount
        {
            const string BankCode = "BNK001";
            public readonly DateTime CreatedDate;
            private int _accountNumber;
            private long _nationalID;
            private string _fullName;
            private string _phoneNumber;
            private string _address;
            private double _balance;


            public int AccountNumber { get; set; }
            public string Address { get; set; }
            public string FullName
            {
                get
                {
                    return _fullName;
                }

                set
                {
                    if (!string.IsNullOrEmpty(value))
                    {
                        _fullName = value;
                    }

                    else
                    {
                        Console.WriteLine("Invalid Name");
                    }
                }
            }

            public long NationalID
            {
                get
                {
                    return _nationalID;
                }

                set
                {
                    if (IsValidNationalID(value))
                    {
                        _nationalID = value;
                    }
                    else
                    {
                        Console.WriteLine("Invalid National ID");
                    }
                }
            }

            public string PhoneNumber
            {
                get
                {
                    return _phoneNumber;
                }

                set
                {
                    if (IsValidPhoneNumber(value))
                    {
                        _phoneNumber = value;
                    }
                    else
                    {
                        Console.WriteLine("Invalid Phone Number");
                    }
                }
            }

            public double Balance
            {
                get
                {
                    return _balance;
                }

                set
                {
                    if (_balance >= 0)
                    {
                        _balance = value;
                    }
                    else
                    {
                        Console.WriteLine("Invalid Balance");
                    }
                }
            }





            public BankAccount()
            {
                CreatedDate = DateTime.Now;
                AccountNumber = 1;
                NationalID = 12345678912533;
                FullName = "Ali Samy";
                PhoneNumber = "01021956323";
                Address = "Sadat city, Menofia";
                Balance = 0;
            }

            public BankAccount(int AccountNumber, long NationlID, string FullName, string PhoneNumber, string Address)
            {
                this.AccountNumber = AccountNumber;
                this.NationalID = NationlID;
                this.FullName = FullName;
                this.PhoneNumber = PhoneNumber;
                this.Address = Address;
            }

            // Chain Constructor
            public BankAccount(int AccountNumber, long NationlID, string FullName, string PhoneNumber, string Address, double Balance) : this(AccountNumber, NationlID, FullName, PhoneNumber, Address)
            {
                this.Balance = Balance;
            }


            public virtual void ShowAccountDetails()
            {
                Console.WriteLine("=============== Account Details ==============");
                Console.WriteLine($"Created At : {CreatedDate}");
                Console.WriteLine($"Account Number : {AccountNumber}");
                Console.WriteLine($"Full Name : {FullName}");
                Console.WriteLine($"National ID : {NationalID}");
                Console.WriteLine($"Phone Number : {PhoneNumber}");
                Console.WriteLine($"Address : {Address}");
                Console.WriteLine($"Balance : {Balance}");
                Console.WriteLine("==============================================");
            }


            bool IsValidNationalID(long NID)
            {
                if (Convert.ToString(NID).Length == 14)
                    return true;
                else
                    return false;
            }

            bool IsValidPhoneNumber(string PhoneNum)
            {
                if (PhoneNum.Length == 11 && IsStringNumber(PhoneNum))
                    return true;
                else
                    return false;
            }


            bool IsStringNumber(string PhoneNum)
            {
                foreach (char c in PhoneNum)
                {
                    if (c != '0' && c != '1' && c != '2' && c != '3' && c != '4' && c != '5' && c != '6' && c != '7' && c != '8' && c != '9')
                    {
                        return false;
                    }
                }

                return true;
            }


            public virtual decimal CalculateInterest()
            {
                return 0;
            }




        }

        public class SavingAccount : BankAccount
        {
            private decimal _InterestRate;

            public decimal InterestRate 
            {
                get { return _InterestRate; }
                set { _InterestRate = value; }
            }

            public SavingAccount(int AccountNumber, long NationlID, string FullName, string PhoneNumber, string Address, double Balance, decimal InterestRate) : base(AccountNumber, NationlID, FullName, PhoneNumber, Address,Balance)
            {
                this.InterestRate = InterestRate;
            }

            public override decimal CalculateInterest()
            {
                return (Convert.ToDecimal(this.Balance) * this.InterestRate) / 100 ;
            }


            public override void ShowAccountDetails()
            {
                Console.WriteLine("=============== Account Details ==============");
                Console.WriteLine($"Created At : {CreatedDate}");
                Console.WriteLine($"Account Number : {AccountNumber}");
                Console.WriteLine($"Full Name : {FullName}");
                Console.WriteLine($"National ID : {NationalID}");
                Console.WriteLine($"Phone Number : {PhoneNumber}");
                Console.WriteLine($"Address : {Address}");
                Console.WriteLine($"Balance : {Balance}");
                Console.WriteLine($"Interest Rate : {InterestRate}");
                Console.WriteLine("==============================================");


            }

        }



        public class CurrentAccount : BankAccount
        {
            private decimal _OverdraftLimit;

            public decimal OverdraftLimit
            {
                get { return _OverdraftLimit; }
                set { _OverdraftLimit = value; }
            }

            public CurrentAccount(int AccountNumber, long NationlID, string FullName, string PhoneNumber, string Address, double Balance, decimal OverdraftLimit) : base(AccountNumber, NationlID, FullName, PhoneNumber, Address, Balance)
            {
                this.OverdraftLimit = OverdraftLimit;
            }

            public override decimal CalculateInterest()
            {
                return 0;
            }


            public override void ShowAccountDetails()
            {
                Console.WriteLine("=============== Account Details ==============");
                Console.WriteLine($"Created At : {CreatedDate}");
                Console.WriteLine($"Account Number : {AccountNumber}");
                Console.WriteLine($"Full Name : {FullName}");
                Console.WriteLine($"National ID : {NationalID}");
                Console.WriteLine($"Phone Number : {PhoneNumber}");
                Console.WriteLine($"Address : {Address}");
                Console.WriteLine($"Balance : {Balance}");
                Console.WriteLine($"Overdraft Limit : {OverdraftLimit}");
                Console.WriteLine("==============================================");


            }
        }


        static void Main(string[] args)
        {

            SavingAccount SA = new SavingAccount(1,12345678912346,"Ali Samy","01021343461","Maadi Cairo",5000,200);

            CurrentAccount CA = new CurrentAccount(2, 72745678912346, "Sara Samy", "01088343461", "Nasr-City Cairo", 9000, 100);


            List<BankAccount> bankAccounts = new List<BankAccount>();
            bankAccounts.Add(SA);
            bankAccounts.Add(CA);

            foreach(BankAccount bankAccount in bankAccounts)
            {
                bankAccount.ShowAccountDetails();
            }

        }

    }
}
