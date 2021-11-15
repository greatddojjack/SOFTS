using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using FormsAuth;      //自己寫的類別，NameSpace名稱。
using System.Web.Security;    // FormsAuthenticationTicket與 FormsAuthentication會用到這個命名空間。


public partial class Login : System.Web.UI.Page 
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string txtDomain = "192.168.0.5";
        string adPath = "LDAP://" + txtDomain;
        //Windows Server 2008（含）後續新版的AD才能用。

        LdapAuthentication adAuth = new LdapAuthentication(adPath);
        //自己寫的類別檔。

        try
        {
            if (true == adAuth.IsAuthenticated(txtDomain, txtUsername.Text, txtPassword.Text))
            {    //自己寫的類別檔裡面的「方法」。
                string groups = adAuth.GetGroups();


                //Create the ticket, and add the groups.登入成功後，是否用Cookie記錄？
                bool isCookiePersistent = chkPersist.Checked;
                FormsAuthenticationTicket authTicket = new FormsAuthenticationTicket(1,
                          txtUsername.Text, DateTime.Now, DateTime.Now.AddMinutes(60), isCookiePersistent, groups);

                //Encrypt the ticket.
                string encryptedTicket = FormsAuthentication.Encrypt(authTicket);

                //Create a cookie, and then add the encrypted ticket to the cookie as data.
                HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket);

                if (true == isCookiePersistent)
                    authCookie.Expires = authTicket.Expiration;

                //Add the cookie to the outgoing cookies collection.
                Response.Cookies.Add(authCookie);

                //You can redirect now. 通過身份驗證的人，才能看見原本的網頁Default_00.aspx。
                //通過驗證後，自動回到（導向）原本想看的網頁。
                Response.Redirect(FormsAuthentication.GetRedirectUrl(txtUsername.Text, false));
            }
            else
            {
                errorLabel.Text = "登入失敗，請檢查帳號密碼。";
            }
        }
        catch (Exception ex)
        {
            errorLabel.Text = ex.Message;
        }
    }

}
