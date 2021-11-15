using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Data.OleDb;

public static class SqlDb
{
    public static string ConnectionString = GetConnectionString();

    private static string GetConnectionString()
    {
        return ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
    }

    public static SqlDataReader ExecuteReader(string cmdText)
    {
        return ExecuteReader(cmdText, CommandType.Text, null);
    }

    public static SqlDataReader ExecuteReader(string cmdText, SqlParameter[] parameters)
    {
        return ExecuteReader(cmdText, CommandType.Text, parameters);
    }

    public static SqlDataReader ExecuteReader(string cmdText, CommandType cmdType)
    {
        return ExecuteReader(cmdText, cmdType, null);
    }

    public static SqlDataReader ExecuteReader(string cmdText, CommandType cmdType, SqlParameter[] parameters)
    {
        SqlConnection conn = new SqlConnection(ConnectionString);
        SqlCommand cmd = new SqlCommand(cmdText, conn);
        try
        {
            cmd.CommandType = cmdType;
            if (parameters != null)
            {
                foreach (SqlParameter parm in parameters)
                    cmd.Parameters.Add(parm);
            }
            conn.Open();
            SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
            cmd.Parameters.Clear();
            return rdr;
        }
        catch
        {
            conn.Close();
            throw;
        }
               
    }
    // GetTable
    public static DataTable GetTable(string cmdText)
    {
        return GetTable(cmdText, CommandType.Text, null,"");
    }

    public static DataTable GetTable(string cmdText, SqlParameter[] parameters)
    {
        return GetTable(cmdText, CommandType.Text, parameters, "");
    }
    public static DataTable GetOleDbTable(string cmdText, OleDbParameter[] parameters)
    {
        return GetOleDbTable(cmdText, CommandType.Text, parameters, "");
    }

    public static DataTable GetTable(string cmdText, CommandType cmdType)
    {
        return GetTable(cmdText, cmdType, null, "");
    }

    public static DataTable GetTable(string cmdText, CommandType cmdType, SqlParameter[] parameters)
    {
        return GetTable(cmdText, cmdType, parameters, "");
    }
    public static DataTable GetOleDbTable(string cmdText, CommandType cmdType, OleDbParameter[] parameters)
    {
        return GetOleDbTable(cmdText, cmdType, parameters, "");
    }

