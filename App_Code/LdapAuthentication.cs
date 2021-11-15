using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

//***自己宣告（加入）*****************************
using System.Text;
using System.Collections;
using System.Web.Security;

using System.Security.Principal;
using System.DirectoryServices;    //需要先把DLL檔「加入參考」。
//***********************************************

namespace FormsAuth
{
    public class LdapAuthentication
    {
        private string _path;
        private string _filterAttribute;

        public LdapAuthentication(string path)
        {
            _path = path;
        }


        // 此程式碼使用 LDAP目錄提供者。驗證成功傳回 true。
        // Default_01_Login.aspx頁面中的程式碼會呼叫 .LdapAuthentication.IsAuthenticated()方法，並傳入從使用者收集的認證。
        // 接著，會使用目錄服務的路徑、使用者名稱與密碼建立 DirectoryEntry物件。
        // 使用者名稱的格式必須是 domain\username。
        public bool IsAuthenticated(string domain, string username, string pwd)
        {
            string domainAndUsername = domain + @"\" + username;
            DirectoryEntry entry = new DirectoryEntry(_path, domainAndUsername, pwd);

            try
            {   //Bind to the native AdsObject to force authentication.
                object obj = entry.NativeObject;
                //DirectoryEntry 物件接著會取得 NativeObject屬性，以嘗試強制 AdsObject 進行繫結。
                //若此動作成功，會取得使用者的 CN屬性，方式是建立 DirectorySearcher物件並篩選 sAMAccountName。

                DirectorySearcher search = new DirectorySearcher(entry);

                search.Filter = "(SAMAccountName=" + username + ")";
                search.PropertiesToLoad.Add("cn");
                SearchResult result = search.FindOne();

                if (null == result)   {
                    return false;
                }

                //Update the new path to the user in the directory.
                _path = result.Path;
                _filterAttribute = (string)result.Properties["cn"][0];
            }
            catch (Exception ex)   {
                throw new Exception("Error authenticating user. " + ex.Message);
            }
            return true;
        }

        //取得使用者所屬的安全性與通訊群組清單，方式是建立 DirectorySearcher物件並根據 memberOf屬性進行篩選。
        //此方法會傳回由管道 (|) 分隔的群組清單。
        //每個群組的格式看起來像這樣 CN=...,...,DC=domain,DC=com
        public string GetGroups()
        {
            DirectorySearcher search = new DirectorySearcher(_path);
            search.Filter = "(cn=" + _filterAttribute + ")";
            search.PropertiesToLoad.Add("memberOf");
            StringBuilder groupNames = new StringBuilder();

            try   {
                SearchResult result = search.FindOne();
                int propertyCount = result.Properties["memberOf"].Count;
                string dn;
                int equalsIndex, commaIndex;

                for (int propertyCounter = 0; propertyCounter < propertyCount; propertyCounter++)
                {
                    dn = (string)result.Properties["memberOf"][propertyCounter];
                    equalsIndex = dn.IndexOf("=", 1);
                    commaIndex = dn.IndexOf(",", 1);
                    if (-1 == equalsIndex)   {
                        return null;
                    }
                    groupNames.Append(dn.Substring((equalsIndex + 1), (commaIndex - equalsIndex) - 1));
                    groupNames.Append("|");   //傳回由管道 (|) 分隔的群組清單。
                }
            }
            catch (Exception ex)   {
                throw new Exception("Error obtaining group names. " + ex.Message);
            }
            return groupNames.ToString();
        }
    }
}



///// <summary>
///// LdapAuthentication 的摘要描述
///// </summary>
//public class LdapAuthentication
//{
//    public LdapAuthentication()
//    {
//        //
//        // TODO: 在這裡新增建構函式邏輯
//        //
//    }
//}