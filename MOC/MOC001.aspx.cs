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

public partial class MOC_Default : System.Web.UI.Page
{
    string CNStr = "data source=192.168.0.188;initial catalog=GH;User id=reader;Password=";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack == false)
        {
            date_start.Text = DateTime.Now.Year.ToString() + "01";
            date_end.Text = DateTime.Now.ToString("yyyyMM");
        }
    }

    protected void ok_Button_Click(object sender, EventArgs e)
    {

        DataTable dt = new DataTable();

        dt.Columns.Add("日期");
        dt.Columns.Add("6005");
        dt.Columns.Add("6061");
        dt.Columns.Add("6061B");
        dt.Columns.Add("6061H");
        dt.Columns.Add("6063");
        dt.Columns.Add("6063B");
        dt.Columns.Add("6063C");
        dt.Columns.Add("6063D");
        dt.Columns.Add("6063G");
        dt.Columns.Add("6063H");
        dt.Columns.Add("6066");
        dt.Columns.Add("6082");
        dt.Columns.Add("6463");
        dt.Columns.Add("合計");
        using (SqlConnection nowConnection = new SqlConnection(CNStr))//使用連接字串初始SqlConnection物件連接資料庫
        {
            nowConnection.Open();//開啟連線
            using (SqlCommand command = new SqlCommand())
            {
                command.CommandText = sql_all(machine_list.SelectedValue);
                command.Connection = nowConnection;//資料庫連接
                SqlDataReader dr = command.ExecuteReader();//執行並回傳DataReader    
                if (dr.HasRows)//檢查是否有資料列
                {
                    while (dr.Read())
                    {
                        dt.Rows.Add(dr[0].ToString(), dr[1].ToString(), dr[2].ToString(), dr[3].ToString(), dr[4].ToString(), dr[5].ToString(), dr[6].ToString(), dr[7].ToString(), dr[8].ToString(), dr[9].ToString(), dr[10].ToString(), dr[11].ToString(), dr[12].ToString(), dr[13].ToString(), dr[14].ToString());
                    }
                }
            }
            nowConnection.Close();
        }


        GridView1.DataSource = dt;
        GridView1.DataBind();
        GridView1.Caption = machine_list.SelectedItem.Text + "鋁圓條耗用統計表(僅列出常用材質)　　單位：噸　　　　製表:王培旭" + DateTime.Now.ToShortDateString();
    }

    protected void GridView1_DataBound(object sender, EventArgs e)
    {
        //rows.count要扣2，因為最下面兩行是合計跟平均
        for (int i = 0; i < GridView1.Rows.Count - 2; i++)
        {
            for (int j = 1; j < GridView1.Rows[0].Cells.Count - 1; j++)
            {
                GridView1.Rows[i].Cells[GridView1.Rows[0].Cells.Count - 1].Text = (Convert.ToDouble(GridView1.Rows[i].Cells[GridView1.Rows[0].Cells.Count - 1].Text) + Convert.ToDouble(GridView1.Rows[i].Cells[j].Text)).ToString();//最右方的合計
                GridView1.Rows[GridView1.Rows.Count - 2].Cells[j].Text = (Convert.ToDouble(GridView1.Rows[GridView1.Rows.Count - 2].Cells[j].Text) + Convert.ToDouble(GridView1.Rows[i].Cells[j].Text)).ToString();//下面數來倒數第二行的合計
            }
            GridView1.Rows[GridView1.Rows.Count - 2].Cells[GridView1.Rows[0].Cells.Count - 1].Text = (Convert.ToDouble(GridView1.Rows[GridView1.Rows.Count - 2].Cells[GridView1.Rows[0].Cells.Count - 1].Text) + Convert.ToDouble(GridView1.Rows[i].Cells[GridView1.Rows[0].Cells.Count - 1].Text)).ToString();//倒數第2行，最右方總合計
        }


        for (int g = 1; g < GridView1.Rows[0].Cells.Count; g++)
        {
            GridView1.Rows[GridView1.Rows.Count - 1].Cells[g].Text = (Convert.ToDouble(GridView1.Rows[GridView1.Rows.Count - 2].Cells[g].Text) / Convert.ToDouble(GridView1.Rows.Count - 2)).ToString("0.#");//最下面那行的平均
        }
    }

    private string sql_all(string str)
    {
        DateTime start = Convert.ToDateTime(date_start.Text.Substring(0, 4) + "/" + date_start.Text.Substring(4, 2) + "/01");
        DateTime end = Convert.ToDateTime((date_end.Text).Substring(0, 4) + "/" + (Convert.ToInt32((date_end.Text).Substring(4, 2))).ToString("00") + "/01").AddMonths(1).AddDays(-1);//迄的最後一天
        string new_str = "";

        for (int i = 0; i <= end.Month - start.Month; i++)
        {
            string ym = start.AddMonths(i).ToString("yyyyMM");
            string sql_str = string.Format("SELECT '{0}',(CASE WHEN SUM(XG007)IS NULL THEN 0 ELSE round(convert(float, SUM(XG007)) / 1000, 1) END)as'這行是6005'" +
                ",(SELECT(CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float, SUM(XG007)) / 1000, 1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001 = XF001 LEFT JOIN MOCXG ON XF001 = XG001 AND XF002 = XG002 WHERE XF020 = 'Y' AND XF029 = '1' AND XF023 = '{1}' AND XF004 like '{0}%' AND XC006 = '6061')" +
                ",(SELECT(CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float, SUM(XG007)) / 1000, 1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001 = XF001 LEFT JOIN MOCXG ON XF001 = XG001 AND XF002 = XG002 WHERE XF020 = 'Y' AND XF029 = '1' AND XF023 = '{1}' AND XF004 like '{0}%' AND XC006 = '6061B')" +
                ",(SELECT(CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float, SUM(XG007)) / 1000, 1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001 = XF001 LEFT JOIN MOCXG ON XF001 = XG001 AND XF002 = XG002 WHERE XF020 = 'Y' AND XF029 = '1' AND XF023 = '{1}' AND XF004 like '{0}%' AND XC006 = '6061H')" +
                ",(SELECT(CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float, SUM(XG007)) / 1000, 1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001 = XF001 LEFT JOIN MOCXG ON XF001 = XG001 AND XF002 = XG002 WHERE XF020 = 'Y' AND XF029 = '1' AND XF023 = '{1}' AND XF004 like '{0}%' AND XC006 = '6063')" +
                ",(SELECT(CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float, SUM(XG007)) / 1000, 1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001 = XF001 LEFT JOIN MOCXG ON XF001 = XG001 AND XF002 = XG002 WHERE XF020 = 'Y' AND XF029 = '1' AND XF023 = '{1}' AND XF004 like '{0}%' AND XC006 = '6063B')" +
                ",(SELECT(CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float, SUM(XG007)) / 1000, 1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001 = XF001 LEFT JOIN MOCXG ON XF001 = XG001 AND XF002 = XG002 WHERE XF020 = 'Y' AND XF029 = '1' AND XF023 = '{1}' AND XF004 like '{0}%' AND XC006 = '6063C')" +
                ",(SELECT(CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float, SUM(XG007)) / 1000, 1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001 = XF001 LEFT JOIN MOCXG ON XF001 = XG001 AND XF002 = XG002 WHERE XF020 = 'Y' AND XF029 = '1' AND XF023 = '{1}' AND XF004 like '{0}%' AND XC006 = '6063D')" +
                ",(SELECT(CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float, SUM(XG007)) / 1000, 1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001 = XF001 LEFT JOIN MOCXG ON XF001 = XG001 AND XF002 = XG002 WHERE XF020 = 'Y' AND XF029 = '1' AND XF023 = '{1}' AND XF004 like '{0}%' AND XC006 = '6063G')" +
                ",(SELECT(CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float, SUM(XG007)) / 1000, 1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001 = XF001 LEFT JOIN MOCXG ON XF001 = XG001 AND XF002 = XG002 WHERE XF020 = 'Y' AND XF029 = '1' AND XF023 = '{1}' AND XF004 like '{0}%' AND XC006 = '6063H')" +
                ",(SELECT(CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float, SUM(XG007)) / 1000, 1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001 = XF001 LEFT JOIN MOCXG ON XF001 = XG001 AND XF002 = XG002 WHERE XF020 = 'Y' AND XF029 = '1' AND XF023 = '{1}' AND XF004 like '{0}%' AND XC006 = '6066')" +
                ",(SELECT(CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float, SUM(XG007)) / 1000, 1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001 = XF001 LEFT JOIN MOCXG ON XF001 = XG001 AND XF002 = XG002 WHERE XF020 = 'Y' AND XF029 = '1' AND XF023 = '{1}' AND XF004 like '{0}%' AND XC006 = '6082')" +
                ",(SELECT(CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float, SUM(XG007)) / 1000, 1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001 = XF001 LEFT JOIN MOCXG ON XF001 = XG001 AND XF002 = XG002 WHERE XF020 = 'Y' AND XF029 = '1' AND XF023 = '{1}' AND XF004 like '{0}%' AND XC006 = '6463')" +
                ",'0' as'合計由前端去算'FROM MOCXC LEFT JOIN MOCXF ON XC001 = XF001 LEFT JOIN MOCXG ON XF001 = XG001 AND XF002 = XG002 WHERE XF020 = 'Y' AND XF029 = '1' AND XF023 = '{1}' AND XF004 like '{0}%' AND XC006 = '6005'", ym, str);
            if (i == 0)
            {
                new_str = sql_str;
            }
            if (i > 0 && i != end.Month - start.Month)
            {
                new_str = new_str + " union " + sql_str;
            }
            if (i == end.Month - start.Month)
            {
                new_str = new_str + " union " + sql_str + " union select '合計','','','','','','','','','','','','','','0' union select '平均','','','','','','','','','','','','','','0'";
            }
        }
        return new_str;
    }
    private string sql_7and8(string str)
    {
        DateTime start = Convert.ToDateTime(date_start.Text.Substring(0, 4) + "/" + date_start.Text.Substring(4, 2) + "/01");
        DateTime end = Convert.ToDateTime((date_end.Text).Substring(0, 4) + "/" + (Convert.ToInt32((date_end.Text).Substring(4, 2))).ToString("00") + "/01").AddMonths(1).AddDays(-1);//迄的最後一天
        string new_str = "";
        for (int i = 0; i < Convert.ToInt32(((end.Subtract(start).Days) / 30)); i++)
        {
            string sql_str = "SELECT '" + start.AddMonths(i).ToString("yyyy/MM") + "',(CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float,SUM(XG007))/1000,1) END)as'這行是6063'" +
",(SELECT (CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float,SUM(XG007))/1000,1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001=XF001 LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF020='Y' AND XF029='1' AND XF023='" + str + "' AND XF004 like '" + start.AddMonths(i).ToString("yyyyMM") + "%' AND XC006 ='6463')" +
",(SELECT (CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float,SUM(XG007))/1000,1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001=XF001 LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF020='Y' AND XF029='1' AND XF023='" + str + "' AND XF004 like '" + start.AddMonths(i).ToString("yyyyMM") + "%' AND XC006 ='6061')" +
",(SELECT (CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float,SUM(XG007))/1000,1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001=XF001 LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF020='Y' AND XF029='1' AND XF023='" + str + "' AND XF004 like '" + start.AddMonths(i).ToString("yyyyMM") + "%' AND XC006 ='6061B')" +
",(SELECT (CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float,SUM(XG007))/1000,1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001=XF001 LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF020='Y' AND XF029='1' AND XF023='" + str + "' AND XF004 like '" + start.AddMonths(i).ToString("yyyyMM") + "%' AND XC006 ='6061H')" +
",(SELECT (CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float,SUM(XG007))/1000,1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001=XF001 LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF020='Y' AND XF029='1' AND XF023='" + str + "' AND XF004 like '" + start.AddMonths(i).ToString("yyyyMM") + "%' AND XC006 ='6082')" +
",(SELECT (CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float,SUM(XG007))/1000,1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001=XF001 LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF020='Y' AND XF029='1' AND XF023='" + str + "' AND XF004 like '" + start.AddMonths(i).ToString("yyyyMM") + "%' AND XC006 ='6005')" +
",'0'as'合計由前端去算'FROM MOCXC LEFT JOIN MOCXF ON XC001=XF001 LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF020='Y' AND XF029='1' AND XF023='" + str + "' AND XF004 like '" + start.AddMonths(i).ToString("yyyyMM") + "%' AND XC006 ='6063'";
            if (i == 0)
            {
                new_str = sql_str;
            }
            if (i > 0 && i != Convert.ToInt32(((end.Subtract(start).Days) / 30) - 1))
            {
                new_str = new_str + " union " + sql_str;
            }
            if (i == Convert.ToInt32(((end.Subtract(start).Days) / 30) - 1))
            {
                new_str = new_str + " union " + sql_str + " union select '合計','','','','','','','','0' union select '平均','','','','','','','','0'";
            }
        }
        return new_str;
    }
    private string sql_4and5(string str)
    {
        DateTime start = Convert.ToDateTime(date_start.Text.Substring(0, 4) + "/" + date_start.Text.Substring(4, 2) + "/01");
        DateTime end = Convert.ToDateTime((date_end.Text).Substring(0, 4) + "/" + (Convert.ToInt32((date_end.Text).Substring(4, 2))).ToString("00") + "/01").AddMonths(1).AddDays(-1);//迄的最後一天
        string new_str = "";
        for (int i = 0; i < Convert.ToInt32(((end.Subtract(start).Days) / 30)); i++)
        {
            string sql_str = "SELECT '" + start.AddMonths(i).ToString("yyyy/MM") + "',(CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float,SUM(XG007))/1000,1) END)as'這行是6063'" +
",(SELECT (CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float,SUM(XG007))/1000,1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001=XF001 LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF020='Y' AND XF029='1' AND XF023 ='" + str + "' AND XF004 like '" + start.AddMonths(i).ToString("yyyyMM") + "%' AND XC006 ='6063G')" +
",(SELECT (CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float,SUM(XG007))/1000,1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001=XF001 LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF020='Y' AND XF029='1' AND XF023 ='" + str + "' AND XF004 like '" + start.AddMonths(i).ToString("yyyyMM") + "%' AND XC006 ='6063H')" +
",(SELECT (CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float,SUM(XG007))/1000,1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001=XF001 LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF020='Y' AND XF029='1' AND XF023 ='" + str + "' AND XF004 like '" + start.AddMonths(i).ToString("yyyyMM") + "%' AND XC006 ='6463')" +
",(SELECT (CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float,SUM(XG007))/1000,1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001=XF001 LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF020='Y' AND XF029='1' AND XF023 ='" + str + "' AND XF004 like '" + start.AddMonths(i).ToString("yyyyMM") + "%' AND XC006 ='6061B')" +
",(SELECT (CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float,SUM(XG007))/1000,1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001=XF001 LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF020='Y' AND XF029='1' AND XF023 ='" + str + "' AND XF004 like '" + start.AddMonths(i).ToString("yyyyMM") + "%' AND XC006 ='6061H')" +
",(SELECT (CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float,SUM(XG007))/1000,1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001=XF001 LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF020='Y' AND XF029='1' AND XF023 ='" + str + "' AND XF004 like '" + start.AddMonths(i).ToString("yyyyMM") + "%' AND XC006 ='6063C')" +
",(SELECT (CASE WHEN SUM(XG007) IS NULL THEN 0 ELSE round(convert(float,SUM(XG007))/1000,1) END) FROM MOCXC LEFT JOIN MOCXF ON XC001=XF001 LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF020='Y' AND XF029='1' AND XF023 ='" + str + "' AND XF004 like '" + start.AddMonths(i).ToString("yyyyMM") + "%' AND XC006 ='6005')" +
",'0'as'合計由前端去算'FROM MOCXC LEFT JOIN MOCXF ON XC001=XF001 LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF020='Y' AND XF029='1' AND XF023 ='" + str + "' AND XF004 like '" + start.AddMonths(i).ToString("yyyyMM") + "%' AND XC006 ='6063'";
            if (i == 0)
            {
                new_str = sql_str;
            }
            if (i > 0 && i != Convert.ToInt32(((end.Subtract(start).Days) / 30) - 1))
            {
                new_str = new_str + " union " + sql_str;
            }
            if (i == Convert.ToInt32(((end.Subtract(start).Days) / 30) - 1))
            {
                new_str = new_str + " union " + sql_str + " union select '合計','','','','','','','','','0' union select '平均','','','','','','','','','0'";
            }
        }
        return new_str;
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
}