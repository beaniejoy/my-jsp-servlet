package beanie.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
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
	
	public boolean insert(CrawlingDto dto) {
		boolean isSuccess = false;
		
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = ConnLocator.getConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("INSERT INTO bitcoin(dealdate, opentime, high, low, endtime, vol, mcap) ");
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
	
	
	public ArrayList<CrawlingDto> select(int start, int len){
		ArrayList<CrawlingDto> list = new ArrayList<CrawlingDto>();
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = ConnLocator.getConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("SELECT dealdate, opentime, high, low, endtime, vol, mcap ");
			sql.append("FROM bitcoin ");
			sql.append("ORDER BY dealdate DESC ");
			sql.append("LIMIT ?, ? ");
			
			pstmt = con.prepareStatement(sql.toString());
			
			int index = 0;
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
	
	public int getTotalRows() {
		int count = 0;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = ConnLocator.getConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("SELECT COUNT(dealdate)");
			sql.append("FROM bitcoin ");

			pstmt = con.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			if (rs.next()) {
				int index = 0;
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
	
	public int getOldestDate() {
		Date date = null;
		int year = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = ConnLocator.getConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("SELECT MIN(dealdate)");
			sql.append("FROM bitcoin ");

			pstmt = con.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			if (rs.next()) {
				int index = 0;
				date = rs.getDate(++index);
			}
			Calendar c = Calendar.getInstance();
			c.setTime(date);
			
			year = c.get(Calendar.YEAR);
			
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
		return year;
	}
	
}