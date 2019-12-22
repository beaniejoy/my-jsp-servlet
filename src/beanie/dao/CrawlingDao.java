package beanie.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import beanie.dto.CrawlingDto;
import beanie.util.ConnLocator;

public class CrawlingDao {
	private static CrawlingDao single;

	private CrawlingDao() {

	}

	public static CrawlingDao getInstance() {
		if (single == null) {
			single = new CrawlingDao();
		}
		return single;
	}

	public boolean create(String coin) {
		boolean isSuccess = false;

		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = ConnLocator.getConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("CREATE TABLE ");
			sql.append(coin + "( ");
			sql.append("	dealdate DATE NOT NULL, ");
			sql.append("	opentime DOUBLE NOT NULL, ");
			sql.append("	high DOUBLE NOT NULL, ");
			sql.append("	low DOUBLE NOT NULL, ");
			sql.append("	endtime DOUBLE NOT NULL, ");
			sql.append("	vol BIGINT(20) NOT NULL, ");
			sql.append("	mcap BIGINT(20) NOT NULL, ");
			sql.append("	PRIMARY KEY (dealdate) ");
			sql.append(") ");
			sql.append("COLLATE='utf8_general_ci' ");

			pstmt = con.prepareStatement(sql.toString());

			pstmt.executeUpdate();

			isSuccess = true;

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (con != null)
					con.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		return isSuccess;
	}

	public boolean insert(CrawlingDto dto, String coin) {
		boolean isSuccess = false;

		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = ConnLocator.getConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("INSERT INTO ");
			sql.append(coin + "(dealdate, opentime, high, low, endtime, vol, mcap) ");
			sql.append("VALUES(?, ?, ?, ?, ?, ?, ?) ");

			pstmt = con.prepareStatement(sql.toString());
			int index = 0;
			pstmt.setString(++index, dto.getDate());
			pstmt.setDouble(++index, dto.getOpen());
			pstmt.setDouble(++index, dto.getHigh());
			pstmt.setDouble(++index, dto.getLow());
			pstmt.setDouble(++index, dto.getClose());
			pstmt.setLong(++index, dto.getVolume());
			pstmt.setLong(++index, dto.getMarketCap());

			pstmt.executeUpdate();

			isSuccess = true;

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (con != null)
					con.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		return isSuccess;
	}

	public boolean isThere(String date, String coin) {
		boolean isThere = false;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = ConnLocator.getConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("SELECT dealdate ");
			sql.append("FROM ");
			sql.append(coin + " ");
			sql.append("WHERE dealdate = ? ");

			pstmt = con.prepareStatement(sql.toString());

			int index = 0;
			pstmt.setString(++index, date);

			rs = pstmt.executeQuery();
			if (rs.next()) {
				isThere = true;
			} else {
				isThere = false;
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (con != null)
					con.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		return isThere;
	}

	public ArrayList<CrawlingDto> select(int start, int len, String sDate, String eDate, String coin) {
		ArrayList<CrawlingDto> list = new ArrayList<CrawlingDto>();

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = ConnLocator.getConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("SELECT dealdate, opentime, high, low, endtime, vol, mcap ");
			sql.append("FROM ");
			sql.append(coin + " ");
			sql.append("WHERE dealdate BETWEEN ? AND ? ");
			sql.append("ORDER BY dealdate DESC ");
			sql.append("LIMIT ?, ? ");

			pstmt = con.prepareStatement(sql.toString());

			int index = 0;
			pstmt.setString(++index, sDate);
			pstmt.setString(++index, eDate);
			pstmt.setInt(++index, start);
			pstmt.setInt(++index, len);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				index = 0;
				String date = rs.getString(++index);
				double open = rs.getDouble(++index);
				double high = rs.getDouble(++index);
				double low = rs.getDouble(++index);
				double end = rs.getDouble(++index);
				long vol = rs.getLong(++index);
				long mcap = rs.getLong(++index);
				list.add(new CrawlingDto(date, open, high, low, end, vol, mcap));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {

			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (con != null)
					con.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		return list;
	}

	public int getTotalRows(String sDate, String eDate, String coin) {
		int count = 0;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = ConnLocator.getConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("SELECT COUNT(dealdate)");
			sql.append("FROM ");
			sql.append(coin + " ");
			sql.append("WHERE dealdate BETWEEN ? AND ? ");

			pstmt = con.prepareStatement(sql.toString());
			int index = 0;
			pstmt.setString(++index, sDate);
			pstmt.setString(++index, eDate);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				index = 0;
				count = rs.getInt(++index);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {

			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (con != null)
					con.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return count;
	}

	public String getOldestDate(String coin) {
		Date date = null;
		String old = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = ConnLocator.getConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("SELECT MIN(dealdate) ");
			sql.append("FROM ");
			sql.append(coin + " ");

			pstmt = con.prepareStatement(sql.toString());
			rs = pstmt.executeQuery();

			if (rs.next()) {
				int index = 0;
				date = rs.getDate(++index);
			}
			Calendar c = Calendar.getInstance();
			c.setTime(date);

			int year = c.get(Calendar.YEAR);
			int month = c.get(Calendar.MONTH);
			int day = c.get(Calendar.DATE);

			StringBuffer result = new StringBuffer();
			result.append(year);
			if (month < 10) {
				result.append("0");
			}
			result.append(month);
			if (day < 10) {
				result.append("0");
			}
			result.append(day);

			old = result.toString();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {

			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (con != null)
					con.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		return old;
	}

}