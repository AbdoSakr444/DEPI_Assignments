namespace BankSystemDEPI
{
    internal class Program
    {
        
        public static void ShowMenu(Bank bank)
        {

            Console.Clear();
            Console.WriteLine("===================================");
            Console.WriteLine("         Banking System Menu       ");
            Console.WriteLine("===================================");
            Console.WriteLine("1) Show Customers");
            Console.WriteLine("2) Add Customer");
            Console.WriteLine("3) Delete Customer");
            Console.WriteLine("4) Search Customer");
            Console.WriteLine("5) Exit");
            Console.WriteLine("===================================");
            Console.Write("Enter your choice: ");
            int choice = Convert.ToInt32(Console.ReadLine());
            PerformMainMenu(choice,bank);
        }
        public static void BackToMainMenue(Bank bank)
        {
            Console.WriteLine("Press Any Key to go Back to main menue");
            Console.ReadKey();
            ShowMenu(bank);
        }

        
        public static void PerformMainMenu(int choice,Bank bank)
        {

            if (choice == 1)
            {
                Console.Clear();
                bank.ShowCustomers();
                BackToMainMenue(bank);

            }

            else if (choice == 2)
            {
                Console.Clear();
                Customer customer = new Customer();
                customer.FillData(bank);
                bank.AddCustomers(customer);
                Account account = new Account();
                Console.WriteLine("===== Adding Account Details =====");
                account.FillData(customer);
                customer.AddAccount(account);
                BackToMainMenue(bank);
            }

            else if (choice == 3)
            {
                Console.Clear();
                Console.WriteLine("Enter National ID of Customer to remove");
                string NID = Console.ReadLine(); 
                Customer customer = bank.SearchCustomer(NID);
                if(customer == null)
                {
                    Console.WriteLine("This Customer is not exist");
                }
                else 
                {
                  bank.RemoveCustomers(customer);
                  Console.WriteLine("Removed Successfully");
                }
                BackToMainMenue(bank);
            }

            else if (choice == 4)
            {
                Console.Clear();
                Console.WriteLine("Enter National ID of Customer to Search");
                string NID = Console.ReadLine();
                Customer customer = bank.SearchCustomer(NID);
                if (customer == null)
                {
                    Console.WriteLine("This Customer is not exist");
                }
                else
                {
                    Console.WriteLine("Founded Successfully");
                    customer.Display();
                }
                BackToMainMenue(bank);
            }

            else if (choice == 5)
            {
                Console.Clear();
                Console.WriteLine("Prees Any key to Exit");
                Console.ReadKey();
            }
        }
        
        static void Main(string[] args)
        {

            Bank bank = new Bank();
            bank.Name = "QNB";
            bank.BranchCode = "QNB11#";
            ShowMenu(bank);

        }
    }
}
