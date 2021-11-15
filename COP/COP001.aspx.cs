using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class COP_COP001 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void DropDownList2_SelectedIndexChanged(object sender, EventArgs e)
    {
        //DropDownList1.DataBind();
        //DropDownList1.SelectedIndex = 0;
        DropDownList1.SelectedIndex = 0;
        GridView2.DataBind();
    }

    protected void DropDownList1_DataBound(object sender, EventArgs e)
    {
        //GridView1.DataBind();
    }

    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        //TextBox1.Text = DropDownList1.SelectedValue.ToString();   
        GridView2.DataBind();
    }

    protected void GridView2_PreRender(object sender, EventArgs e)
    {
        int i = 1;
        foreach (GridViewRow count in GridView2.Rows)
        {
            //比對如果名稱如果相同就合
            if (count.RowIndex != 0)
            {
                if (count.Cells[0].Text.Trim() == GridView2.Rows[(count.RowIndex - i)].Cells[0].Text.Trim())
                {
                    GridView2.Rows[(count.RowIndex - i)].Cells[0].RowSpan += 1;
                    //GridView2.Rows[(count.RowIndex - i)].Cells[1].RowSpan += 1;
                    count.Cells[0].Visible = false;
                    //count.Cells[1].Visible = false;
                    i++;
                }
                else
                {
                    GridView2.Rows[(count.RowIndex)].Cells[0].RowSpan += 1;
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