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
    DataTable dt = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack == false)
        {
            start_date.Text = DateTime.Now.Year + DateTime.Now.Month.ToString("00") + DateTime.Now.Day.ToString("00");
            end_date.Text = DateTime.Now.Year + DateTime.Now.Month.ToString("00") + DateTime.Now.Day.ToString("00");
        }

    }
    protected void GridView1_PreRender(object sender, EventArgs e)
    {
        int i = 1;
        foreach (GridViewRow count in GridView1.Rows)
        {
            //比對如果名稱如果相同就合
            if (count.RowIndex != 0)
            {
                if (count.Cells[0].Text.Trim() == GridView1.Rows[(count.RowIndex - i)].Cells[0].Text.Trim())
                {
                    GridView1.Rows[(count.RowIndex - i)].Cells[0].RowSpan += 1;
                    //GridView2.Rows[(count.RowIndex - i)].Cells[1].RowSpan += 1;
                    count.Cells[0].Visible = false;
                    //count.Cells[1].Visible = false;
                    i++;
                }
                else
                {
                    GridView1.Rows[(count.RowIndex)].Cells[0].RowSpan += 1;
                    //GridView2.Rows[(count.RowIndex)].Cells[1].RowSpan += 1;
                    i = 1;
                }

            }
            else
            {
                count.Cells[0].RowSpan = 1;
                //count.Cells[1].RowSpan = 1;
            }
        }
    }
    protected void ok_Button_Click(object sender, EventArgs e)
    {
        DateTime tmp_start = Convert.ToDateTime(start_date.Text.Substring(0, 4) + "/" + start_date.Text.Substring(4, 2) + "/" + start_date.Text.Substring(6, 2));
        DateTime tmp_end = Convert.ToDateTime(end_date.Text.Substring(0, 4) + "/" + end_date.Text.Substring(4, 2) + "/" + end_date.Text.Substring(6, 2));
        DataTable dt = new DataTable();
        dt.Columns.Add("預產日");
        dt.Columns.Add("生產線別");
        dt.Columns.Add("預估成品率");
        dt.Columns.Add("實際成品率");        
        dt.Columns.Add("回單用錠重");
        dt.Columns.Add("實際成品率(含試模)");
        dt.Columns.Add("回單用錠重(含試模)");
        dt.Columns.Add("入庫重量");

        for (int i = 0; i <= (tmp_end.Subtract(tmp_start)).Days; i++)
        {
            using (SqlConnection nowConnection = new SqlConnection(CNStr))//使用連接字串初始SqlConnection物件連接資料庫
            {

                if (line_texbox.Text == "P41" || line_texbox.Text == "P")
                {
                    nowConnection.Open();//開啟連線
                    using (SqlCommand command = new SqlCommand())
                    {
                        command.CommandText = Pxx(tmp_start.AddDays(i).Year.ToString() + tmp_start.AddDays(i).Month.ToString("00") + tmp_start.AddDays(i).Day.ToString("00"),"41");
                        command.Connection = nowConnection;//資料庫連接
                        SqlDataReader dr = command.ExecuteReader();//執行並回傳DataReader    
                        if (dr.HasRows)//檢查是否有資料列
                        {
                            while (dr.Read())
                            {
                                dt.Rows.Add(dr[0].ToString(), dr[1].ToString(), dr[2].ToString(), dr[3].ToString(), dr[4].ToString(), dr[5].ToString(), dr[6].ToString(), dr[7].ToString());
                            }
                        }
                    }
                    nowConnection.Close();
                }
                if (line_texbox.Text == "P42" || line_texbox.Text == "P")
                {
                    nowConnection.Open();//開啟連線
                    using (SqlCommand command = new SqlCommand())
                    {
                        command.CommandText = Pxx(tmp_start.AddDays(i).Year.ToString() + tmp_start.AddDays(i).Month.ToString("00") + tmp_start.AddDays(i).Day.ToString("00"),"42");
                        command.Connection = nowConnection;//資料庫連接
                        SqlDataReader dr = command.ExecuteReader();//執行並回傳DataReader    
                        if (dr.HasRows)//檢查是否有資料列
                        {
                            while (dr.Read())
                            {
                                dt.Rows.Add(dr[0].ToString(), dr[1].ToString(), dr[2].ToString(), dr[3].ToString(), dr[4].ToString(), dr[5].ToString(), dr[6].ToString(), dr[7].ToString());
                            }
                        }
                    }
                    nowConnection.Close();
                }
                if (line_texbox.Text == "P51" || line_texbox.Text == "P")
                {
                    nowConnection.Open();//開啟連線
                    using (SqlCommand command51 = new SqlCommand())
                    {
                        command51.CommandText = Pxx(tmp_start.AddDays(i).Year.ToString() + tmp_start.AddDays(i).Month.ToString("00") + tmp_start.AddDays(i).Day.ToString("00"),"51");
                        command51.Connection = nowConnection;//資料庫連接
                        SqlDataReader dr51 = command51.ExecuteReader();//執行並回傳DataReader    
                        if (dr51.HasRows)//檢查是否有資料列
                        {
                            while (dr51.Read())
                            {
                                dt.Rows.Add(dr51[0].ToString(), dr51[1].ToString(), dr51[2].ToString(), dr51[3].ToString(), dr51[4].ToString(), dr51[5].ToString(), dr51[6].ToString(), dr51[7].ToString());
                            }
                        }
                    }
                    nowConnection.Close();
                }
                if (line_texbox.Text == "P52" || line_texbox.Text == "P")
                {
                    nowConnection.Open();//開啟連線
                    using (SqlCommand command52 = new SqlCommand())
                    {
                        command52.CommandText = Pxx(tmp_start.AddDays(i).Year.ToString() + tmp_start.AddDays(i).Month.ToString("00") + tmp_start.AddDays(i).Day.ToString("00"),"52");
                        command52.Connection = nowConnection;//資料庫連接
                        SqlDataReader dr52 = command52.ExecuteReader();//執行並回傳DataReader    
                        if (dr52.HasRows)//檢查是否有資料列
                        {
                            while (dr52.Read())
                            {
                                dt.Rows.Add(dr52[0].ToString(), dr52[1].ToString(), dr52[2].ToString(), dr52[3].ToString(), dr52[4].ToString(), dr52[5].ToString(), dr52[6].ToString(), dr52[7].ToString());
                            }
                        }
                    }
                    nowConnection.Close();
                }
                if (line_texbox.Text == "P53" || line_texbox.Text == "P")
                {
                    nowConnection.Open();//開啟連線
                    using (SqlCommand command53 = new SqlCommand())
                    {
                        command53.CommandText = Pxx(tmp_start.AddDays(i).Year.ToString() + tmp_start.AddDays(i).Month.ToString("00") + tmp_start.AddDays(i).Day.ToString("00"),"53");
                        command53.Connection = nowConnection;//資料庫連接
                        SqlDataReader dr53 = command53.ExecuteReader();//執行並回傳DataReader    
                        if (dr53.HasRows)//檢查是否有資料列
                        {
                            while (dr53.Read())
                            {
                                dt.Rows.Add(dr53[0].ToString(), dr53[1].ToString(), dr53[2].ToString(), dr53[3].ToString(), dr53[4].ToString(), dr53[5].ToString(), dr53[6].ToString(), dr53[7].ToString());
                            }
                        }
                    }
                    nowConnection.Close();
                }
                if (line_texbox.Text == "P71" || line_texbox.Text == "P")
                {
                    nowConnection.Open();//開啟連線
                    using (SqlCommand command71 = new SqlCommand())
                    {
                        command71.CommandText = Pxx(tmp_start.AddDays(i).Year.ToString() + tmp_start.AddDays(i).Month.ToString("00") + tmp_start.AddDays(i).Day.ToString("00"),"71");
                        command71.Connection = nowConnection;//資料庫連接
                        SqlDataReader dr71 = command71.ExecuteReader();//執行並回傳DataReader    
                        if (dr71.HasRows)//檢查是否有資料列
                        {
                            while (dr71.Read())
                            {
                                dt.Rows.Add(dr71[0].ToString(), dr71[1].ToString(), dr71[2].ToString(), dr71[3].ToString(), dr71[4].ToString(), dr71[5].ToString(), dr71[6].ToString(), dr71[7].ToString());
                            }
                        }
                    }
                    nowConnection.Close();
                }
                if (line_texbox.Text == "P81" || line_texbox.Text == "P")
                {
                    nowConnection.Open();//開啟連線
                    using (SqlCommand command81 = new SqlCommand())
                    {
                        command81.CommandText = Pxx(tmp_start.AddDays(i).Year.ToString() + tmp_start.AddDays(i).Month.ToString("00") + tmp_start.AddDays(i).Day.ToString("00"),"81");
                        command81.Connection = nowConnection;//資料庫連接
                        SqlDataReader dr81 = command81.ExecuteReader();//執行並回傳DataReader    
                        if (dr81.HasRows)//檢查是否有資料列
                        {
                            while (dr81.Read())
                            {
                                dt.Rows.Add(dr81[0].ToString(), dr81[1].ToString(), dr81[2].ToString(), dr81[3].ToString(), dr81[4].ToString(), dr81[5].ToString(), dr81[6].ToString(), dr81[7].ToString());
                            }
                        }
                    }
                    nowConnection.Close();
                }
            }
        }
        GridView999.DataSource = dt;
        GridView999.DataBind();
    }
    private string Pxx(string date,string line)
    {
        string new_str = string.Format(
        "SELECT XC003'預產日',XC015'生產線別',(CONVERT(VARCHAR(50),CONVERT(FLOAT(50),ROUND(AVG(XD031)*100,2)))+'%')'預估成品率(平均)'" +
        ",convert(nvarchar(50),convert(float(50),round((SELECT SUM(TG013*TG200*MB204) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 left join MOCXF on XF001=TG201 and XF002=TG204 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='{0}' and XF003='{1}' group by XF003)/CONVERT(nvarchar(50),(SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029='1' AND XF004='{0}' AND XF020='Y' and XF003='{1}' group by XF003))*100,2)))+'%'AS'實際成品率'" +
        ",(select '('+XF007+'用錠)'+convert(varchar,SUM(XG007))+' ' from MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029 in ('1') AND  XF004='{0}' AND XF020='Y' and XF003='{1}' group by XF023,XF007 order by XF007 FOR XML PATH(''))" +
        ",convert(nvarchar(50),convert(float(50),round((SELECT SUM(TG013*TG200*MB204) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 left join MOCXF on XF001=TG201 and XF002=TG204 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='{0}' and XF003='{1}' group by XF003)/CONVERT(nvarchar(50),(SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029 in('1','2') AND XF004='{0}' AND XF020='Y' and XF003='{1}' group by XF003))*100,2)))+'%'AS'實際成品率'" +
        ",(select '('+XF007+'用錠)'+convert(varchar,SUM(XG007))+' ' from MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029 in ('1','2') AND  XF004='{0}' AND XF020='Y' and XF003='{1}' group by XF023,XF007 order by XF007 FOR XML PATH(''))"+
        ",(SELECT '('+TF200+'入庫重)'+convert(nvarchar(100),convert(float,SUM(TG013*TG200*MB204))) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 left join MOCXF on XF001=TG201 and XF002=TG204 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='{0}' and XF003='{1}' group by TF200 order by TF200 FOR XML PATH(''))" +
        " FROM MOCXC LEFT JOIN MOCXD ON XC001=XD001 WHERE XC010='Y' AND XC017='1' AND XC003='{0}' AND XC015 = 'P{1}' GROUP BY XC003,XC015", date,line);
        return new_str;
    }
    private string P41(string str)
    {
        return Pxx(str,"41");
    }
    private string P42(string str)
    {
        string new_str =
        "SELECT XC003'預產日',XC015'生產線別',(CONVERT(VARCHAR(50),CONVERT(FLOAT(50),ROUND(AVG(XD031)*100,2)))+'%')'預估成品率(平均)'" +
        ",convert(nvarchar(50),convert(float(50),round((SELECT SUM(TG013*TG200*MB204) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='N'))/CONVERT(nvarchar(50),(SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029='1' AND XF004='" + str + "' AND XF020='Y' AND (XF007='N')))*100,2)))+'%'AS'實際成品率'" +
        ",'(N用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029='1' AND XF004='" + str + "' AND XF020='Y' AND (XF007='N')),0))" +
        ",convert(nvarchar(50),convert(float(50),round((SELECT SUM(TG013*TG200*MB204) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='N'))/CONVERT(nvarchar(50),(SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029 in ('1','2') AND XF004='" + str + "' AND XF020='Y' AND (XF007='N')))*100,2)))+'%'AS'實際成品率'" +
        ",'(N用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029 in ('1','2') AND XF004='" + str + "' AND XF020='Y' AND (XF007='N')),0))" +
        ",'(N入庫重)'+CONVERT(NVARCHAR(50),ISNULL((SELECT convert(float(50),SUM(TG013*TG200*MB204)) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='N')),0))" +        
        "FROM MOCXC LEFT JOIN MOCXD ON XC001=XD001 WHERE XC010='Y' AND XC017='1' AND XC003='" + str + "' AND XC015 = 'P42' GROUP BY XC003,XC015";
        return new_str;
    }
    private string P51(string str)
    {
        string new_str =
        "SELECT XC003'預產日',XC015'生產線別',(CONVERT(VARCHAR(50),CONVERT(FLOAT(50),ROUND(AVG(XD031)*100,2)))+'%')'預估成品率(平均)'" +
        ",convert(nvarchar(50),convert(float(50),round((SELECT SUM(TG013*TG200*MB204) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='H' OR TF200='C'))/CONVERT(nvarchar(50),(SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029='1' AND XF004='" + str + "' AND XF020='Y' AND (XF007='H' OR XF007='C')))*100,2)))+'%'AS'實際成品率'" +
        ",'(H用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029='1' AND XF004='" + str + "' AND XF020='Y' AND (XF007='H')),0))" +
        "+'  ●  (C用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029='1' AND XF004='" + str + "' AND XF020='Y' AND (XF007='C')),0))" +
        ",convert(nvarchar(50),convert(float(50),round((SELECT SUM(TG013*TG200*MB204) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='H' OR TF200='C'))/CONVERT(nvarchar(50),(SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029 in ('1','2') AND XF004='" + str + "' AND XF020='Y' AND (XF007='H' OR XF007='C')))*100,2)))+'%'AS'實際成品率'" +
        ",'(H用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029 in ('1','2') AND XF004='" + str + "' AND XF020='Y' AND (XF007='H')),0))" +
        "+'  ●  (C用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029 in ('1','2') AND XF004='" + str + "' AND XF020='Y' AND (XF007='C')),0))" +
        ",'(H入庫重)'+CONVERT(NVARCHAR(50),ISNULL((SELECT convert(float(50),SUM(TG013*TG200*MB204)) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='H')),0))" +
        "+'  ●  (C入庫重)'+CONVERT(NVARCHAR(50),ISNULL((SELECT convert(float(50),SUM(TG013*TG200*MB204)) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='C')),0))" +
        "FROM MOCXC LEFT JOIN MOCXD ON XC001=XD001 WHERE XC010='Y' AND XC017='1' AND XC003='" + str + "' AND XC015 = 'P51' GROUP BY XC003,XC015";
        return new_str;
    }
    private string P52(string str)
    {
        string new_str =
        "SELECT XC003'預產日',XC015'生產線別',(CONVERT(VARCHAR(50),CONVERT(FLOAT(50),ROUND(AVG(XD031)*100,2)))+'%')'預估成品率(平均)'" +
        ",convert(nvarchar(50),convert(float(50),round((SELECT SUM(TG013*TG200*MB204) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='A' OR TF200='B'))/CONVERT(nvarchar(50),(SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029='1' AND XF004='" + str + "' AND XF020='Y' AND (XF007='A' OR XF007='B')))*100,2)))+'%'AS'實際成品率'" +
        ",'(A用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029='1' AND  XF004='" + str + "' AND XF020='Y' AND (XF007='A')),0))" +
        "+'  ●  (B用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029='1' AND XF004='" + str + "' AND XF020='Y' AND (XF007='B')),0))" +
        ",convert(nvarchar(50),convert(float(50),round((SELECT SUM(TG013*TG200*MB204) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='A' OR TF200='B'))/CONVERT(nvarchar(50),(SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029 in ('1','2') AND XF004='" + str + "' AND XF020='Y' AND (XF007='A' OR XF007='B')))*100,2)))+'%'AS'實際成品率'" +
        ",'(A用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029 in ('1','2') AND  XF004='" + str + "' AND XF020='Y' AND (XF007='A')),0))" +
        "+'  ●  (B用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029 in ('1','2') AND XF004='" + str + "' AND XF020='Y' AND (XF007='B')),0))" +
        ",'(A入庫重)'+CONVERT(NVARCHAR(50),ISNULL((SELECT convert(float,SUM(TG013*TG200*MB204)) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='A')),0))" +
        "+'  ●  (B入庫重)'+CONVERT(NVARCHAR(50),ISNULL((SELECT convert(float,SUM(TG013*TG200*MB204)) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='B')),0))" +
        "FROM MOCXC LEFT JOIN MOCXD ON XC001=XD001 WHERE XC010='Y' AND XC017='1' AND XC003='" + str + "' AND XC015 = 'P52' GROUP BY XC003,XC015";
        return new_str;
    }
    private string P53(string str)
    {
        string new_str =
        "SELECT XC003'預產日',XC015'生產線別',(CONVERT(VARCHAR(50),CONVERT(FLOAT(50),ROUND(AVG(XD031)*100,2)))+'%')'預估成品率(平均)'" +
        ",convert(nvarchar(50),convert(float(50),round((SELECT SUM(TG013*TG200*MB204) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='L'))/CONVERT(nvarchar(50),(SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029='1' AND XF004='" + str + "' AND XF020='Y' AND (XF007='L')))*100,2)))+'%'AS'實際成品率'" +
        ",'(L用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029='1' AND  XF004='" + str + "' AND XF020='Y' AND (XF007='L')),0))" +
        ",convert(nvarchar(50),convert(float(50),round((SELECT SUM(TG013*TG200*MB204) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='L'))/CONVERT(nvarchar(50),(SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029 in ('1','2') AND XF004='" + str + "' AND XF020='Y' AND (XF007='L')))*100,2)))+'%'AS'實際成品率'" +
        ",'(L用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029 in ('1','2') AND  XF004='" + str + "' AND XF020='Y' AND (XF007='L')),0))" +
        ",'(L入庫重)'+CONVERT(NVARCHAR(50),ISNULL((SELECT convert(float,SUM(TG013*TG200*MB204)) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='L')),0))" +        
        "FROM MOCXC LEFT JOIN MOCXD ON XC001=XD001 WHERE XC010='Y' AND XC017='1' AND XC003='" + str + "' AND XC015 = 'P53' GROUP BY XC003,XC015";
        return new_str;
    }
    private string P71(string str)
    {
        string new_str =
        "SELECT XC003'預產日',XC015'生產線別',(CONVERT(VARCHAR(50),CONVERT(FLOAT(50),ROUND(AVG(XD031)*100,2)))+'%')'預估成品率(平均)'" +
        ",convert(nvarchar(50),convert(float(50),round((SELECT SUM(TG013*TG200*MB204) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='E' OR TF200='J' OR TF200='D'))/CONVERT(nvarchar(50),(SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029='1' AND XF004='" + str + "' AND XF020='Y' AND (XF007='E' OR XF007='J' OR XF007='D')))*100,2)))+'%'AS'實際成品率'" +
        ",'(E用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029='1' AND XF004='" + str + "' AND XF020='Y' AND (XF007='E')),0))" +
        "+'  ●  (J用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029='1' AND XF004='" + str + "' AND XF020='Y' AND (XF007='J')),0))" +
        "+'  ●  (D用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029='1' AND XF004='" + str + "' AND XF020='Y' AND (XF007='D')),0))" +
        ",convert(nvarchar(50),convert(float(50),round((SELECT SUM(TG013*TG200*MB204) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='E' OR TF200='J' OR TF200='D'))/CONVERT(nvarchar(50),(SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029 in ('1','2') AND XF004='" + str + "' AND XF020='Y' AND (XF007='E' OR XF007='J' OR XF007='D')))*100,2)))+'%'AS'實際成品率'" +
        ",'(E用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029 in ('1','2') AND XF004='" + str + "' AND XF020='Y' AND (XF007='E')),0))" +
        "+'  ●  (J用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029 in ('1','2') AND XF004='" + str + "' AND XF020='Y' AND (XF007='J')),0))" +
        "+'  ●  (D用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029 in ('1','2') AND XF004='" + str + "' AND XF020='Y' AND (XF007='D')),0))" +
        ",'(E入庫重)'+CONVERT(NVARCHAR(50),ISNULL((SELECT convert(float,SUM(TG013*TG200*MB204)) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='E')),0))" +
        "+'  ●  (J入庫重)'+CONVERT(NVARCHAR(50),ISNULL((SELECT convert(float,SUM(TG013*TG200*MB204)) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='J')),0))" +
        "+'  ●  (D入庫重)'+CONVERT(NVARCHAR(50),ISNULL((SELECT convert(float,SUM(TG013*TG200*MB204)) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='D')),0))" +
        "FROM MOCXC LEFT JOIN MOCXD ON XC001=XD001 WHERE XC010='Y' AND XC017='1' AND XC003='" + str + "' AND XC015 = 'P71' GROUP BY XC003,XC015";
        return new_str;
    }
    private string P81(string str)
    {
        string new_str =
        "SELECT XC003'預產日',XC015'生產線別',(CONVERT(VARCHAR(50),CONVERT(FLOAT(50),ROUND(AVG(XD031)*100,2)))+'%')'預估成品率(平均)'" +
        ",convert(nvarchar(50),convert(float(50),round((SELECT SUM(TG013*TG200*MB204) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='F' OR TF200='K'))/CONVERT(nvarchar(50),(SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029='1' AND XF004='" + str + "' AND XF020='Y' AND (XF007='F' OR XF007='K')))*100,2)))+'%'AS'實際成品率'" +
        ",'(F用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029='1' AND XF004='" + str + "' AND XF020='Y' AND (XF007='F')),0))" +
        "+'  ●  (K用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029='1' AND XF004='" + str + "' AND XF020='Y' AND (XF007='K')),0))" +
        ",convert(nvarchar(50),convert(float(50),round((SELECT SUM(TG013*TG200*MB204) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='F' OR TF200='K'))/CONVERT(nvarchar(50),(SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029 in ('1','2') AND XF004='" + str + "' AND XF020='Y' AND (XF007='F' OR XF007='K')))*100,2)))+'%'AS'實際成品率'" +
        ",'(F用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029 in ('1','2') AND XF004='" + str + "' AND XF020='Y' AND (XF007='F')),0))" +
        "+'  ●  (K用錠)'+CONVERT(NVARCHAR(50),ISNULL((SELECT SUM(XG007) FROM MOCXF LEFT JOIN MOCXG ON XF001=XG001 AND XF002=XG002 WHERE XF029 in ('1','2') AND XF004='" + str + "' AND XF020='Y' AND (XF007='K')),0))" +
        ",'(F入庫重)'+CONVERT(NVARCHAR(50),ISNULL((SELECT convert(float,SUM(TG013*TG200*MB204)) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='F')),0))" +
        "+'  ●  (K入庫重)'+CONVERT(NVARCHAR(50),ISNULL((SELECT convert(float,SUM(TG013*TG200*MB204)) FROM MOCTF LEFT JOIN MOCTG ON TF001=TG001 AND TF002=TG002 LEFT JOIN INVMB ON TG004=MB001 WHERE TF001='580A' AND TF006='Y' AND TF012='" + str + "' AND (TF200='K')),0))" +
        "FROM MOCXC LEFT JOIN MOCXD ON XC001=XD001 WHERE XC010='Y' AND XC017='1' AND XC003='" + str + "' AND XC015 = 'P81' GROUP BY XC003,XC015";
        return new_str;
    }

    protected void GridView999_PreRender(object sender, EventArgs e)
    {
        int i = 1;
        foreach (GridViewRow count in GridView999.Rows)
        {
            //比對如果名稱如果相同就合
            if (count.RowIndex != 0)
            {
                if (count.Cells[0].Text.Trim() == GridView999.Rows[(count.RowIndex - i)].Cells[0].Text.Trim())
                {
                    GridView999.Rows[(count.RowIndex - i)].Cells[0].RowSpan += 1;
                    //GridView2.Rows[(count.RowIndex - i)].Cells[1].RowSpan += 1;
                    count.Cells[0].Visible = false;
                    //count.Cells[1].Visible = false;
                    i++;
                }
                else
                {
                    GridView999.Rows[(count.RowIndex)].Cells[0].RowSpan += 1;
                    //GridView2.Rows[(count.RowIndex)].Cells[1].RowSpan += 1;
                    i = 1;
                }

            }
            else
            {
                count.Cells[0].RowSpan = 1;
                //count.Cells[1].RowSpan = 1;
            }
        }
    }
}