<%@ WebService Language="C#" Class="WebService" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using System.Data;
using System.Data.SqlClient;
using System.Data.OleDb;
using Newtonsoft.Json;
using System.IO;
using System.IO.Compression;
using System.Web.Configuration;
using NPOI.HSSF.UserModel;
using NPOI.HPSF;
using NPOI.POIFS.FileSystem;
using NPOI.HSSF.Record;
using NPOI.HSSF.Util;
using NPOI.SS.Util;
using NPOI.SS.UserModel;
using AD=System.DirectoryServices;
using System.Security.Principal;
using System.Net;
using System.Text.RegularExpressions;
using HtmlAgilityPack;
using System.Text;
using System.Web.Mail;

/// <summary>
/// WebService 的摘要描述
/// </summary>
[WebService(Namespace = "http://tempuri.org/", Description = "For STOCK")]
// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下列一行。
[System.Web.Script.Services.ScriptService]
public class WebService : System.Web.Services.WebService
{
    public struct FileStruct
    {
        public string OriginalPath, FullPath;
    }
    public struct LoginInfo
    {
        public string user, msg;
        public bool status;
    }
    public struct Futures
    {
        public string name;
        public string buy_price;
        public string buy_volum;
        public string sell_price;
        public string sell_volum;
        public string deal_price;
        public string up_down;
        public string percent;
        public string deal_volum;
        public string open_price;
        public string high_price;
        public string low_price;
        public string ref_price;
        public string date_time;
    }
    string accessData = "/App_Data/stock.accdb";

