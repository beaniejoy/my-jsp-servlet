package kr.co.acorn.hello;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.acorn.dao.DeptDao;
import kr.co.acorn.dto.DeptDto;

@WebServlet("/SaveDeptServlet")
public class SaveDeptServlet extends HttpServlet{
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 파라미터가 한글일 경우에는 반드시 해줘야 한다.
		request.setCharacterEncoding("utf-8");
		// 무조건 반환값이 문자열이다.
		int no = Integer.parseInt(request.getParameter("no"));
		String name = request.getParameter("name");
		String loc = request.getParameter("loc");
		
		DeptDto dto = new DeptDto(no,name,loc);
		DeptDao dao = DeptDao.getInstance();
		boolean isSuccess = dao.insert(dto);
		
		if(isSuccess) {
			// 새로운 Servlet을 만들어서 보내버림
			response.sendRedirect("/dept_success.html");
		}else {
			response.sendRedirect("/dept.html");			
		}
	}
}
