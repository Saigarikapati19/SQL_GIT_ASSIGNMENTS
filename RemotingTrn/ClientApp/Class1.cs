using System;
using System.Runtime.Remoting.Channels;
using System.Runtime.Remoting.Channels.Tcp;
using static RemotingTrn.Class1;

namespace ClientApp
{
    public class Class1
    {
        static void Main(string[] args)
        {

            // an application who wants to consume the service

            TcpChannel channel = new TcpChannel();// i want to communicate using binary format
            ChannelServices.RegisterChannel(channel, false);// register the the path, no security

            // Connect to remote object
            IMyinter ob = (IMyinter)Activator.GetObject(
                typeof(IMyinter),
                "tcp://localhost:8085/Hi");

            Console.WriteLine("Connected to remote object...");
            Console.Write("Enter your name: ");
            string name = Console.ReadLine();

            string result = ob.Show(name);
            Console.WriteLine(result);


            Console.Read();



        }
    }
}
    