    public WebService()
    {

        //如果使用設計的元件，請取消註解下列一行
        //InitializeComponent(); 
    }
    /// <summary>
    /// 參數設定資料
    /// </summary>
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetSetting()
    {
        try
        {
            //建立連接
            //string strConn = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
            //SqlConnection myConn = new SqlConnection(strConn); 
            string Database = Server.MapPath(accessData);
            string myConn = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Database);

            //打開連接
            //myConn.Open();
            String strSQL = "select * from setting";
            //建立SQL命令對象
            //DataTable dtSetting = GetOleDbDataTable(Server.MapPath("/App_Data/stock.mdb"), strSQL);
            DataTable dtSetting = SqlDb.GetOleDbTable(strSQL,CommandType.Text,null,myConn);
            //SqlCommand myCommand = new SqlCommand(strSQL, myConn);
            //myCommand.Parameters.Add("@ID", SqlDbType.VarChar).Value = DevEUI;
            //SqlDataAdapter adapter = new SqlDataAdapter(myCommand);
            //DataTable dtSetting = SqlDb.GetTable(strSQL, CommandType.Text, null);
            //myConn.Close();
            string json = JsonConvert.SerializeObject(dtSetting, Formatting.None);
            return json;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetTrade()
    {
        try
        {
            //建立連接
            //string strConn = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
            //SqlConnection myConn = new SqlConnection(strConn); 
            string Database = Server.MapPath(accessData);
            string myConn = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Database);

            //打開連接
            //myConn.Open();
            String strSQL = "select * from trade where volum-cover_volum>0 order by product,call_put desc,val(contract_value),year_month";
            //建立SQL命令對象
            //DataTable dtSetting = GetOleDbDataTable(Server.MapPath("/App_Data/stock.mdb"), strSQL);
            DataTable dtSetting = SqlDb.GetOleDbTable(strSQL,CommandType.Text,null,myConn);
            //SqlCommand myCommand = new SqlCommand(strSQL, myConn);
            //myCommand.Parameters.Add("@ID", SqlDbType.VarChar).Value = DevEUI;
            //SqlDataAdapter adapter = new SqlDataAdapter(myCommand);
            //DataTable dtSetting = SqlDb.GetTable(strSQL, CommandType.Text, null);
            //myConn.Close();
            string json = JsonConvert.SerializeObject(dtSetting, Formatting.None);
            return json;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetTrack()
    {
        try
        {
            //建立連接
            //string strConn = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
            //SqlConnection myConn = new SqlConnection(strConn); 
            string Database = Server.MapPath(accessData);
            string myConn = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Database);

            //打開連接
            //myConn.Open();
            String strSQL = "select * from track order by product,year_month,call_put,contract_value";
            //建立SQL命令對象
            //DataTable dtSetting = GetOleDbDataTable(Server.MapPath("/App_Data/stock.mdb"), strSQL);
            DataTable dtSetting = SqlDb.GetOleDbTable(strSQL,CommandType.Text,null,myConn);
            //SqlCommand myCommand = new SqlCommand(strSQL, myConn);
            //myCommand.Parameters.Add("@ID", SqlDbType.VarChar).Value = DevEUI;
            //SqlDataAdapter adapter = new SqlDataAdapter(myCommand);
            //DataTable dtSetting = SqlDb.GetTable(strSQL, CommandType.Text, null);
            //myConn.Close();
            string json = JsonConvert.SerializeObject(dtSetting, Formatting.None);
            return json;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateSetting(int refreshTime,int preMonthClosePrice,int preWeekClosePrice,string contractMonth,string contractMonthWeek,int upRange,int downRange,int stopMoney,int stopHurt,string email)
    {
        try
        {
            //建立連接
            //string strConn = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
            //SqlConnection myConn = new SqlConnection(strConn); 
            string Database = Server.MapPath(accessData);
            string myConn = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Database);

            //打開連接
            //myConn.Open();
            String strSQL = "update setting set refresh_time=@refreshTime,pre_month_close_price=@preMonthClosePrice,pre_week_close_price=@preWeekClosePrice,contract_month=@contractMonth,contract_month_week=@contractMonthWeek,up_range=@upRange,down_range=@downRange,stop_money=@stopMoney,stop_hurt=@stopHurt,email=@email";
            //建立SQL命令對象
            OleDbParameter[] para = new OleDbParameter[10];
            para[0]=new OleDbParameter("@refreshTime", refreshTime);
            para[1]=new OleDbParameter("@preMonthClosePrice", preMonthClosePrice);
            para[2]=new OleDbParameter("@preWeekClosePrice",  preWeekClosePrice);
            para[3]=new OleDbParameter("@contractMonth",  contractMonth);
            para[4]=new OleDbParameter("@contractMonthWeek",  contractMonthWeek);
            para[5]=new OleDbParameter("@upRange",  upRange);
            para[6]=new OleDbParameter("@downRange", downRange);
            para[7]=new OleDbParameter("@stopMoney",  stopMoney);
            para[8]=new OleDbParameter("@stopHurt",  stopHurt);
            para[9]=new OleDbParameter("@email",  email);

            int count = SqlDb.ExecuteOleDbNonQuery(strSQL, CommandType.Text, para, myConn);

            string json = "{\"result\":" + count.ToString() + " }";
            return json;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveTradeCondition(int trade_id, bool auto_cover, int volum, double looking_price)
    {
        try
        {
            //建立連接
            //string strConn = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
            //SqlConnection myConn = new SqlConnection(strConn); 
            string Database = Server.MapPath(accessData);
            string myConn = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Database);

            //打開連接
            //myConn.Open();
            String strSQL = "update trade set auto_cover=@auto_cover,volum=@volum,looking_price=@looking_price where trade_id=@trade_id";
            //建立SQL命令對象
            OleDbParameter[] para = new OleDbParameter[4];
            para[0] = new OleDbParameter("@auto_cover", auto_cover);
            para[1] = new OleDbParameter("@volum", volum);
            para[2] = new OleDbParameter("@looking_price", looking_price);
            para[3] = new OleDbParameter("@trade_id", trade_id);


            int count = SqlDb.ExecuteOleDbNonQuery(strSQL, CommandType.Text, para, myConn);

            string json = "{\"result\":" + count.ToString() + " }";
            return json;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveHighPrice(int trade_id, double high_price)
    {
        try
        {
            //建立連接
            //string strConn = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
            //SqlConnection myConn = new SqlConnection(strConn); 
            string Database = Server.MapPath(accessData);
            string myConn = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Database);

            //打開連接
            //myConn.Open();
            String strSQL = "update trade set high_price=@high_price where trade_id=@trade_id";
            //建立SQL命令對象
            OleDbParameter[] para = new OleDbParameter[2];
            para[0] = new OleDbParameter("@high_price", high_price);            
            para[1] = new OleDbParameter("@trade_id", trade_id);


            int count = SqlDb.ExecuteOleDbNonQuery(strSQL, CommandType.Text, para, myConn);

            string json = "{\"result\":" + count.ToString() + " }";
            return json;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveTrackCondition(int track_id, bool auto_trade, int volum, double price)
    {
        try
        {
            //建立連接
            //string strConn = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
            //SqlConnection myConn = new SqlConnection(strConn); 
            string Database = Server.MapPath(accessData);
            string myConn = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Database);

            //打開連接
            //myConn.Open();
            String strSQL = "update track set auto_trade=@auto_trade,volum=@volum,price=@price where track_id=@track_id";
            //建立SQL命令對象
            OleDbParameter[] para = new OleDbParameter[4];
            para[0] = new OleDbParameter("@auto_trade", auto_trade);
            para[1] = new OleDbParameter("@volum", volum);
            para[2] = new OleDbParameter("@price", price);
            para[3] = new OleDbParameter("@track_id", track_id);


            int count = SqlDb.ExecuteOleDbNonQuery(strSQL, CommandType.Text, para, myConn);

            string json = "{\"result\":" + count.ToString() + " }";
            return json;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SyncTrackAndTrade()
    {
        try
        {
            //建立連接
            //string strConn = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
            //SqlConnection myConn = new SqlConnection(strConn); 
            string Database = Server.MapPath(accessData);
            string myConn = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Database);

            //打開連接
            //myConn.Open();
            String strSQL = "UPDATE track AS tk LEFT JOIN trade AS td ON (td.contract_value=tk.contract_value) AND (td.call_put=tk.call_put) AND (td.year_month=tk.year_month) AND (td.product=tk.product) AND (td.buy_sell=tk.buy_sell) SET tk.trade_volum = iif(td.volum is null,0,td.volum)";
            //建立SQL命令對象         


            int count = SqlDb.ExecuteOleDbNonQuery(strSQL, CommandType.Text, null, myConn);

            string json = "{\"result\":" + count.ToString() + " }";
            return json;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string CheckTrade(string tradeString)
    {
        try
        {
            //建立連接
            //string strConn = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
            //SqlConnection myConn = new SqlConnection(strConn);
            string Database = Server.MapPath(accessData);
            string myConn = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Database);

            //打開連接
            //myConn.Open();
            //Buy_Call_TXO_201804_10850_1_36.00
            string[] splitTradeString = tradeString.Split('_');
            //String strSQL = "select * from trade where type='NEW' and buy_sell='BUY' and product='TXO' and call_put='CALL' and year_month='201804' and contrace_value='10850' and cover_volum>0";
            String strSQL = "select * from trade where trade_type='新倉' and buy_sell=@buy_sell and product=@product and call_put=@call_put and year_month=@year_month and aq_level=@aq_level and cover_volum>0";
            //建立SQL命令對象            
            OleDbParameter[] para = new OleDbParameter[5];
            para[0]=new OleDbParameter("@buy_sell", splitTradeString[1]);
            para[1]=new OleDbParameter("@product",  splitTradeString[3]);
            para[2]=new OleDbParameter("@call_put", splitTradeString[2]);
            para[3]=new OleDbParameter("@year_month", splitTradeString[4]);
            para[4] = new OleDbParameter("@aq_level", int.Parse(splitTradeString[0]));

            DataTable dtSetting = SqlDb.GetOleDbTable(strSQL, CommandType.Text, para,myConn);

            string json = JsonConvert.SerializeObject(dtSetting, Formatting.None);
            return json;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string TradeSaveDB(string tradeString)
    {
        try
        {
            //建立連接
            //string strConn = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
            //SqlConnection myConn = new SqlConnection(strConn);
            string Database = Server.MapPath(accessData);
            string myConn = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Database);

            //打開連接
            //myConn.Open();
            //Buy_Call_TXO_201804_10850_1_36.00
            string[] splitTradeString = tradeString.Split('_');
            //String strSQL = "insert into trade values ('2018/04/17','NEW','BUY','TXO','CALL','201804',10850,33,33,1,null,0,1)";
            String strSQL = "insert into trade values (@trade_date,'NEW',@buy_sell,@product,@call_put,@year_month,@contract_value,@expected_price,null,@volum,null,0,@aq_level)";
            //建立SQL命令對象
            OleDbParameter[] para = new OleDbParameter[9];
            para[0]=new OleDbParameter("@trade_date", DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss"));
            para[1]=new OleDbParameter("@buy_sell", splitTradeString[1]);
            para[2]=new OleDbParameter("@product",  splitTradeString[3]);
            para[3]=new OleDbParameter("@call_put",  splitTradeString[2]);
            para[4]=new OleDbParameter("@year_month", splitTradeString[4]);
            para[5]=new OleDbParameter("@contract_value",  Convert.ToInt32(splitTradeString[5]));
            para[6]=new OleDbParameter("@expected_price",  Convert.ToDouble(splitTradeString[7]));
            para[7]=new OleDbParameter("@volum",  Convert.ToInt32(splitTradeString[6]));
            para[8]=new OleDbParameter("@aq_level",  Convert.ToInt32(splitTradeString[0]));
            SqlDb.ExecuteOleDbNonQuery(strSQL, CommandType.Text, para,myConn);

            string json = "{\"result\":\"success\" }";
            return json;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "{\"result\":\"fail\" }";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetWebPage(string URL, string proxy)
    {
        try
        {
            WebProxy proxyObject;
            string proxyString;
            WebRequest MyRequest = WebRequest.Create(URL);

            proxyString = proxy;
            if ((proxyString != ""))
            {
                proxyObject = new WebProxy(proxyString, true);
                MyRequest.Proxy = proxyObject;
            }

            WebResponse MyWebResponse = MyRequest.GetResponse();
            Stream MyStream;
            MyStream = MyWebResponse.GetResponseStream();
            StreamReader StreamReader = new StreamReader(MyStream, System.Text.Encoding.UTF8);

            string GetWebPage = StreamReader.ReadToEnd();

            MyRequest = null;
            MyWebResponse = null;
            MyStream = null;
            StreamReader = null;
            proxyObject = null;
            return GetWebPage;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetTaiFexInfo()
    {
        try
        {
            WebClient client = new WebClient();
            client.Headers.Add ("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; .NET CLR 1.0.3705;)");
            MemoryStream ms = new MemoryStream(client.DownloadData("https://tw.screener.finance.yahoo.net/future/aa03?fumr=futurefull"));
            // 使用預設編碼讀入 HTML                             
            HtmlDocument doc = new HtmlDocument();
            doc.Load(ms, Encoding.UTF8);
            // 裝載第一層查詢結果 
            HtmlDocument docStockContext = new HtmlDocument();

            string HTML = doc.DocumentNode.SelectSingleNode(@"//*/table[2]/thead/tr").InnerHtml;
            docStockContext.LoadHtml(HTML);

            var nodes = doc.DocumentNode.SelectNodes(@"//*/table[2]/thead/tr");//取得欄位名稱
            var table = new DataTable("MyTable");

            var headers = nodes[0]
                .Elements("th")
                .Select(th => th.InnerText.Trim());
            foreach (var header in headers)
            {
                table.Columns.Add(header);
            }
            nodes = doc.DocumentNode.SelectNodes(@"//*/table[2]/tbody/tr[*]");//取得每列資料
            var rows = nodes.Skip(0).Select(tr => tr
                .Elements("td")
                .Select(td => td.InnerText.Trim())
                .ToArray());
            foreach (var row in rows)
            {
                table.Rows.Add(row);
            }

            doc = null;
            docStockContext = null;
            client = null;
            ms.Close();
            string json = JsonConvert.SerializeObject(table, Formatting.None);
            return json;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetTaiFexInfoFromTaifex()
    {
        try
        {
            WebClient client = new WebClient();
            client.Headers.Add ("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; .NET CLR 1.0.3705;)");
            MemoryStream ms = new MemoryStream(client.DownloadData("http://info512.taifex.com.tw/Future/FusaQuote_Norl.aspx"));
            // 使用預設編碼讀入 HTML                             
            HtmlDocument doc = new HtmlDocument();
            doc.Load(ms, Encoding.UTF8);
            // 裝載第一層查詢結果 
            HtmlDocument docStockContext = new HtmlDocument();

            string HTML = doc.DocumentNode.SelectSingleNode(@"//div[@id='divDG']/div[1]/table[1]/tr[1]").InnerHtml;
            docStockContext.LoadHtml(HTML);

            var nodes = doc.DocumentNode.SelectNodes(@"//div[@id='divDG']/div[1]/table[1]/tr[1]");//取得欄位名稱
            var table = new DataTable("MyTable");

            var headers = nodes[0]
                .Elements("td")
                .Select(th => th.InnerText.Trim());
            foreach (var header in headers)
            {
                table.Columns.Add(header);
            }
            nodes = doc.DocumentNode.SelectNodes(@"//div[@id='divDG']/div[1]/table[1]//tr[@class='custDataGridRow']");//取得每列資料
            var rows = nodes.Skip(0).Select(tr => tr
                .Elements("td")
                .Select(td => td.InnerText.Trim())
                .ToArray());
            foreach (var row in rows)
            {
                table.Rows.Add(row);
            }

            doc = null;
            docStockContext = null;
            client = null;
            ms.Close();
            string json = JsonConvert.SerializeObject(table, Formatting.None);
            return json;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetTaiOptInfoFromDDE(string contractMonth) //需開啟華南好神期與DDEtoJson
    {
        try
        {
            string json = "";
            DirectoryInfo di = new DirectoryInfo(Server.MapPath(string.Format("/App_Data/DDE")));//
            foreach (var fi in di.GetFiles())
            {
                if (fi.Extension == ".json" && fi.Name.IndexOf(contractMonth) >= 0)
                {
                    if (contractMonth.IndexOf("W") < 0 && fi.Name.IndexOf("W") >= 0)
                    {
                        continue;
                    }
                    using (StreamReader r = new StreamReader(fi.FullName))
                    {
                        json = r.ReadToEnd();
                    }
                    fi.Delete();
                }
            }
            return json;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetVixInfo()
    {
        try
        {
            WebClient client = new WebClient();
            client.Headers.Add ("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; .NET CLR 1.0.3705;)");
            MemoryStream ms = new MemoryStream(client.DownloadData("https://info512.taifex.com.tw/Future/VIXQuote_Norl.aspx"));
            // 使用預設編碼讀入 HTML                             
            HtmlDocument doc = new HtmlDocument();
            doc.Load(ms, Encoding.UTF8);
            // 裝載第一層查詢結果 
            HtmlDocument docStockContext = new HtmlDocument();

            string HTML = doc.DocumentNode.SelectSingleNode(@"//*[@id='ctl00_ContentPlaceHolder1_uc_DgVIXQuote1_dgData']/tr[1]").InnerHtml;
            docStockContext.LoadHtml(HTML);

            var nodes = doc.DocumentNode.SelectNodes(@"//*[@id='ctl00_ContentPlaceHolder1_uc_DgVIXQuote1_dgData']/tr[1]");//取得欄位名稱
            var table = new DataTable("MyTable");

            var headers = nodes[0]
                .Elements("td")
                .Select(th => th.InnerText.Trim());
            foreach (var header in headers)
            {
                table.Columns.Add(header);
            }
            nodes = doc.DocumentNode.SelectNodes(@"//*[@id='ctl00_ContentPlaceHolder1_uc_DgVIXQuote1_dgData']/tr[2]");//取得每列資料
            var rows = nodes.Skip(0).Select(tr => tr
                .Elements("td")
                .Select(td => td.InnerText.Trim())
                .ToArray());
            foreach (var row in rows)
            {
                table.Rows.Add(row);
            }

            doc = null;
            docStockContext = null;
            client = null;
            ms.Close();
            string json = JsonConvert.SerializeObject(table, Formatting.None);
            return json;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetWorldidxInfo()
    {
        try
        {
            WebClient client = new WebClient();
            client.Headers.Add ("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; .NET CLR 1.0.3705;)");
            MemoryStream ms = new MemoryStream(client.DownloadData("https://tw.stock.yahoo.com/us/worldidx.php"));
            // 使用預設編碼讀入 HTML                             
            HtmlDocument doc = new HtmlDocument();
            doc.Load(ms, Encoding.Default);


            var nodes = doc.DocumentNode.SelectNodes(@"//*/table[1]/tbody/tr/td/table/tbody/tr[2]");//取得欄位名稱
            var table = new DataTable("MyTable");

            var headers = nodes[0]
                .Elements("th")
                .Select(th => th.InnerText.Trim());
            foreach (var header in headers)
            {
                table.Columns.Add(header);
            }
            nodes = doc.DocumentNode.SelectNodes(@"//*/table[2]/tbody/tr[*]");//取得每列資料
            var rows = nodes.Skip(0).Select(tr => tr
                .Elements("td")
                .Select(td => td.InnerText.Trim())
                .ToArray());
            foreach (var row in rows)
            {
                table.Rows.Add(row);
            }

            doc = null;

            client = null;
            ms.Close();
            string json = JsonConvert.SerializeObject(table, Formatting.None);
            return json;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetTaiOptInfo(string contractMonth)
    {
        try
        {
            WebClient client = new WebClient();
            client.Headers.Add ("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; .NET CLR 1.0.3705;)");
            MemoryStream ms = new MemoryStream(client.DownloadData(string.Format("https://tw.screener.finance.yahoo.net/future/aa03?opmr=optionfull&opcm=WTXO&opym={0}", contractMonth)));
            // 使用預設編碼讀入 HTML                             
            HtmlDocument doc = new HtmlDocument();
            doc.Load(ms, Encoding.UTF8);
            // 裝載第一層查詢結果 
            HtmlDocument docStockContext = new HtmlDocument();

            string HTML = doc.DocumentNode.SelectSingleNode(@"//*[@id='ext-tbl-important']").InnerHtml;
            docStockContext.LoadHtml(HTML);

            var nodes = doc.DocumentNode.SelectNodes(@"//*[@id='ext-tbl-important']");//取得欄位名稱
            var titles = doc.DocumentNode.SelectNodes(@"//select[@id='itemselect']/option[@selected='']");//取得目前年月
            var title = titles[0].Attributes["value"].Value;
            var table = new DataTable(title.ToString());

            var headers = nodes[0]
                .Elements("td")
                .Select(th => th.InnerText.Trim());
            int i = 0;
            foreach (var header in headers)
            {
                if (i < 7)
                    table.Columns.Add("CALL" + header);
                else if (i > 7)
                    table.Columns.Add("PUT" + header);
                else
                    table.Columns.Add(header);
                i++;
            }
            nodes = doc.DocumentNode.SelectNodes(@"//*/table[2]/tbody/tr[*]");//取得每列資料
            var rows = nodes.Skip(1).Select(tr => tr
                .Elements("td")
                .Select(td => td.InnerText.Trim())
                .ToArray());
            foreach (var row in rows)
            {
                table.Rows.Add(row);
            }

            doc = null;
            docStockContext = null;
            client = null;
            ms.Close();
            DataSet ds = new DataSet();
            ds.Tables.Add(table);
            string json = JsonConvert.SerializeObject(ds, Formatting.None);
            return json;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetTaiOptContractMonth(string ContractMonth)
    {
        try
        {
            WebClient client = new WebClient();
            client.Headers.Add ("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; .NET CLR 1.0.3705;)");
            MemoryStream ms = new MemoryStream(client.DownloadData(string.Format("https://tw.screener.finance.yahoo.net/future/aa03?opmr=optionfull&opcm=WTXO&opym={0}",ContractMonth)));
            // 使用預設編碼讀入 HTML                             
            HtmlDocument doc = new HtmlDocument();
            doc.Load(ms, Encoding.UTF8);
            // 裝載第一層查詢結果 
            HtmlDocument docStockContext = new HtmlDocument();

            string HTML = doc.DocumentNode.SelectSingleNode(@"//*[@id='ext-tbl-important']").InnerHtml;
            docStockContext.LoadHtml(HTML);

            var nodes = doc.DocumentNode.SelectNodes(@"//select[@id='itemselect']/option");//取得所有年月
            var table = new DataTable("ContractMonth");

            table.Columns.Add("ContractMonth");
            foreach (var header in nodes)
            {
                table.Rows.Add(header.Attributes["value"].Value);
            }

            doc = null;
            docStockContext = null;
            client = null;
            ms.Close();
            DataSet ds = new DataSet();
            ds.Tables.Add(table);
            string json = JsonConvert.SerializeObject(ds, Formatting.None);
            return json;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetStockData(string stockID)
    {
        try
        {
            WebClient client = new WebClient();
            int timeStamp = Convert.ToInt32(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds);
            MemoryStream ms = new MemoryStream(client.DownloadData(string.Format("http://mis.twse.com.tw/stock/api/getStockInfo.jsp?ex_ch=tse_" + stockID + ".tw&json=1&delay=0&_=" + timeStamp+"001")));
            // 使用預設編碼讀入 HTML                             
            HtmlDocument doc = new HtmlDocument();
            doc.Load(ms, Encoding.UTF8);
            //string json = JsonConvert.SerializeObject(doc.DocumentNode.InnerText, Formatting.None);
            return doc.DocumentNode.InnerText;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveTaifexToDataBase(string tabledata)
    {
        try
        {
            //建立連接
            string strConn = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
            SqlConnection myConn = new SqlConnection(strConn);
            //打開連接
            myConn.Open();
            String strSQL = "select * from setting";
            //建立SQL命令對象
            SqlCommand myCommand = new SqlCommand(strSQL, myConn);
            //myCommand.Parameters.Add("@ID", SqlDbType.VarChar).Value = DevEUI;
            SqlDataAdapter adapter = new SqlDataAdapter(myCommand);
            DataSet dsSetting = SqlDb.GetDataSet(strSQL, CommandType.Text, null);
            dsSetting.AcceptChanges();
            string json = JsonConvert.SerializeObject(dsSetting, Formatting.None);
            return json;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void WriteTradeString(string str,string action,string tradeKey,int actionID)
    {
        try
        {
            string filename = DateTime.Now.Year.ToString().PadLeft(4, '0') + DateTime.Now.Month.ToString().PadLeft(2, '0') + DateTime.Now.Day.ToString().PadLeft(2, '0') + DateTime.Now.Hour.ToString().PadLeft(2, '0') + DateTime.Now.Minute.ToString().PadLeft(2, '0') + DateTime.Now.Second.ToString().PadLeft(2, '0')+DateTime.Now.Millisecond.ToString().PadLeft(2, '0');
            FileStream fs = new FileStream(Server.MapPath(string.Format("/App_Data/Trade/{0}.json", filename)), FileMode.CreateNew);
            using (StreamWriter sw = new StreamWriter(fs))
            {
                // 欲寫入的文字資料           
                sw.WriteLine(str);
                sw.Flush();
                sw.Close();
            }
            fs.Close();

            if (action == "APPEND")
            {
                //建立連接
                //string strConn = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
                //SqlConnection myConn = new SqlConnection(strConn); 
                string Database = Server.MapPath(accessData);
                string myConn = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + Database);

                //打開連接
                //myConn.Open();
                String strSQL = "update track set trade_key=trade_key&@trade_key&';' where track_id=@track_id";
                //建立SQL命令對象
                OleDbParameter[] para = new OleDbParameter[2];
                para[0] = new OleDbParameter("@trade_key", tradeKey);
                para[1] = new OleDbParameter("@track_id", actionID);

                int count = SqlDb.ExecuteOleDbNonQuery(strSQL, CommandType.Text, para, myConn);
            }
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
        }

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string StartAQTest(int uprange1, int uprange2, int uprangesize, int downrange1, int downrange2, int downrangesize, int stopmoneyrange1, int stopmoneyrange2, int stopmoneyrangesize, int stophurtrange1, int stophurtrange2, int stophurtrangesize, string daterange)
    {
        try
        {
            List<int> uprangelist = new List<int>();
            List<int> downrangelist = new List<int>();
            List<int> stopmoneyrangelist = new List<int>();
            List<int> stophurtrangelist = new List<int>();
            List<int> buypart = new List<int>();
            List<int> sellpart = new List<int>();
            for (int i = uprange1; i <= uprange2; i = i + uprangesize)
            {
                uprangelist.Add(i);
            }
            for (int i = downrange1; i <= downrange2; i = i + downrangesize)
            {
                downrangelist.Add(i);
            }
            for (int i = stopmoneyrange1; i <= stopmoneyrange2; i = i + stopmoneyrangesize)
            {
                stopmoneyrangelist.Add(i);
            }
            for (int i = stophurtrange1; i <= stophurtrange2; i = i + stophurtrangesize)
            {
                stophurtrangelist.Add(i);
            }
            string[] tmpdaterange = daterange.Split('-');
            //建立連接
            string strConn = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
            SqlConnection myConn = new SqlConnection(strConn);
            //打開連接
            myConn.Open();
            //取得結算價
            string strSQL = "SELECT * FROM taifex AS a RIGHT OUTER JOIN" +
            "(SELECT end_date, contract, Max(trade_date) AS trade_date FROM taifex WHERE (contract = 'TX') and LEN(end_date)=6 GROUP BY end_date, contract)" +
            string.Format("as b on a.end_date=b.end_date and a.contract=b.contract and a.trade_date=b.trade_date where trade_type='一般' and a.trade_date >='{0}' and a.trade_date<='{1}' order by a.end_date", tmpdaterange[0].Trim(), tmpdaterange[1].Trim());
            SqlCommand myCommand = new SqlCommand(strSQL, myConn);
            SqlDataAdapter adapter = new SqlDataAdapter(myCommand);
            DataTable dtClosePrice = SqlDb.GetTable(strSQL, CommandType.Text, null);
            //取得每日台指近指數
            strSQL = "SELECT * from taifex AS a RIGHT OUTER JOIN " +
            "(SELECT trade_date, contract, MIN(end_date) AS end_date FROM taifex WHERE (contract = 'TX') GROUP BY trade_date, contract) AS b ON a.trade_date = b.trade_date AND a.end_date = b.end_date AND a.contract = b.contract " +
            string.Format("where a.trade_date >='{0}' and a.trade_date<='{1}' ORDER BY a.trade_date", tmpdaterange[0].Trim(), tmpdaterange[1].Trim());
            myCommand = new SqlCommand(strSQL, myConn);
            adapter = new SqlDataAdapter(myCommand);
            DataTable dtTX = SqlDb.GetTable(strSQL, CommandType.Text, null);
            myConn.Close();
            for (int i = 0; i < dtTX.Rows.Count; i++)
            {
                //先找該筆指數要比對的結算價
                int year = int.Parse(dtTX.Rows[i]["end_date"].ToString().Substring(0, 4));
                int month = int.Parse(dtTX.Rows[i]["end_date"].ToString().Substring(4, 2));
                DateTime thisdate = new DateTime(year, month, 1);
                DateTime prevdate = thisdate.AddMonths(-1);
                DataRow[] rowClosePrice = dtClosePrice.Select(string.Format("end_date = '{0}'", prevdate.Year.ToString() + prevdate.Month.ToString()));
                int closePrice = 0;
                if (rowClosePrice.Length > 0)
                {
                    closePrice = Convert.ToInt16(rowClosePrice[0]["close_Price"]);
                }
                if (closePrice != 0)
                {
                    for (int j = 0; j < uprangelist.Count; j++)
                    {
                        for (int k = 0; k < downrangelist.Count; k++)
                        {
                            for (int l = 0; l < stopmoneyrangelist.Count; l++)
                            {
                                for (int m = 0; m < stophurtrangelist.Count; m++)
                                {

                                }
                            }
                        }
                    }
                }
            }
            DataTable dtResult = new DataTable();
            DataColumn column = new DataColumn();
            column.ColumnName = "uprange";
            column.DataType = System.Type.GetType("System.Int32");
            dtResult.Columns.Add(column);

            DataRow workRow = dtResult.NewRow();
            workRow["uprange"] = uprange1;
            dtResult.Rows.Add(workRow);
            myConn.Close();
            string json = JsonConvert.SerializeObject(dtResult, Formatting.None);
            return json;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }

    [WebMethod]
    public string SendEmail(string strEmailAddrFrom, string[] strEmailAddrTo, int intTotalEmailTo,string bodyMsg)
    {
        EmailAlert NewMail = new EmailAlert();
        return NewMail.EmailSent(strEmailAddrFrom, strEmailAddrTo, intTotalEmailTo, bodyMsg);
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public bool Login(string loginID, string passwd)
    {
        string strComputerName = "192.168.0.5";
        string strUserName = loginID;
        string strPassword = passwd;

        string strValidateUser = ValidateUser(strComputerName, strUserName, strPassword);
        if (strValidateUser != null)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetFileList(string dir, string fileext)
    {
        try
        {
            DirectoryInfo di = new DirectoryInfo(Server.MapPath(@dir));
            FileInfo[] fi = di.GetFiles(fileext);
            List<FileStruct> filejson = new List<FileStruct>();
            foreach (FileInfo f in fi)
            {
                FileStruct fs = new FileStruct();
                fs.OriginalPath = f.Name;
                //fs.FullPath = f.FullName;
                string path = Server.MapPath(".");
                fs.FullPath = f.FullName.Replace(path, String.Empty);
                filejson.Add(fs);
            }
            string json = JsonConvert.SerializeObject(filejson, Formatting.None);
            return json;
        }
        catch (Exception e)
        {
            WriteLog("General:" + e.ToString());
            return "";
        }
    }

    private void WriteLog(string str)
    {
        try
        {
            FileStream fs = new FileStream(Server.MapPath("/App_Data/log.txt"), FileMode.Append);
            using (StreamWriter sw = new StreamWriter(fs))
            {
                // 欲寫入的文字資料           
                sw.WriteLine(DateTime.Now + "-" + str);
                sw.Flush();
                sw.Close();
            }
             fs.Close();
        }
        catch (Exception ex)
        {

        }
        
    }


    public static string ValidateUser(string ComputerName, string UserName, string Password)
    {
        if (ComputerName.IndexOf('.') != -1)
        {
            AD.DirectoryEntry entry = new AD.DirectoryEntry(string.Format("LDAP://{0}/CN=administrator,CN=users,DC=goang-hann,DC=com", ComputerName, UserName), UserName, Password);   //AD上如有建sync帳號就用CN=sync，如無，用CN=administrator也可以
            try
            {
                string objectSid = (new SecurityIdentifier((byte[])entry.Properties["objectSid"].Value, 0).Value);
                return objectSid;
            }
            catch
            {
                return null;
            }
            finally
            {
                entry.Dispose();
            }
        }
        else
        {
            AD.DirectoryEntry entry = new AD.DirectoryEntry("WinNT://" + ComputerName, UserName, Password);
            try
            {
                string objectSid = (new SecurityIdentifier((byte[])entry.Properties["objectSid"].Value, 0).Value);
                return objectSid;
            }
            catch
            {
                return null;
            }
            finally
            {
                entry.Dispose();
            }
        }
    }
}