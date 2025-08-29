using System;
using System.Collections;
using System.Collections.Concurrent;
using System.Numerics;
using System.Runtime.CompilerServices;


namespace DEPI
{
    public static class Extensions
    {
        public static double Clac(this double value1, double value2,Func<double,double,double> Op)
        {
            double result = Op(value1,value2);
            return result;
        }
    }
    internal class Program
    {  
        public static double Add(double n1,double n2)
        {
            return n1+n2;
        }

        public static double Subtract(double n1, double n2)
        {
            return n1 - n2;
        }

        public static double Multiply(double n1, double n2)
        {
            return n1 * n2;
        }

        public static double Divide(double n1, double n2)
        {
            if(n2 == 0)
            {
                return n1;
            }
            return n1 / n2;
        }
        public static void Main(string[] args)
        {
            double n1;
            Console.WriteLine("Enter a Number : ");
            n1 = double.Parse(Console.ReadLine());

            Console.WriteLine($"Addding 4 to {n1} : ");
            Console.WriteLine(n1.Clac(4, Add));

            Console.WriteLine($"Subtracting 4 from {n1} : ");
            Console.WriteLine(n1.Clac(4, Subtract));

            Console.WriteLine($"Multiplying 4 by {n1} : ");
            Console.WriteLine(n1.Clac(4, Multiply));

            Console.WriteLine($"Divide 4 by {n1} : ");
            Console.WriteLine(n1.Clac(4, Divide));
        }
       
    } 

}
