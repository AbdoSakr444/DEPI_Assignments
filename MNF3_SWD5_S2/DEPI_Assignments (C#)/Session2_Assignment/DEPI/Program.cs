namespace DEPI
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello!");

            Console.WriteLine("Input the first Number : ");
            double Number1 = Convert.ToDouble(Console.ReadLine());

            Console.WriteLine("Input the second Number : ");
            double Number2 = Convert.ToDouble(Console.ReadLine());

            string OP = ReadTheOperation();

            double Result = Calculator(Number1, Number2, OP);

            PrintResult(Number1,Number2,Result,OP);

            Console.WriteLine("Press any Key to close!");
            Console.ReadKey();


        }

        static string ReadTheOperation()
        {
            string OP;
            Console.WriteLine("What do you want to do with those numbers ?");
            Console.WriteLine("[A]dd");
            Console.WriteLine("[S]ubtract");
            Console.WriteLine("[M]ultiply");
            OP = Console.ReadLine();

            while (OP.ToLower() != "a" && OP.ToLower() != "s" && OP.ToLower() != "m")
            {
                Console.WriteLine("Invalid Operation");
                OP = Console.ReadLine();
            }

            return OP.ToLower();
        }

        static double Calculator(double Num1,double Num2,string OP)
        {
            double Result = 0;

            if (OP == "a")
            {
                Result =  Num1 + Num2;
            }

            else if (OP == "s")
            {
                Result =  Num1 - Num2;
            }

            else if (OP == "m")
            {
                Result =  Num1 * Num2;
            }

            return Result;
        }


        static void PrintResult(double Number1,double Number2,double Result,string OP)
        {
            if(OP == "a")
            {
                Console.WriteLine($"{Number1} + {Number2} = {Result}");
            }

            else if (OP == "s")
            {
                Console.WriteLine($"{Number1} - {Number2} = {Result}");
            }
            
            else
            {
                Console.WriteLine($"{Number1} * {Number2} = {Result}");
            }
        }
    }
}
