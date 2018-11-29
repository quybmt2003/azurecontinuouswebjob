using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;

namespace WebjobContinuous
{
    // To learn more about Microsoft Azure WebJobs SDK, please see https://go.microsoft.com/fwlink/?LinkID=320976
    class Program
    {
        // Please set the following connection strings in app.config for this WebJob to run:
        // AzureWebJobsDashboard and AzureWebJobsStorage
        static void Main()
        {
            var config = new JobHostConfiguration();

            if (config.IsDevelopment)
            {
                config.UseDevelopmentSettings();
            }

            var host = new JobHost(config);

            var cancellationToken = new WebJobsShutdownWatcher().Token;
            cancellationToken.Register(async () =>
            {
                try
                {
                    Console.WriteLine("-----" + "Shutdown started");
                    for (int i = 0; i < 30; i++)
                    {
                        Console.WriteLine(i);
                        await Task.Delay(1000);
                    }
                    Console.WriteLine("------" + "Shutdown complete");
                    host.Stop();
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                    Console.WriteLine(ex.StackTrace);
                }
            });

            // The following code ensures that the WebJob will be running continuously
            host.RunAndBlock();
        }
    }
}
