<%@ page import="beanie.dto.DeptDto"%>
<%@ page import="beanie.dao.DeptDao"%>
<%@ page import="java.util.ArrayList"%>

<%@ page pageEncoding="utf-8"%>
<%@ include file="../inc/header.jsp"%>
<%
	int start = 0;
	int len = 5; // 원하는 값 미리 할당
	int cPage = 0; // 가장 중요
	int totalRows = 0; 
	int totalPages = 0; // 마지막 페이지가 어딘지 알기 위해
	int pageLength = 5; // 원하는 값 미리 할당
	int startPage = 0; // 페이지 한 묶음에서 시작페이지숫자
	int endPage = 0; // 페이지 한 묶음에서 끝페이지숫자
	int currentBlock = 0; // 현재 페이지 묶음 중 어디 블럭에 속해있는지
	// 나중에 startPage와 endPage를 알아내기 위해 중요한 데이터

	String tempPage = request.getParameter("page");

	// cPage(현재 페이지 정하기)
	if (tempPage == null || tempPage.length() == 0) {
		cPage = 1;
	}
	try {
		cPage = Integer.parseInt(tempPage);
	} catch (NumberFormatException e) {
		cPage = 1;
	}
	DeptDao dao = DeptDao.getInstance();
	// 전체 데이터 개수
	totalRows = dao.getTotalRows();
	// 데이터가 아예 없는 경우도 있을 것이기에 조심해서 예외처리하자
	// 총 페이지 수 구하는 것도 중요하다.
	totalPages = totalRows % len == 0 ? totalRows / len : (totalRows / len) + 1;
	if (totalPages == 0) {
		totalPages = 1;
	}
	if (cPage > totalPages) {
		cPage = 1;
	}
	// 여기까지 cPage(현재 속한 페이지) 전처리 작업이 끝남
	// 끝나고 나서 정제된 cPage 변수를 가지고 start(각 페이지에서 데이터 시작점) 구함
	start = (cPage - 1) * len;
	// 구해낸 각 페이지의 start를 가지고 데이터 뽑아냄
	ArrayList<DeptDto> list = dao.select(start, len);

	// 페이지 처음과 끝을 지정하는 부분
	currentBlock = cPage % pageLength == 0 ? cPage / pageLength : (cPage / pageLength) + 1;
	startPage = (currentBlock - 1) * pageLength + 1;
	endPage = startPage + pageLength - 1;
	// 마지막 페이지 묶음에서 총 페이지수를 넘어가면 끝 페이지를 마지막 페이지 숫자로 지정
	if (endPage > totalPages) {
		endPage = totalPages;
	}
%>
<!-- breadcrumb start -->
<nav aria-label="breadcrumb">
	<ol class="breadcrumb">
		<li class="breadcrumb-item"><a href="/index.jsp">Home</a></li>
		<li class="breadcrumb-item active" aria-current="page">DEPT</li>
	</ol>
</nav>
<!-- breadcrumb end -->
<!-- main start -->
<div class="container">
	<div class="row">
		<div class="col-lg-12">
			<h3>부서리스트</h3>

			<table class="table">
				<colgroup>
					<col width="20%">
					<col width="60%">
					<col width="20%">
				</colgroup>
				<thead class="thead-light">
					<tr>
						<th scope="col">부서번호</th>
						<th scope="col">부서이름</th>
						<th scope="col">부서위치</th>
					</tr>
				</thead>
				<tbody>
					<%
						if (list.size() != 0) {
					%>
					<%
						for (DeptDto dto : list) {
					%>
					<tr>
						<td><a href="view.jsp"><%=dto.getNo()%></a></td>
						<td><%=dto.getName()%></td>
						<td><%=dto.getLoc()%></td>
					</tr>
					<%
						}
					%>
					<%
						} else {
					%>
					<tr>
						<td colspan="3">데이터가 존재하지 않습니다.</td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>

			<nav aria-label="Page navigation example">
				<ul class="pagination justify-content-center">
					<%
						if (startPage == 1) {
					%>
					<li class="page-item disabled"><a class="page-link" href="#"
						tabindex="-1" aria-disabled="true">Previous</a></li>
					<%
						} else {
					%>
					<li class="page-item"><a class="page-link"
						href="list.jsp?page=<%=startPage - 1%>" tabindex="-1"
						aria-disabled="true">Previous</a></li>
					<%
						}
					%>
					<%
						for (int i = startPage; i <= endPage; i++) {
					%>
					<li class="page-item">
					<a class="page-link" href="list.jsp?page=<%=i %>"><%=i%></a></li>
					<%
						}
					%>
					<%
						// 마지막 페이지 숫자와 startPage에서 pageLength 더해준 값이 일치할 때(즉 마지막 페이지 블럭일 때)
						if (totalPages == endPage) {
					%>
					<li class="page-item disabled"><a class="page-link" href="#">Next</a></li>
					<%
						} else {
					%>
					<li class="page-item"><a class="page-link"
						href="list.jsp?page=<%=endPage + 1%>">Next</a></li>
					<%
						}
					%>
				</ul>
			</nav>

			<div class="text-right">
				<!-- 하이퍼링크로 해도 상관 없다. (a tag) -->
				<a href="write.jsp" class="btn btn-outline-secondary">부서등록</a>
			</div>

		</div>
	</div>
</div>
<!-- main end -->
<%@ include file="../inc/footer.jsp"%>
