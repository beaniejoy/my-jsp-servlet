package beanie.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.apache.catalina.storeconfig.RealmSF;

import beanie.dto.DeptDto;
import beanie.util.ConnLocator;

public class DeptDao {

	private static DeptDao single;

	private DeptDao() {

	}

	public static DeptDao getInstance() {
		if (single == null) {
			single = new DeptDao();
		}
		return single;
	}

	public int getTotalRows() {
		int count = 0;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = ConnLocator.getConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("SELECT COUNT(deptno) FROM dept ");

			pstmt = con.prepareStatement(sql.toString());

			rs = pstmt.executeQuery();

			int index = 0;
			if (rs.next()) {
				count = rs.getInt(++index);
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

		return count;
	}

	public boolean insert(DeptDto dto) {
		boolean isSuccess = false;

		Connection con = null;
		PreparedStatement pstmt = null;
		try {

			con = ConnLocator.getConnection();

			StringBuffer sql = new StringBuffer();

			sql.append("INSERT INTO dept(deptno, dname, loc) VALUES(?,?,?)");
			pstmt = con.prepareStatement(sql.toString());

			int index = 0;
			pstmt.setInt(++index, dto.getNo());
			pstmt.setString(++index, dto.getName());
			pstmt.setString(++index, dto.getLoc());

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

	public boolean update(DeptDto dto) {
		boolean isSuccess = false;

		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = ConnLocator.getConnection();

			StringBuffer sql = new StringBuffer();

			sql.append("UPDATE dept SET dname = ?, loc = ? WHERE deptno = ?");
			pstmt = con.prepareStatement(sql.toString());

			int index = 0;
			pstmt.setString(++index, dto.getName());
			pstmt.setString(++index, dto.getLoc());
			pstmt.setInt(++index, dto.getNo());

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

	public boolean delete(int deptNo) {
		boolean isSuccess = false;

		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = ConnLocator.getConnection();

			StringBuffer sql = new StringBuffer();
			sql.append("DELETE FROM dept WHERE deptno = ?");

			pstmt = con.prepareStatement(sql.toString());
			int index = 0;
			pstmt.setInt(++index, deptNo);

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

	public ArrayList<DeptDto> select(int start, int len) {

		ArrayList<DeptDto> list = new ArrayList<DeptDto>();

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = ConnLocator.getConnection();

			StringBuffer sql = new StringBuffer();
			sql.append("SELECT deptno, dname, loc ");
			sql.append("FROM dept ");
			sql.append("ORDER BY deptno ");
			sql.append("LIMIT ?,? ");

			pstmt = con.prepareStatement(sql.toString());
			int index = 0;
			pstmt.setInt(++index, start);
			pstmt.setInt(++index, len);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				index = 1;
				int deptno = rs.getInt(index++);
				String dname = rs.getString(index++);
				String loc = rs.getString(index++);
				list.add(new DeptDto(deptno, dname, loc));
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

		return list;
	}

	public DeptDto select(int deptNo) {
		DeptDto dto = null;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = ConnLocator.getConnection();

			StringBuffer sql = new StringBuffer();
			sql.append("SELECT deptno, dname, loc ");
			sql.append("FROM dept ");
			sql.append("WHERE deptno = ?");

			pstmt = con.prepareStatement(sql.toString());
			int index = 0;
			pstmt.setInt(++index, deptNo);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				index = 0;
				int deptno = rs.getInt(++index);
				String dname = rs.getString(++index);
				String loc = rs.getString(++index);
				dto = new DeptDto(deptno, dname, loc);
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

		return dto;
	}
}