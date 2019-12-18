<%@ page pageEncoding="utf-8"%>
<%--@ include file="header.jsp" --%>
<jsp:include page="header.jsp" />
<%-- 외부파일의 변수와 같으면 충돌발생 --%>
<% int age = 20;%>
	<section>section</section>
	<%out.println("<h3>" + age + "</h3>"); %>
<%@ include file="footer.jsp" %>
	