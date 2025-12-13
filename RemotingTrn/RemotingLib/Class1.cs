using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static RemotingTrn.Class1;

namespace RemotingLib
{
    public class Class1
    {
        // wrie a logic ..
        public class ServiceClass : MarshalByRefObject, IMyinter
        {
            // marshalbyref : represents the class can be called from
            // remote system

            public string Show(string name)
            {
                Console.WriteLine($"Message Recevied from the cline is {name}");
                return $"Hello {name} How Are You!!";
            }
        }

    }
}
