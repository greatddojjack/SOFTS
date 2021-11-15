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

public partial class SFC_Default : System.Web.UI.Page
{
    string CNStr = "data source=192.168.0.188;initial catalog=GH;User id=reader;Password=";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //date_start.Text = DateTime.Now.AddMonths(-1).ToString("yyyyMM") + "01";
            //date_end.Text = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).AddDays(-1).ToString("yyyyMMdd");            
            date_start.Text = DateTime.Now.AddDays(-30).ToString("yyyyMMdd");
            date_end.Text = DateTime.Now.ToString("yyyyMMdd");           
            GridView1.DataSource = GetQuery();
            GridView1.DataBind();
            GridView1.UseAccessibleHeader = true;
            GridView1.HeaderRow.TableSection = TableRowSection.TableHeader;
            
        }
    }

    protected void ok_Button_Click(object sender, EventArgs e)
    {
        GridView1.DataSource = GetQuery();
        GridView1.DataBind();
        GridView1.UseAccessibleHeader = true;
        GridView1.HeaderRow.TableSection = TableRowSection.TableHeader;
        ScriptManager.RegisterStartupScript(Page, GetType(), "InitTable", "<script>InitTable();</script>", false);
    }

    protected void GridView1_DataBound(object sender, EventArgs e)
    {
        
    }    

    public override void VerifyRenderingInServerForm(Control control)
    {
        /*Verifies that the control is rendered */
    }

    protected void PrintCurrentPage(object sender, EventArgs e)
    {



        StringWriter sw = new StringWriter();

        HtmlTextWriter hw = new HtmlTextWriter(sw);

        GridView1.RenderControl(hw);

        string gridHTML = sw.ToString().Replace("\"", "'")

            .Replace(System.Environment.NewLine, "");

        StringBuilder sb = new StringBuilder();

        sb.Append("<script type = 'text/javascript'>");

        sb.Append("window.onload = new function(){");

        sb.Append("var printWin = window.open('', '', 'left=0");

        sb.Append(",top=0,width=1000,height=600,status=1,toolbar=yes,scrollbars=yes,resizable=yes');");

        sb.Append("printWin.document.write(\"");

        sb.Append(gridHTML);

        sb.Append("\");");

        sb.Append("printWin.document.close();");

        sb.Append("printWin.focus();}");

        sb.Append("</script>");

        ClientScript.RegisterStartupScript(this.GetType(), "GridPrint", sb.ToString());



    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            //隱藏因作業特性無法即時打單的單別
            //if (e.Row.Cells[0].Text.IndexOf("COP") >= 0 || e.Row.Cells[0].Text.IndexOf("ACP")>=0 || e.Row.Cells[0].Text.IndexOf("ACR") >= 0 || e.Row.Cells[0].Text.IndexOf("NOT") >= 0)
            //{
            //    e.Row.Visible = false;
            //}
        }
    }
    
    protected void GridView1_RowCommand(object sender,  GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ShowGridView")
        {
            
        }

    }
    protected void getExcel(DataTable dt)
    {
        HSSFWorkbook book = new NPOI.HSSF.UserModel.HSSFWorkbook();
        ISheet sheet = book.CreateSheet("Sheet1");
        IRow row = sheet.CreateRow(0);
        for (int i = 0; i < dt.Columns.Count; i++)
        {
            row.CreateCell(i).SetCellValue(dt.Columns[i].ColumnName);
        }

        for (int i = 0; i < dt.Rows.Count; i++)
        {
            IRow row2 = sheet.CreateRow(i + 1);
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                row2.CreateCell(j).SetCellValue(dt.Rows[i][j].ToString());
                if (dt.Columns[j].ColumnName == "數量")
                    row2.CreateCell(j).SetCellValue(Convert.ToDouble(dt.Rows[i][j].ToString()));
                else
                    row2.CreateCell(j).SetCellValue(dt.Rows[i][j].ToString());
            }
        }


        //寫入到客戶端
        System.IO.MemoryStream ms = new System.IO.MemoryStream();
        book.Write(ms);
        Response.AddHeader("Content-Disposition", string.Format("attachment; filename={0}_SFC01.xls", DateTime.Now.ToString("yyyyMMddHHmmss")));
        Response.BinaryWrite(ms.ToArray());
        book = null;
        ms.Close();
        ms.Dispose();
    }

    protected void excel_Button_Click(object sender, EventArgs e)
    {        
        getExcel(GetQuery());        
    }
    protected DataTable GetQuery()
    {
        SqlParameter[] p = new SqlParameter[2];
        p[0] = new SqlParameter("@startdate", date_start.Text);
        p[1] = new SqlParameter("@enddate", date_end.Text);
        string querystring = "select TB015 '單據日期',TB001+'-'+TB002 '移轉單號',TC003 '序號',TC004+'-'+TC005 '製令單號',TC047 '品號',TC048 '品名',TC006 '工序',TC007 '製程代號',MW002 '製程名稱',TB016 '確認者',MV002 '姓名',TC036 '數量',TB008 '移入部門',TB009 '部門名稱' from SFCTB left join SFCTC on TB001=TC001 and TB002=TC002 left join CMSMW on TC007=MW001 left join CMSMV on MV001=TB016 where TB013='Y' and TB001='D301' and TB008 like '%E%' and TB015 between @startdate and @enddate";
        DataTable dt = SqlDb.GetTable(querystring, CommandType.Text, p);        
        return dt;
    }
    protected DataTable GetSubQuery(string querystring,string xx001,string kpi)
    {        

        SqlParameter[] p = new SqlParameter[3];
        p[0] = new SqlParameter("@" + kpi, xx001);
        p[1] = new SqlParameter("@startdate", date_start.Text);
        p[2] = new SqlParameter("@enddate", date_end.Text);
        DataTable dt = SqlDb.GetTable(querystring, CommandType.Text, p);                
        return dt;
    }

    protected void btnSubExcel_Click(object sender, EventArgs e)
    {
        getExcel(GetSubQuery(hf_qs.Value, hf_xx001.Value, hf_kpi.Value));
    }
    
}