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
                    if(!string.IsNullOrEmpty(value))
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
                    if (_balance>=0)
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
            public BankAccount(int AccountNumber,long NationlID,string FullName, string PhoneNumber , string Address, double Balance):this(AccountNumber,NationlID,FullName,PhoneNumber,Address)
            {
                this.Balance = Balance;
            }


            public void ShowAccountDetails()
            {
                Console.WriteLine("=============== Account Details ===============");
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
                if(Convert.ToString(NID).Length == 14)
                    return true;
                else
                    return false;
            }

            bool IsValidPhoneNumber(string PhoneNum)
            {
                if( PhoneNum.Length == 11  && IsStringNumber(PhoneNum))
                    return true;
                else 
                    return false;  
            }


            bool IsStringNumber(string PhoneNum)
            {
                foreach(char c in PhoneNum)
                {
                    if(c!='0' && c!='1' && c!='2' && c!= '3' && c!= '4' && c!= '5' && c != '6' && c != '7' && c != '8' && c != '9')
                    {
                        return false;
                    }
                }

                return true;
            }





        }
        static void Main(string[] args)
        {
            BankAccount account1 = new BankAccount();

            BankAccount account2 = new BankAccount(2, 12345673335634L, "Omar Ahmed Samy", "01187755731", "Shebin , Menofia", 10000);

            account1.ShowAccountDetails();
            account2.ShowAccountDetails();

        }
    }
}
