<%@page import="beanie.dto.EmpDto"%>
<%@page import="beanie.dao.EmpDao"%>
<%@ page pageEncoding="utf-8"%>
<%
	request.setCharacterEncoding("utf-8");
	int no = Integer.parseInt(request.getParameter("no"));
	String tempPage = request.getParameter("page");
	// delete는 부서번호만 가져오면 된다.
	EmpDao dao = EmpDao.getInstance();
	boolean isSuccess = dao.delete(no);
	if (isSuccess) {
%>
<script>
	alert('사원정보가 삭제되었습니다.');
	// 지정한 페이지로 redirect
	// javascript부분에서의 sendRedirect
	location.href = "list.jsp?page=<%=tempPage%>";
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
