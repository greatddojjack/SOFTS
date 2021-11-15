using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using ICSharpCode.SharpZipLib.Zip;

namespace ZipTool
{
    public class ZipTool
    {
        /// 

        /// 壓縮整個資料夾
        /// 

        private static void ZipDir(string SourceDir, string TargetFile, string Password, bool BackupOldFile)
        {
            FastZip oZipDir = new FastZip();
            try
            {
                if (!Directory.Exists(SourceDir))
                {
                    throw new Exception("資料夾不存在!");
                }

                if (BackupOldFile == true)
                {
                    //判斷要產生的ZIP檔案是否存在
                    if (File.Exists(TargetFile) == true)
                    {
                        //原本的檔案存在，把他ReName
                        File.Copy(TargetFile, TargetFile + "-" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".back");
                        File.Delete(TargetFile);
                    }
                }

                if (string.IsNullOrEmpty(Password))
                    oZipDir.Password = Password;

                oZipDir.CreateZip(TargetFile, SourceDir, true, "");
            }
            catch
            {
                throw;
            }
        }

        /// 

        /// 壓縮整個資料夾
        /// 

        public static void ZipDir(string SourceDir, string TargetFile, string Password)
        {
            ZipDir(SourceDir, TargetFile, Password, true);
        }

        /// 

        /// 壓縮整個資料夾
        /// 

        public static void ZipDir(string SourceDir, string TargetFile)
        {
            ZipDir(SourceDir, TargetFile, "", true);
        }

        /// 

        /// 壓縮檔案
        /// 

        private static void ZipFiles(string[] SourceFiles, string TargetFile, string Password, bool BackupOldFile)
        {
            try
            {
                if (SourceFiles == null || SourceFiles.Length <= 0)
                {
                    throw new Exception("並未傳入檔案完整路徑");
                }

                for (int i = 0; i < SourceFiles.Length; i++)
                {
                    if (File.Exists(SourceFiles[i]) == false)
                    {
                        throw new Exception("要壓縮的檔案【" + SourceFiles[i] + "】不存在");
                    }
                }

                if (BackupOldFile == true)
                {
                    //判斷要產生的ZIP檔案是否存在
                    if (File.Exists(TargetFile) == true)
                    {
                        //原本的檔案存在，把他ReName
                        File.Copy(TargetFile, TargetFile + "-" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".back");
                        File.Delete(TargetFile);
                    }
                }

                ZipOutputStream zs = new ZipOutputStream(File.Create(TargetFile));
                zs.SetLevel(9); //壓縮比
                if (Password != "")
                {
                    zs.Password = Password;
                }

                for (int i = 0; i < SourceFiles.Length; i++)
                {
                    FileStream s = File.OpenRead(SourceFiles[i]);
                    byte[] buffer = new byte[s.Length];
                    s.Read(buffer, 0, buffer.Length);
                    ZipEntry Entry = new ZipEntry(Path.GetFileName(SourceFiles[i]));
                    Entry.DateTime = DateTime.Now;
                    Entry.Size = s.Length;
                    s.Close();
                    zs.PutNextEntry(Entry);
                    zs.Write(buffer, 0, buffer.Length);
                }
                zs.Finish();
                zs.Close();
            }
            catch
            {
                throw;
            }
        }

        /// 

        /// 壓縮檔案
        /// 

        public static void ZipFiles(string[] SourceFiles, string TargetFile, string Password)
        {
            ZipFiles(SourceFiles, TargetFile, Password, true);
        }

        /// 

        /// 壓縮檔案
        /// 

        public static void ZipFiles(string[] SourceFiles, string TargetFile)
        {
            ZipFiles(SourceFiles, TargetFile, "", true);
        }

        /// 

        /// 壓縮單一檔案
        /// 

        public static void ZipFile(string SourceFile, string TargetFile, string Password, bool BackupOldFile)
        {
            ZipFiles(new string[] { SourceFile }, TargetFile, Password, BackupOldFile);
        }

        /// 

        /// 壓縮單一檔案
        /// 

        public static void ZipFile(string SourceFile, string TargetFile, string Password)
        {
            ZipFile(SourceFile, TargetFile, Password, true);
        }

        /// 

        /// 壓縮單一檔案
        /// 

        /// 
        public static void ZipFile(string SourceFile, string TargetFile)
        {
            ZipFile(SourceFile, TargetFile, "", true);
        }

        /// 

        /// 解壓縮
        /// 

        private static void ExtractZip(string SourceFile, string TargetDir, string Password)
        {
            FastZip oZip = new FastZip();
            try
            {
                //判斷ZIP檔案是否存在
                if (File.Exists(SourceFile) == false)
                {
                    throw new Exception("要解壓縮的檔案【" + SourceFile + "】不存在，無法執行");
                }
                if (Password != "")
                {
                    oZip.Password = Password;
                }
                oZip.ExtractZip(SourceFile, TargetDir, "");
            }
            catch
            {
                throw;
            }
        }

        /// 

        /// 解壓縮
        /// 

        public static void ExtractZip(string SourceFile, string TargetDir)
        {
            ExtractZip(SourceFile, TargetDir, "");
        }
    }
}