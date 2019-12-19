package beanie.util;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class ConnLocator {
	public static Connection getConnection() throws SQLException{
		DataSource ds = null;
		Connection con = null;
		
		try {
			Context context = new InitialContext();
			// java:comp/env 는 무조건 고정
			// jdbc/hb는 context.xml의 name과 반드시 같아야 한다.
			ds = (DataSource) context.lookup("java:comp/env/jdbc/hb");
			con = ds.getConnection();
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return con;
	}
}
