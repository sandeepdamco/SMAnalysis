using Microsoft.SqlServer.Management.Smo;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.SqlServer.Management.Common;
using System.Data.SqlClient;
using System.IO.Compression;
using System.IO;

namespace DBBackupUtility
{
    class Program
    {
        static string bakfilePath = @"D:\" + DateTime.Now.ToString("dd-MM-yyyy mm") + @"\SM.bak";
        static void Main(string[] args)
        {
            if (!Directory.Exists(Path.GetDirectoryName(bakfilePath)))
                Directory.CreateDirectory(Path.GetDirectoryName(bakfilePath));
            using (SqlConnection con = new SqlConnection("Data Source=WKS-337\\SQLEXPRESS;Initial Catalog=SM;User ID=sa;Password=damco"))
            {
                con.Open();
                ServerConnection serverConnection = new ServerConnection(con);
                {
                    Server myServer = new Server(serverConnection);
                    Backup bkpDBFull = new Backup();
                    /* Specify whether you want to back up database or files or log */
                    bkpDBFull.Action = BackupActionType.Database;
                    /* Specify the name of the database to back up */
                    bkpDBFull.Database = "SM";
                    /* You can take backup on several media type (disk or tape), here I am
                     * using File type and storing backup on the file system */
                    bkpDBFull.Devices.AddDevice(bakfilePath, DeviceType.File);
                    bkpDBFull.BackupSetName = "Adventureworks database Backup";
                    bkpDBFull.BackupSetDescription = "Adventureworks database - Full Backup";
                    /* You can specify the expiration date for your backup data
                     * after that date backup data would not be relevant */
                    bkpDBFull.ExpirationDate = DateTime.Today.AddDays(10);

                    /* You can specify Initialize = false (default) to create a new 
                     * backup set which will be appended as last backup set on the media. You
                     * can specify Initialize = true to make the backup as first set on the
                     * medium and to overwrite any other existing backup sets if the all the
                     * backup sets have expired and specified backup set name matches with
                     * the name on the medium */
                    bkpDBFull.Initialize = false;

                    /* Wiring up events for progress monitoring */
                    bkpDBFull.PercentComplete += CompletionStatusInPercent;
                    bkpDBFull.Complete += Backup_Completed;

                    /* SqlBackup method starts to take back up
                     * You can also use SqlBackupAsync method to perform the backup 
                     * operation asynchronously */
                    bkpDBFull.SqlBackup(myServer);
                }
            }
            Console.ReadLine();
        }

        private static void CompletionStatusInPercent(object sender, PercentCompleteEventArgs args)
        {
            Console.Clear();
            Console.WriteLine("Percent completed: {0}%.", args.Percent);
        }
        private static void Backup_Completed(object sender, ServerMessageEventArgs args)
        {
            Console.WriteLine("Hurray...Backup completed.");
            ZipFolder();
            Console.WriteLine(args.Error.Message);
        }

        private static void ZipFolder()
        {
            string zipPath = @"D:\SM\" + DateTime.Now.ToString("dd-MM-yyyy mm") + ".zip"; ;

            if (!Directory.Exists(Path.GetDirectoryName(zipPath)))
                Directory.CreateDirectory(Path.GetDirectoryName(zipPath));
            ZipFile.CreateFromDirectory(Path.GetDirectoryName(bakfilePath), zipPath, CompressionLevel.Fastest, true);

            Directory.Delete(Path.GetDirectoryName(bakfilePath), true);

            Console.WriteLine("Zip file Create Successfully!! ");
        }

        private static void Restore_Completed(object sender, ServerMessageEventArgs args)
        {
            Console.WriteLine("Hurray...Restore completed.");
            Console.WriteLine(args.Error.Message);
        }
    }
}
