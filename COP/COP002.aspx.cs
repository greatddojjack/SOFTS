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
using System.Web.UI.HtmlControls;
using System.Net;
using NPOI.HSSF.UserModel;
using NPOI.HPSF;
using NPOI.POIFS.FileSystem;
using NPOI.HSSF.Record;
using NPOI.HSSF.Util;
using NPOI.SS.Util;
using NPOI.SS.UserModel;

public partial class COP_Default : System.Web.UI.Page
{
    string CNStr = "data source=192.168.0.188;initial catalog=GH;User id=reader;Password=";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            
        }
    }

    protected void excel_Button_Click(object sender, EventArgs e)
    {
        DataTable dt = GetQuery("2210", ordervalue.Value, chk_isbetween.Checked);
        if (dt.Columns.Count > 0)
        {
            getExcel(dt);
        }
    }
    protected DataTable GetQuery(string TC001, string TC002, bool isbetween)
    {
        try
        {
            string querystring = "";
            SqlParameter[] p;
            if (isbetween == true)
            {
                string[] tmpTC002 = TC002.Split(',');
                p = new SqlParameter[3];
                p[0] = new SqlParameter("@TC001", TC001);
                p[1] = new SqlParameter("@TC002_1", tmpTC002[0]);
                p[2] = new SqlParameter("@TC002_2", tmpTC002[1]);
                querystring = string.Format("select MA002+TC004 '客戶',TC002+'-'+TD003 '訂單號碼','' as'備註','' as '圖檔','' as '點料','' as'儲位',MB008+'---'+left(cast(MB204 as nvarchar(10)),4) as'要隱藏',MB008 as '型號',MB204 as '長度',TD008-TD009 as '數量','' as '實出','' as '裁切',TC012 as '客戶單號' from COPTC left join COPTD on TC001=TD001 and TC002=TD002 left join COPMA on MA001=TC004 left join INVMB on MB001=TD004 where TD008-TD009>0 and TD016='N' and TC027='Y' and (TC001=@TC001 ) and  (TC002 Between @TC002_1 and @TC002_2)");
            }
            else
            {
                p = new SqlParameter[1];
                p[0] = new SqlParameter("@TC001", TC001);
                querystring = string.Format("select MA002+TC004 '客戶',TC002+'-'+TD003 '訂單號碼','' as'備註','' as '圖檔','' as '點料','' as'儲位',MB008+'---'+left(cast(MB204 as nvarchar(10)),4) as'要隱藏',MB008 as '型號',MB204 as '長度',TD008-TD009 as '數量','' as '實出','' as '裁切',TC012 as '客戶單號' from COPTC left join COPTD on TC001=TD001 and TC002=TD002 left join COPMA on MA001=TC004 left join INVMB on MB001=TD004 where TD008-TD009>0 and TD016='N' and TC027='Y' and (TC001=@TC001 ) and  (TC002 in ({0}))", TC002);

            }
            DataTable dt = SqlDb.GetTable(querystring, CommandType.Text, p);
            return dt;
        }
        catch (Exception e)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + e.Message + "'");
            return null;
        }
    }
    protected void getExcel(DataTable dt)
    {
        HSSFWorkbook book = new HSSFWorkbook();
        ISheet sheet = book.CreateSheet("Sheet1");        
        sheet.DisplayGridlines = true;
        sheet.IsPrintGridlines = true;
        IRow row = sheet.CreateRow(0);
        row.HeightInPoints = 20;

        ICell cell = row.CreateCell(0);
        //set the title of the sheet
        cell.SetCellValue("廣翰實業股份有限公司 備料單");

        ICellStyle style = book.CreateCellStyle();
        style.Alignment = HorizontalAlignment.Center;
        style.VerticalAlignment = VerticalAlignment.Center;
        //create a font style
        IFont font = book.CreateFont();
        font.FontHeightInPoints = 16;
        font.FontName = "新細明體";
        style.SetFont(font);
        cell.CellStyle = style;
        //merged cells on single row
        //ATTENTION: don't use Region class, which is obsolete
        sheet.AddMergedRegion(new CellRangeAddress(0, 0, 0, 11));
        
        row = sheet.CreateRow(1);
        row.HeightInPoints = 12;
        cell = row.CreateCell(0);
        //set the title of the sheet
        cell.SetCellValue("製表人：______");
        ICellStyle style2 = book.CreateCellStyle();
        font = book.CreateFont();
        font.FontHeightInPoints = 10;
        font.FontName = "新細明體";
        style2.SetFont(font);
        style2.Alignment = HorizontalAlignment.Right;
        cell.CellStyle = style2;
        sheet.AddMergedRegion(new CellRangeAddress(1, 1, 0, 11));

        row = sheet.CreateRow(2);
        for (int i = 0; i < dt.Columns.Count; i++)
        {            
            ICellStyle cellStyle1 = book.CreateCellStyle();
            //Border
            cellStyle1.BorderBottom = NPOI.SS.UserModel.BorderStyle.Thin;
            cellStyle1.BottomBorderColor = NPOI.HSSF.Util.HSSFColor.Black.Index;
            cellStyle1.BorderLeft = NPOI.SS.UserModel.BorderStyle.Thin;
            cellStyle1.LeftBorderColor = NPOI.HSSF.Util.HSSFColor.Black.Index;
            cellStyle1.BorderRight = NPOI.SS.UserModel.BorderStyle.Thin;
            cellStyle1.RightBorderColor = NPOI.HSSF.Util.HSSFColor.Black.Index;
            cellStyle1.BorderTop = NPOI.SS.UserModel.BorderStyle.Thin;
            cellStyle1.TopBorderColor = NPOI.HSSF.Util.HSSFColor.Black.Index;
            if ((i>=0 && i<=2) || (i >= 7 && i <= 9))
            {
                cellStyle1.FillForegroundColor = NPOI.HSSF.Util.HSSFColor.Yellow.Index;
            }
            else if(i==3)
            {
                cellStyle1.FillForegroundColor = NPOI.HSSF.Util.HSSFColor.Green.Index;
            }
            else if((i>=4 && i<=6) || (i>=10 && i<=11))
            {
                cellStyle1.FillForegroundColor = NPOI.HSSF.Util.HSSFColor.Lavender.Index;
            }
            else
            {
                cellStyle1.FillForegroundColor = NPOI.HSSF.Util.HSSFColor.White.Index;
            }            
            cellStyle1.FillPattern = FillPattern.SolidForeground;
            cellStyle1.DataFormat = HSSFDataFormat.GetBuiltinFormat("@");
            
            font = book.CreateFont();
            font.Color = NPOI.HSSF.Util.HSSFColor.Black.Index;
            cellStyle1.SetFont(font);
            ICell headercell = row.CreateCell(i);
            headercell.CellStyle = cellStyle1;
            headercell.SetCellValue(dt.Columns[i].ColumnName);
        }
        
        sheet.SetColumnWidth(1, 20 * 256);//訂單
        sheet.SetColumnWidth(2, 15*256);//備註
        sheet.SetColumnWidth(3, 15*256);//圖檔
        sheet.SetColumnWidth(6, 15 * 256);//要隱藏
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            HSSFPatriarch patriarch = (HSSFPatriarch)sheet.CreateDrawingPatriarch();
            ICellStyle cellStyle2 = book.CreateCellStyle();
            cellStyle2.Alignment = HorizontalAlignment.Left;
            cellStyle2.VerticalAlignment = VerticalAlignment.Center;
            //Border
            cellStyle2.BorderBottom = NPOI.SS.UserModel.BorderStyle.Thin;
            cellStyle2.BottomBorderColor = HSSFColor.Black.Index;
            cellStyle2.BorderLeft = NPOI.SS.UserModel.BorderStyle.Thin;
            cellStyle2.LeftBorderColor = HSSFColor.Black.Index;
            cellStyle2.BorderRight = NPOI.SS.UserModel.BorderStyle.Thin;
            cellStyle2.RightBorderColor = HSSFColor.Black.Index;
            cellStyle2.BorderTop = NPOI.SS.UserModel.BorderStyle.Thin;
            cellStyle2.TopBorderColor = HSSFColor.Black.Index;
            IRow row2 = sheet.CreateRow(i + 3);
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                cell = row2.CreateCell(j);
                cell.CellStyle = cellStyle2;
                if (dt.Columns[j].ColumnName == "圖檔")
                {
                    try
                    {                        
                        //create the anchor
                        HSSFClientAnchor anchor = new HSSFClientAnchor(0, 0, 0, 0, j, row2.RowNum, j, row2.RowNum);
                        anchor.AnchorType = AnchorType.MoveAndResize;
                        //load the picture and get the picture index in the workbook
                        HSSFPicture picture = (HSSFPicture)patriarch.CreatePicture(anchor, LoadImage("http://192.168.0.188/GH_Image/thumb/"+ dt.Rows[i][7].ToString() + ".jpg", book));
                        var size = picture.GetImageDimension();
                        row2.HeightInPoints = size.Height;                        
                        //Reset the image to the original size.
                        picture.Resize(1);
                        anchor.Dx1 = 5;
                        anchor.Dy1 = 5;
                    }
                    catch (Exception ex)
                    {
                        // 圖片載入失敗，顯示錯誤訊息
                        cell.SetCellValue(ex.Message);
                    }
                }
                else if (dt.Columns[j].ColumnName == "數量" || dt.Columns[j].ColumnName == "長度")
                {
                    cell.SetCellValue(Convert.ToDouble(dt.Rows[i][j].ToString()));                    
                }
                else
                {
                    cell.SetCellValue(dt.Rows[i][j].ToString());                    
                }
                
            }
        }


        //寫入到客戶端
        System.IO.MemoryStream ms = new System.IO.MemoryStream();
        book.Write(ms);
        Response.AddHeader("Content-Disposition", string.Format("attachment; filename={0}_COP02.xls", DateTime.Now.ToString("yyyyMMddHHmmss")));
        Response.BinaryWrite(ms.ToArray());
        book = null;
        ms.Close();
        ms.Dispose();
    }
    public static int LoadImage(string path, HSSFWorkbook wb)
    {
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(path);
        HttpWebResponse response = (HttpWebResponse)request.GetResponse();
        Stream file = response.GetResponseStream();
        //FileStream file = new FileStream(path, FileMode.Open, FileAccess.Read);
        //byte[] buffer = new byte[file.Length];
        //file.Read(buffer, 0, (int)file.Length);
        byte[] array;
        using (var ms = new MemoryStream())
        {
            file.CopyTo(ms);
            array = ms.ToArray();
        }
        int i= wb.AddPicture(array, PictureType.JPEG);
        return i;

    }
}