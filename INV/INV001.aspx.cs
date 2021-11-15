using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using System.Text;
using System.Configuration;
using NPOI.HSSF.UserModel;
using NPOI;
using NPOI.SS.UserModel;

public partial class INV_Default : System.Web.UI.Page
{
    string CNStr = "data source=192.168.0.188;initial catalog=GH;User id=reader;Password=";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            
        }
    }    
}