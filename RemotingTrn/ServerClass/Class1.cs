using System;
using System.Runtime.Remoting;
using System.Runtime.Remoting.Channels;
using System.Runtime.Remoting.Channels.Tcp;
using static RemotingLib.Class1;


namespace ServerClass
{
    public class Class1
    {
        // make the class library public (host the library file)

        public static void Main()
        {
            TcpChannel channel = new TcpChannel(8085);
            ChannelServices.RegisterChannel(channel, false);

            // which object (service) clinent can access remotly

            RemotingConfiguration.RegisterWellKnownServiceType(
      typeof(ServiceClass),   // your library class
      "Hi",                   // unique object name
      WellKnownObjectMode.Singleton);



            Console.WriteLine("Server started... Listening on port 8085");
            Console.WriteLine("Press ENTER to stop the server.");
            Console.Read();

        }
    }
}
    

