using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BankSystemDEPI
{
    internal class Bank
    {
        private string _Name;
        private string _BranchCode;
        public List<Customer> customers { get; set; } = new List<Customer>();

        public Bank()
        {
            Name = "QNB";
            BranchCode = "QNB1#";
        }
        public Bank(string name, string branchCode)
        {
            Name = name;
            BranchCode = branchCode;
        }
        public string Name
        {
            get
            {
                return _Name;
            }

            set
            {
                if (!string.IsNullOrEmpty(value))
                {
                    _Name = value;
                }

                else
                {
                    Console.WriteLine("Invalid Bank Name");
                }

            }
        }
        public string BranchCode
        {

            get
            {
                return _BranchCode;
            }

            set
            {
                if (!string.IsNullOrEmpty(value))
                {
                    _BranchCode = value;
                }

                else
                {
                    Console.WriteLine("Invalid Branch Code");
                }

            }
        }
        public void Display()
        {
            Console.WriteLine("========== Bank Details ==========");
            Console.WriteLine($"Name : {Name}");
            Console.WriteLine($"Branch Code : {BranchCode}");
            Console.WriteLine("==================================");
        }
        public void AddCustomers(Customer customer)
        {
            customers.Add(customer);
        }
        public void RemoveCustomers(Customer customer)
        {
            customers.Remove(customer);
        }
        public Customer SearchCustomer(string Nid)
        {
            foreach (Customer customer in customers)
            {
                if (customer.NationalID == Nid)
                    return customer;
            }

            return null;

        }
        private static void PrintCustomerTableHeader()
        {
            Console.WriteLine("------------------------------------------------------------------------------------");
            Console.WriteLine($"| {"Full Name",-20} | {"National ID",-15} | {"DOB",-12} | {"Branch",-15} | {"Code",-6} |");
            Console.WriteLine("------------------------------------------------------------------------------------");
        }
        private static void PrintCustomerRecord(Customer customer)
        {
            Console.WriteLine($"| {customer.FullName,-20} | {customer.NationalID,-15} | {customer.DOB,-12} | {customer.BankBranch.Name,-15} | {customer.BankBranch.BranchCode,-6} |");
        }
        public void ShowCustomers()
        {
            PrintCustomerTableHeader();
            foreach (Customer customer in customers)
            {
                PrintCustomerRecord(customer);
                Console.WriteLine();
            }
            Console.WriteLine("------------------------------------------------------------------------------------");
        }


    }
}