    public static DataSet GetDataSet(string cmdText, CommandType cmdType, SqlParameter[] parameters)
    {
        DataSet ds = null;
        using (SqlConnection conn = new SqlConnection(ConnectionString))
        {
            using (SqlCommand cmd = new SqlCommand(cmdText, conn))
            {
                cmd.CommandType = cmdType;
                if (parameters != null)
                {
                    foreach (SqlParameter parm in parameters)
                        cmd.Parameters.Add(parm);
                }
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = cmd;
                ds = new DataSet();
                adapter.Fill(ds);
                adapter.Dispose();
            }
            return ds;
           
        }
    }
    public static DataSet GetOldDbDataSet(string cmdText, CommandType cmdType, OleDbParameter[] parameters)
    {
        DataSet ds = null;
        using (OleDbConnection conn = new OleDbConnection(ConnectionString))
        {
            using (OleDbCommand cmd = new OleDbCommand(cmdText, conn))
            {
                cmd.CommandType = cmdType;
                if (parameters != null)
                {
                    foreach (OleDbParameter parm in parameters)
                        cmd.Parameters.Add(parm);
                }
                OleDbDataAdapter adapter = new OleDbDataAdapter();
                adapter.SelectCommand = cmd;
                ds = new DataSet();
                adapter.Fill(ds);
                adapter.Dispose();
            }
            return ds;

        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="cmdText"></param>
    /// <param name="cmdType"></param>
    /// <param name="parameters"></param>
    /// <returns></returns>
    public static DataTable GetTable(string cmdText, CommandType cmdType, SqlParameter[] parameters,string connString)
    {
        DataTable dt = null;
        if(connString=="")
        {
            connString = ConnectionString;
        }
        using (SqlConnection conn = new SqlConnection(connString))
        {
            using (SqlCommand cmd = new SqlCommand(cmdText, conn))
            {
                cmd.CommandType = cmdType;
                if (parameters != null)
                {
                    foreach (SqlParameter parm in parameters)
                        cmd.Parameters.Add(parm);
                }
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = cmd;
                dt = new DataTable();
                adapter.Fill(dt);
                adapter.Dispose();
                cmd.Parameters.Clear();
            }
        }
        return dt;
    }
    public static DataTable GetOleDbTable(string cmdText, CommandType cmdType, OleDbParameter[] parameters, string connString)
    {
        DataTable dt = null;
        if (connString == "")
        {
            connString = ConnectionString;
        }
        using (OleDbConnection conn = new OleDbConnection(connString))
        {
            using (OleDbCommand cmd = new OleDbCommand(cmdText, conn))
            {
                cmd.CommandType = cmdType;
                if (parameters != null)
                {
                    foreach (OleDbParameter parm in parameters)
                        cmd.Parameters.Add(parm);
                }
                OleDbDataAdapter adapter = new OleDbDataAdapter();
                adapter.SelectCommand = cmd;
                dt = new DataTable();
                adapter.Fill(dt);
                adapter.Dispose();
                cmd.Parameters.Clear();
            }
        }
        return dt;
    }
    // 交易
    public static int ExecuteSqlTransaction(string cmdText)
    {
        return ExecuteSqlTransaction(cmdText, CommandType.Text, null);
    }

    public static int ExecuteSqlTransaction(string cmdText, SqlParameter[] parameters)
    {
        return ExecuteSqlTransaction(cmdText, CommandType.Text, parameters);
    }

    public static int ExecuteSqlTransaction(string cmdText, CommandType cmdType)
    {
        return ExecuteSqlTransaction(cmdText, cmdType, null);
    }

    public static int ExecuteSqlTransaction(string cmdText, CommandType cmdType, SqlParameter[] parameters)
    {
        int result = 0;
        using (SqlConnection conn = new SqlConnection(ConnectionString))
        {
            conn.Open();
            SqlCommand cmd = conn.CreateCommand();
            SqlTransaction transaction;
            // Start a local transaction.
            transaction = conn.BeginTransaction("SampleTransaction");
            // Must assign both transaction object and connection 
            // to Command object for a pending local transaction
            cmd.Connection = conn;
            cmd.Transaction = transaction;

            try
            {
                cmd.CommandText = cmdText;
                cmd.CommandType = cmdType;
                if (parameters != null)
                {
                    foreach (SqlParameter parm in parameters)
                        cmd.Parameters.Add(parm);
                }
                result = cmd.ExecuteNonQuery();
                // Attempt to commit the transaction.
                transaction.Commit();
            }
            catch (Exception )
            {
                result = -1;
                // Attempt to roll back the transaction. 
                try
                {
                    transaction.Rollback();
                }
                catch (Exception )
                {
                    result = -1;
                }
            }
        }
        return result;
    }
    // NonQuery
    public static int ExecuteNonQuery(string cmdText)
    {
        return ExecuteNonQuery(cmdText, CommandType.Text, null);
    }

    public static int ExecuteNonQuery(string cmdText, SqlParameter[] parameters)
    {
        return ExecuteNonQuery(cmdText, CommandType.Text, parameters);
    }
    public static int ExecuteOleDbNonQuery(string cmdText, OleDbParameter[] parameters,string connString)
    {
        return ExecuteOleDbNonQuery(cmdText, CommandType.Text, parameters,connString);
    }

    public static int ExecuteNonQuery(string cmdText, CommandType cmdType)
    {
        return ExecuteNonQuery(cmdText, cmdType, null);
    }

    public static int ExecuteNonQuery(string cmdText, CommandType cmdType, SqlParameter[] parameters)
    {
        int result = 0;
        using (SqlConnection conn = new SqlConnection(ConnectionString))
        {
            using (SqlCommand cmd = new SqlCommand(cmdText, conn))
            {
                try
                {
                    cmd.CommandType = cmdType;
                    if (parameters != null)
                    {
                        foreach (SqlParameter parm in parameters)
                            cmd.Parameters.Add(parm);
                    }
                    conn.Open();

                    result = cmd.ExecuteNonQuery();
                }
                catch (Exception )
                {
                    //NLog.LogManager.GetCurrentClassLogger().Fatal(ex);
                }

            }
        }
        return result;
    }
    public static int ExecuteOleDbNonQuery(string cmdText, CommandType cmdType, OleDbParameter[] parameters,string connString)
    {
        int result = 0;
        using (OleDbConnection conn = new OleDbConnection(connString))
        {
            using (OleDbCommand cmd = new OleDbCommand(cmdText, conn))
            {
                try
                {
                    cmd.CommandType = cmdType;
                    if (parameters != null)
                    {
                        foreach (OleDbParameter parm in parameters)
                            cmd.Parameters.Add(parm);
                    }
                    conn.Open();

                    result = cmd.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    //NLog.LogManager.GetCurrentClassLogger().Fatal(ex);
                }

            }
        }
        return result;
    }
    // ExecuteScalar
    public static object ExecuteScalar(string cmdText)
    {
        return ExecuteScalar(cmdText, CommandType.Text, null);
    }

    public static object ExecuteScalar(string cmdText, SqlParameter[] parameters)
    {
        return ExecuteScalar(cmdText, CommandType.Text, parameters);
    }

    public static object ExecuteScalar(string cmdText, CommandType cmdType)
    {
        return ExecuteScalar(cmdText, cmdType, null);
    }

    public static object ExecuteScalar(string cmdText, CommandType cmdType, SqlParameter[] parameters)
    {
        object result = null;
        using (SqlConnection conn = new SqlConnection(ConnectionString))
        {
            using (SqlCommand cmd = new SqlCommand(cmdText, conn))
            {
                cmd.CommandType = cmdType;
                if (parameters != null)
                {
                    foreach (SqlParameter parm in parameters)
                        cmd.Parameters.Add(parm);
                }
                conn.Open();

                if (cmd.ExecuteScalar() != null)
                    result = cmd.ExecuteScalar();
            }
        }
        return result;
    }

}