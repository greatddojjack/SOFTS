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
using NPOI.HPSF;
using NPOI.POIFS.FileSystem;
using NPOI.HSSF.Record;
using NPOI.HSSF.Util;
using NPOI.SS.Util;
using NPOI.SS.UserModel;

public partial class MOC_Default : System.Web.UI.Page
{
    string CNStr = "data source=192.168.0.188;initial catalog=GH;User id=reader;Password=";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //date_start.Text = DateTime.Now.AddMonths(-1).ToString("yyyyMM") + "01";
            //date_end.Text = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).AddDays(-1).ToString("yyyyMMdd");            
            date_start.Text = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).ToString("yyyyMMdd");
            date_end.Text = DateTime.Now.ToString("yyyyMMdd");
            GridView1.DataSource = GetQuery();
            GridView1.DataBind();
        }
    }

    protected void ok_Button_Click(object sender, EventArgs e)
    {
        
        GridView1.DataSource = GetQuery();
        GridView1.DataBind();
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
            string[] commandArgs = e.CommandArgument.ToString().Split(new char[] { ',' });
            string xx001 = hf_xx001.Value = commandArgs[0];
            string kpi = hf_kpi.Value = commandArgs[1].Trim();
            // Retrieve the connection string stored in the Web.config file.
            String connectionString = ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            String queryString = "";
            switch (kpi)
            {
                case "INV_01":
                    //queryString = "select TA001 '單別',TA002 '單號',TA014 '單據日期',INVTA.CREATOR '建立工號',mv1.MV002 '建單人員',INVTA.CREATE_DATE '建立日期',mv2.MV002 '確認人員',INVTA.MODI_DATE '確認日期',[HRMDB].dbo.[計算工作日](case when INVTA.CREATE_DATE>TA014 then TA014 else INVTA.CREATE_DATE end,INVTA.CREATE_DATE) '落後天數' from INVTA left join CMSMV as mv1 on mv1.MV001=INVTA.CREATOR left join CMSMV as mv2 on mv2.MV001=INVTA.TA015 where TA001=@INV_01 and INVTA.CREATE_DATE between @startdate AND @enddate and [HRMDB].dbo.[計算工作日](TA003,INVTA.CREATE_DATE)>0 and TA006<>'V'";
                    queryString = "select TA001 '單別',TA002 '單號',TA014 '單據日期',INVTA.CREATOR '建立工號',mv1.MV002 '建單人員',INVTA.CREATE_DATE '建立日期',[HRMDB].dbo.[計算工作日](case when INVTA.CREATE_DATE>TA014 then TA014 else INVTA.CREATE_DATE end,INVTA.CREATE_DATE) '落後天數' from INVTA left join CMSMV as mv1 on mv1.MV001=INVTA.CREATOR left join CMSMV as mv2 on mv2.MV001=INVTA.TA015 where TA001=@INV_01 and INVTA.CREATE_DATE between @startdate AND @enddate and [HRMDB].dbo.[計算工作日](TA003,INVTA.CREATE_DATE)>0 and TA006<>'V'";
                    break;
                case "PUR_01":
                    //queryString = "select TA001 '單別',TA002 '單號',TA013 '單據日期',PURTA.CREATOR '建立工號',mv1.MV002 '員工姓名',PURTA.CREATE_DATE '建立日期',mv2.MV002 '確認人員',PURTA.MODI_DATE '確認日期',[HRMDB].dbo.[計算工作日](case when PURTA.CREATE_DATE>TA013 then TA013 else PURTA.CREATE_DATE end,PURTA.CREATE_DATE) '落後天數' from PURTA left join CMSMV as mv1 on mv1.MV001=PURTA.CREATOR left join CMSMV as mv2 on mv2.MV001=PURTA.TA014 where TA001=@PUR_01 and PURTA.CREATE_DATE between @startdate AND @enddate and [HRMDB].dbo.[計算工作日](TA013,PURTA.CREATE_DATE)>0 and TA007<>'V'";
                    queryString = "select TA001 '單別',TA002 '單號',TA013 '單據日期',PURTA.CREATOR '建立工號',mv1.MV002 '員工姓名',PURTA.CREATE_DATE '建立日期',[HRMDB].dbo.[計算工作日](case when PURTA.CREATE_DATE>TA013 then TA013 else PURTA.CREATE_DATE end,PURTA.CREATE_DATE) '落後天數' from PURTA left join CMSMV as mv1 on mv1.MV001=PURTA.CREATOR left join CMSMV as mv2 on mv2.MV001=PURTA.TA014 where TA001=@PUR_01 and PURTA.CREATE_DATE between @startdate AND @enddate and [HRMDB].dbo.[計算工作日](TA013,PURTA.CREATE_DATE)>0 and TA007<>'V'";
                    break;
                case "PUR_02":
                    queryString = "select TC001 '單別',TC002 '單號',TC003 '單據日期',PURTC.CREATOR '建立工號',CMSMV.MV002 '員工姓名',PURTC.CREATE_DATE '建立日期',[HRMDB].dbo.[計算工作日](case when PURTC.CREATE_DATE>TC003 then TC003 else PURTC.CREATE_DATE end,PURTC.CREATE_DATE) '落後天數' from PURTC left join CMSMV on MV001=PURTC.CREATOR where TC001=@PUR_02 and PURTC.CREATE_DATE between @startdate AND @enddate and [HRMDB].dbo.[計算工作日](TC003,PURTC.CREATE_DATE)>0 and TC014<>'V'";
                    break;
                case "PUR_03":
                    queryString = "select TG001 '單別',TG002 '單號',TG014 '單據日期',PURTG.CREATOR '建立工號',CMSMV.MV002 '員工姓名',PURTG.CREATE_DATE '建立日期',[HRMDB].dbo.[計算工作日](case when PURTG.CREATE_DATE>TG014 then TG014 else PURTG.CREATE_DATE end,PURTG.CREATE_DATE) '落後天數' from PURTG left join CMSMV on MV001=PURTG.CREATOR where TG001=@PUR_03 and PURTG.CREATE_DATE between @startdate AND @enddate and [HRMDB].dbo.[計算工作日](TG014,PURTG.CREATE_DATE)>0 and TG013<>'V'";
                    break;
                case "PUR_04":
                    queryString = "select TI001 '單別',TI002 '單號',TI014 '單據日期',PURTI.CREATOR '建立工號',CMSMV.MV002 '員工姓名',PURTI.CREATE_DATE '建立日期',[HRMDB].dbo.[計算工作日](case when PURTI.CREATE_DATE>TI014 then TI014 else PURTI.CREATE_DATE end,PURTI.CREATE_DATE) '落後天數' from PURTI left join CMSMV on MV001=PURTI.CREATOR where TI001=@PUR_04 and PURTI.CREATE_DATE between @startdate AND @enddate and [HRMDB].dbo.[計算工作日](TI014,PURTI.CREATE_DATE)>0 and TI013<>'V'";
                    break;
                case "MOC_01":
                    queryString = "select TA001 '單別',TA002 '單號',TA003 '單據日期',MOCTA.CREATOR '建立工號',CMSMV.MV002 '員工姓名',MOCTA.CREATE_DATE '建立日期',[HRMDB].dbo.[計算工作日](case when MOCTA.CREATE_DATE>TA003 then TA003 else MOCTA.CREATE_DATE end,MOCTA.CREATE_DATE) '落後天數' from MOCTA left join CMSMV on MV001=MOCTA.CREATOR where TA001=@MOC_01 and MOCTA.CREATE_DATE between @startdate AND @enddate and [HRMDB].dbo.[計算工作日](TA003,MOCTA.CREATE_DATE)>0 and TA013<>'V'";
                    break;
                case "MOC_02":
                    queryString = "select TC001 '單別',TC002 '單號',TC014 '單據日期',MOCTC.CREATOR '建立工號',CMSMV.MV002 '員工姓名',MOCTC.CREATE_DATE '建立日期',[HRMDB].dbo.[計算工作日](case when MOCTC.CREATE_DATE>TC014 then TC014 else MOCTC.CREATE_DATE end,MOCTC.CREATE_DATE) '落後天數',TC020+'-'+TC021 '製令單號' from MOCTC left join CMSMV on MV001=MOCTC.CREATOR where TC001=@MOC_02 and MOCTC.CREATE_DATE between @startdate AND @enddate and [HRMDB].dbo.[計算工作日](TC014,MOCTC.CREATE_DATE)>0 and TC009<>'V'";
                    break;
                case "MOC_03":
                    queryString = "select TF001 '單別',TF002 '單號',TF012 '單據日期',MOCTF.CREATOR '建立工號',mv1.MV002 '員工姓名',MOCTF.CREATE_DATE '建立日期',mv2.MV002 '確認人員',MOCTF.MODI_DATE '確認日期',[HRMDB].dbo.[計算工作日](case when MOCTF.CREATE_DATE>TF012 then TF012 else MOCTF.CREATE_DATE end,MOCTF.CREATE_DATE) '落後天數',TG014+'-'+TG015 '製令單號' from MOCTF left join MOCTG on TG001=TF001 and TG002=TF002 left join CMSMV as mv1 on mv1.MV001=MOCTF.CREATOR left join CMSMV as mv2 on mv2.MV001=MOCTF.TF013 where TF001=@MOC_03 and MOCTF.CREATE_DATE between @startdate AND @enddate and [HRMDB].dbo.[計算工作日](TF012,MOCTF.CREATE_DATE)>0 and TF006<>'V'";
                    break;
                case "MOC_04":
                    queryString = "select TH001 '單別',TH002 '單號',TH029 '單據日期',MOCTH.CREATOR '建立工號',CMSMV.MV002 '員工姓名',MOCTH.CREATE_DATE '建立日期',[HRMDB].dbo.[計算工作日](case when MOCTH.CREATE_DATE>TH029 then TH029 else MOCTH.CREATE_DATE end,MOCTH.CREATE_DATE) '落後天數',TI013+'-'+TI014 '製令單號' from MOCTH left join MOCTI on TI001=TH001 and TI002=TH002 left join CMSMV on MV001=MOCTH.CREATOR where TH001=@MOC_04 and MOCTH.CREATE_DATE between @startdate AND @enddate and [HRMDB].dbo.[計算工作日](TH029,MOCTH.CREATE_DATE)>0 and TH023<>'V'";
                    break;
                case "SFC_01":
                    queryString = "select TD001 '單別',TD002 '單號',TD008 '單據日期',SFCTD.CREATOR '建立工號',CMSMV.MV002 '員工姓名',SFCTD.CREATE_DATE '建立日期',[HRMDB].dbo.[計算工作日](case when SFCTD.CREATE_DATE>TD008 then TD008 else SFCTD.CREATE_DATE end,SFCTD.CREATE_DATE) '落後天數',TE006+'-'+TE007 '製令單號' from SFCTD left join SFCTE on TE001=TD001 and TE002=TD002 left join CMSMV on MV001=SFCTD.CREATOR where TD001=@SFC_01 and SFCTD.CREATE_DATE between @startdate AND @enddate and [HRMDB].dbo.[計算工作日](TD008,SFCTD.CREATE_DATE)>0 and TD005<>'V'";
                    break;
            }
            queryString = queryString + " order by '建立工號','落後天數' desc";
            hf_qs.Value = queryString;
            ViewState["gv2_qs"] = queryString;
            ViewState["xx001"] = xx001;
            ViewState["kpi"] = kpi;
            GridView2.DataSource = GetSubQuery(queryString,xx001,kpi);
            GridView2.DataBind();
            this.ModalPopupExtender1.Show();
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
                row2.CreateCell(j).SetCellValue(dt.Rows[i][j].ToString());
        }


        //寫入到客戶端
        System.IO.MemoryStream ms = new System.IO.MemoryStream();
        book.Write(ms);
        Response.AddHeader("Content-Disposition", string.Format("attachment; filename={0}-{1}_KPI01.xls", date_start.Text,date_end.Text.Substring(6,2)));
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
        SqlParameter[] p = new SqlParameter[3];
        p[0] = new SqlParameter("@StartDate", date_start.Text);
        p[1] = new SqlParameter("@EndDate", date_end.Text);
        p[2] = new SqlParameter("@chk", sys_list.SelectedValue);
        DataTable dt = SqlDb.GetTable("建單即時率", CommandType.StoredProcedure, p);
        foreach (DataRow dr in dt.Select("[KPI編號] like 'COP%' or [KPI編號] like 'ACP%' or [KPI編號] like 'ACR%' or [KPI編號] like 'NOT%' or [單別] like '1109' or [單別] like '3402' or [單別] like '1113' or [單別] like '1288' or [單別] like '3406' or [單別] like '1103' or [單別] like '1197'"))
        {
            dr.Delete();
        }
        dt.AcceptChanges();
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

    protected void GridView2_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView2.PageIndex = e.NewPageIndex;
        if(ViewState["gv2_qs"]!=null)
        {
            GridView2.DataSource = GetSubQuery((string)ViewState["gv2_qs"], (string)ViewState["xx001"], (string)ViewState["kpi"]);
            GridView2.DataBind();
            this.ModalPopupExtender1.Show();
        }            
        //
    }
}