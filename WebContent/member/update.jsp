<%@ page import="beanie.dto.DeptDto"%>
<%@ page import="beanie.dto.EmpDto"%>
<%@ page import="beanie.dao.EmpDao"%>
<%@ page pageEncoding="utf-8"%>
<%
	request.setCharacterEncoding("utf-8");
	
	int no = Integer.parseInt(request.getParameter("no"));
	String name = request.getParameter("name");
	String job = request.getParameter("job");	
	int mgr = Integer.parseInt(request.getParameter("mgr"));
	int sal = Integer.parseInt(request.getParameter("sal"));
	int comm = Integer.parseInt(request.getParameter("comm"));
	int deptNo = Integer.parseInt(request.getParameter("deptNo"));
	
	String tempPage = request.getParameter("page");
	DeptDto deptDto = new DeptDto(deptNo, null, null);
	EmpDao dao = EmpDao.getInstance();
	EmpDto dto = new EmpDto(no, name, job, mgr, null, sal, comm, deptDto);
	boolean isSuccess = dao.update(dto);
	if (isSuccess) {
%>
<script>
	alert('사원정보가 수정되었습니다.');
	// 지정한 페이지로 redirect
	// javascript부분에서의 sendRedirect
	location.href = "view.jsp?page=<%=tempPage%>&no=<%=no%>";
</script>
<%
	} else {
%>
<script>
	alert('DB Error');
	// 바로 직전의 페이지로 돌아간다.
	history.back(-1);
</script>
<%
	}
%>
