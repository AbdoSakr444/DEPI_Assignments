using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BankSystemDEPI
{
    internal class Customer
    {
        private static int _ID = 0;
        private string _FullName;
        private string _NationalID;
        private DateOnly _DOB;


        public Customer()
        {
            Generate_ID();
            FullName = "Abdelrahman Amr Sakr";
            NationalID = "12345678";
            DOB = new DateOnly(2004,1,21);
        }
        public int ID { get { return _ID; } }
        public string FullName
        {
            get { return _FullName; }
            set { _FullName = value; }
        }
        public string NationalID
        {
            get { return _NationalID; }
            set { _NationalID = value; }
        }
        public DateOnly DOB
        {
            get { return _DOB; }
            set { _DOB = value; }
        }
        public Bank BankBranch { get; set; } = new Bank();
        public List<Account> accounts { get; set; } = new List<Account>();
        private void Generate_ID()
        {
            _ID++;
        }
        public void Update()
        {
            // updating Full Name
            Console.WriteLine("Enter The New Full Name : ");
            string fullName = Console.ReadLine();
            FullName = fullName;

            // updating NationalID
            Console.WriteLine("Enter The New NationalID : ");
            string NID = Console.ReadLine();
            FullName = NID;

            // updating DOB
            Console.WriteLine("Enter The New DOB : ");
            DateOnly Dob = DateOnly.Parse(Console.ReadLine());
            DOB = Dob;
        }
        public void FillData(Bank bank)
        {
            Console.WriteLine("Enter Full Name : ");
            FullName = Console.ReadLine();

            Console.WriteLine("Enter National ID : ");
            NationalID = Console.ReadLine();

            Console.WriteLine("Enter DOB : ");
            DOB = DateOnly.Parse(Console.ReadLine());

            this.BankBranch = bank;
        }
        public void Display()
        {
            Console.WriteLine("========== Customer Details ==========");
            Console.WriteLine($"Full Name : {FullName}");
            Console.WriteLine($"DOB : {DOB}");
            Console.WriteLine($"National ID : {NationalID}");
            Console.WriteLine($"Branch Name : {BankBranch.Name}");
            Console.WriteLine($"Branch Code : {BankBranch.BranchCode}");
            Console.WriteLine("======================================");
        }
        public void AddAccount(Account account)
        {
            accounts.Add(account);
        }


    }
}
