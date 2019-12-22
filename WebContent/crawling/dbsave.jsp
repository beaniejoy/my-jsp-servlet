<%@page import="beanie.crawling.CrawlingData"%>
<%@page import="beanie.dao.CrawlingDao"%>
<%@ page pageEncoding="utf-8"%>
<%@ include file="../inc/header.jsp"%>
<%
	String coin = request.getParameter("coin");
	
	CrawlingDao dao = CrawlingDao.getInstance();
	boolean isSuccess = dao.create(coin);
	
	isSuccess = CrawlingData.dataUpdate(coin);

	if (isSuccess) {
%>
<script>
	alert('<%=coin%>의 데이터를 성공적으로 DB에 저장했습니다.');
	location.href = "list.jsp?coin=<%=coin%>&page=1";
<%} else {%>
	alert('<%=coin%>의 데이터를 DB에 저장하는데 실패했습니다.');
	history.back(-1);
<%}%>
	
</script>