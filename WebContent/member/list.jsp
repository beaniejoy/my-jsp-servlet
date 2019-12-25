<%@page import="beanie.dto.EmpDto"%>
<%@page import="beanie.dao.EmpDao"%>

<%@ page import="java.util.ArrayList"%>

<%@ page pageEncoding="utf-8"%>
<%@ include file="../inc/header.jsp"%>
<%
	int start = 0;
	int len = 5;
	int pageLength = 3;
	int totalRows = 0;
	int totalPage = 0;
	int startPage = 0;
	int endPage = 0;
	int cPage = 0;
	String tempPage = request.getParameter("page");

	// 항상 예외처리 중요시 하자
	// 쿼리에 page 값이 아예 없는 경우
	if (tempPage == null || tempPage.length() == 0) {
		cPage = 1;
	}
	// page 값은 있는데 숫자형식이 아닌경우
	try {
		cPage = Integer.parseInt(tempPage);
	} catch (NumberFormatException e) {
		cPage = 1;
	}

	EmpDao dao = EmpDao.getInstance();

	// 총 데이터수 구하기
	totalRows = dao.getTotalRows();

	totalPage = totalRows % len == 0 ? totalRows / len : totalRows / len + 1;
	// totalRows가 0일 때 문제 발생
	if (totalPage == 0) {
		totalPage = 1;
	}

	if (cPage > totalPage) {
		cPage = 1;
	}
	// An = a1 + (n - 1)*d
	start = (cPage - 1) * len;
	ArrayList<EmpDto> list = dao.select(start, len);
	/*
		가정
		total Rows = 132;
		len = 5;
		pageLength = 10;
					startPage	endPage
		cPage = 1		1		  10
		cPage = 5		1		  10
		cPage = 14		11		  20
		cPage = 22		21		  27
		startPage = 1 + (currentBlock - 1) * pageLength
		endPage = pageLength + (currentBlock - 1) * pageLength
	*/

	// int currentBlock = cPage / pageLength; 이렇게 해서
	// 1 + currentBlock * pageLength 하면 안되는건지
	int currentBlock = cPage % pageLength == 0 ? (cPage / pageLength)
			: (cPage / pageLength + 1);
	int totalBlock = totalPage % pageLength == 0 ? (totalPage / pageLength)
			: (totalPage / pageLength + 1);
	startPage = 1 + (currentBlock - 1) * pageLength;
	endPage = pageLength + (currentBlock - 1) * pageLength;
	if (currentBlock == totalBlock) {
		endPage = totalPage;
	}
	int pageNum = totalRows - start;
%>
<!-- breadcrumb start -->
<nav aria-label="breadcrumb">
	<ol class="breadcrumb">
		<li class="breadcrumb-item"><a href="/index.jsp">Home</a></li>
		<li class="breadcrumb-item active" aria-current="page">회원관리</li>
	</ol>
</nav>
<!-- breadcrumb end -->
<!-- main start -->
<div class="container">
	<div class="row">
		<div class="col-lg-12">
			<h3>
				회원리스트 (총 데이터 개수:
				<%=totalRows%>)
			</h3>
			<div class="table-responsive">
				<table class="table">
					<colgroup>
						<col width="10%">
						<col width="15%">
						<col width="25%">
						<col width="25%">
						<col width="25%">
						
					</colgroup>
					<thead class="thead-light">
						<tr>
							<th scope="col">#</th>
							<th scope="col">이름</th>
							<th scope="col">이메일</th>
							<th scope="col">휴대폰번호</th>
							<th scope="col">등록일</th>
							
						</tr>
					</thead>
					<tbody>
						
						<tr>
							<td><%=pageNum-- %></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td><td>
							<td></td>
						</tr>
						
						<tr>
							<td colspan="5">데이터가 존재하지 않습니다.</td>
						</tr>
						
					</tbody>
				</table>

			</div>

			<nav aria-label="Page navigation example">
				<ul class="pagination justify-content-center">
					<%
						if (currentBlock == 1) {
					%>
					<li class="page-item disabled"><a class="page-link" href="#"
						tabindex="-1" aria-disabled="true">Previous </a></li>
					<%
						} else {
					%>
					<li class="page-item"><a class="page-link"
						href="list.jsp?page=<%=startPage - 1%>">Previous</a></li>
					<%
						}
					%>
					<%
						for (int i = startPage; i <= endPage; i++) {
					%>
					<li class="page-item <%if (cPage == i) {%>active<%}%>"><a
						class="page-link" href="list.jsp?page=<%=i%>"><%=i%></a></li>
					<%
						}
					%>
					<%
						if (currentBlock == totalBlock) {
					%>
					<li class="page-item disabled"><a class="page-link" href="#"
						tabindex="-1" aria-disabled="true">Next</a></li>
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
				<a href="write.jsp?page=<%=cPage%>"
					class="btn btn-outline-secondary">사원등록</a>
			</div>

		</div>
	</div>
</div>
<!-- main end -->
<%@ include file="../inc/footer.jsp"%>
