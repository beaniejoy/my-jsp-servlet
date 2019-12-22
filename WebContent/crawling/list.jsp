<%@page import="java.text.DecimalFormat"%>
<%@page import="beanie.crawling.CrawlingData"%>
<%@ page import="beanie.dto.CrawlingDto"%>
<%@ page import="beanie.dao.CrawlingDao"%>
<%@ page import="java.util.ArrayList"%>

<%@ page pageEncoding="utf-8"%>
<%@ include file="../inc/header.jsp"%>
<%
	int start = 0;
	int len = 30;
	int pageLength = 10;
	int totalRows = 0;
	int totalPage = 0;
	int startPage = 0;
	int endPage = 0;
	int cPage = 0;

	int start_year = 0;
	int start_month = 0;
	int start_day = 0;
	int end_year = 0;
	int end_month = 0;
	int end_day = 0;

	StringBuffer startDate = new StringBuffer();
	StringBuffer endDate = new StringBuffer();

	String tempPage = request.getParameter("page");
	// String sYear = request.getParameter("startYear");
	// String sMonth = request.getParameter("startMonth");
	// String sDay = request.getParameter("startDay");
	// String eYear = request.getParameter("endYear");
	// String eMonth = request.getParameter("endMonth");
	// String eDay = request.getParameter("endDay");
	String tempSDate = request.getParameter("start");
	String tempEDate = request.getParameter("end");
	int sDate = 0;
	int eDate = 0;
	// 항상 예외처리 중요시 하자
	// 쿼리에 page 값이 아예 없는 경우
	if (tempPage == null || tempPage.length() == 0) {
		cPage = 1;
	}
	if (tempSDate == null || tempSDate.length() == 0) {
		tempSDate = "20140711";
	}
	if (tempEDate == null || tempEDate.length() == 0) {
		tempEDate = "20191219";
	}
	// page 값은 있는데 숫자형식이 아닌경우
	try {
		cPage = Integer.parseInt(tempPage);
	} catch (NumberFormatException e) {
		cPage = 1;
	}
	try {
		sDate = Integer.parseInt(tempSDate);
		eDate = Integer.parseInt(tempEDate);
	} catch (NumberFormatException e) {
		tempSDate = "20140711";
		tempEDate = "20191219";
		sDate = Integer.parseInt(tempSDate);
		eDate = Integer.parseInt(tempEDate);
	}

	start_year = sDate / 10000;
	sDate %= 10000;
	start_month = sDate / 100;
	sDate %= 100;
	start_day = sDate;
	end_year = eDate / 10000;
	eDate %= 10000;
	end_month = eDate / 100;
	eDate %= 100;
	end_day = eDate;
	// 나중에 예외처리 어떻게 할 건지 정하자
	startDate.append(tempSDate.substring(0, 4));
	startDate.append("-");
	startDate.append(tempSDate.substring(4, 6));
	startDate.append("-");
	startDate.append(tempSDate.substring(6));

	endDate.append(tempEDate.substring(0, 4));
	endDate.append("-");
	endDate.append(tempEDate.substring(4, 6));
	endDate.append("-");
	endDate.append(tempEDate.substring(6));

	//CrawlingData.dataUpdate();
	CrawlingDao dao = CrawlingDao.getInstance();
	// 총 데이터수 구하기
	totalRows = dao.getTotalRows(startDate.toString(), endDate.toString());
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
	ArrayList<CrawlingDto> list = dao.select(start, len, startDate.toString(), endDate.toString());
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
	int currentBlock = cPage % pageLength == 0 ? (cPage / pageLength) : (cPage / pageLength + 1);
	int totalBlock = totalPage % pageLength == 0 ? (totalPage / pageLength) : (totalPage / pageLength + 1);
	startPage = 1 + (currentBlock - 1) * pageLength;
	endPage = pageLength + (currentBlock - 1) * pageLength;
	if (currentBlock == totalBlock) {
		endPage = totalPage;
	}
	int pageNum = totalRows - start;

	DecimalFormat formatInt = new DecimalFormat("###,###");
	DecimalFormat formatFloat = new DecimalFormat("###,###.##");
%>
<!-- breadcrumb start -->
<nav aria-label="breadcrumb">
	<ol class="breadcrumb">
		<li class="breadcrumb-item"><a href="/index.jsp">Home</a></li>
		<li class="breadcrumb-item active" aria-current="page">Crawling</li>
	</ol>
</nav>
<!-- breadcrumb end -->
<!-- main start -->
<div class="container">
	<div class="row">
		<div class="col-lg-12">
			<div class="text-right" style="margin-bottom: 10px;">
				<form name="f" method="post" style="display: inline;">
					<div style="margin-bottom: 10px;">
						<div class="text-left">
							<a type="button" class="btn btn-outline-danger"
								href="dbsave.jsp?page=<%=cPage%>&start=<%=tempSDate%>&end=<%=tempEDate%>">Save
								DB</a>
						</div>
						<div class="col-sm-3"></div>
						<label class="col-sm-3" for="syear"><b>시작지점</b></label> <select
							class="custom-select col-sm-2" id="syear" name="startYear">
							<%
								for (int i = 2019; i >= dao.getOldestDate(); i--) {
							%>
							<option value="<%=i%>" <%if (i == start_year) {%> selected <%}%>><%=i%></option>
							<%
								}
							%>
						</select> <select class="custom-select col-sm-2" id="smonth"
							name="startMonth">
							<%
								for (int i = 1; i <= 12; i++) {
							%>
							<option value="<%=i%>" <%if (i == start_month) {%> selected <%}%>><%=i%></option>
							<%
								}
							%>
						</select> <select class="custom-select col-sm-2" id="sday" name="startDay">
							<%
								for (int i = 1; i <= 31; i++) {
							%>
							<option value="<%=i%>" <%if (i == start_day) {%> selected <%}%>><%=i%></option>
							<%
								}
							%>
						</select>
					</div>
					<div style="margin-bottom: 10px;">
						<div class="col-sm-3"></div>
						<label class="col-sm-3" for="eyear"><b>끝지점</b></label> <select
							class="custom-select col-sm-2" id="eyear" name="endYear">
							<%
								for (int i = 2019; i >= dao.getOldestDate(); i--) {
							%>
							<option value="<%=i%>" <%if (i == end_year) {%> selected <%}%>><%=i%></option>
							<%
								}
							%>
						</select> <select class="custom-select col-sm-2" id="emonth"
							name="endMonth">
							<%
								for (int i = 1; i <= 12; i++) {
							%>
							<option value="<%=i%>" <%if (i == end_month) {%> selected <%}%>><%=i%></option>
							<%
								}
							%>
						</select> <select class="custom-select col-sm-2" id="eday" name="endDay">
							<%
								for (int i = 1; i <= 31; i++) {
							%>
							<option value="<%=i%>" <%if (i == end_day) {%> selected <%}%>><%=i%></option>
							<%
								}
							%>
						</select>
					</div>
				</form>
				<button type="button" id="updateDept"
					class="btn btn-outline-success" style="margin-right: 20px">검색</button>
				<a
					href="graph.jsp?page=<%=cPage%>&start=<%=tempSDate%>&end=<%=tempEDate%>"
					class="btn btn-outline-secondary">Graph</a>
			</div>
			<h3>
				<a href="list.jsp?page=1" style="text-decoration: none">Crawling</a>
			</h3>
		</div>


		<div class="table-responsive">
			<table class="table">
				<colgroup>
					<col width="16%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="23%">
					<col width="21%">
				</colgroup>
				<thead class="thead-light">
					<tr>
						<th scope="col">Date</th>
						<th scope="col">Open</th>
						<th scope="col">High</th>
						<th scope="col">Low</th>
						<th scope="col">Close</th>
						<th scope="col">Volume</th>
						<th scope="col">Market Cap</th>
					</tr>
				</thead>
				<tbody>
					<%
						if (list.size() != 0) {
					%>
					<%
						for (CrawlingDto dto : list) {
					%>
					<tr>
						<td><%=dto.getDate()%></td>
						<td><%=formatFloat.format(dto.getOpen())%></td>
						<td><%=formatFloat.format(dto.getHigh())%></td>
						<td><%=formatFloat.format(dto.getLow())%></td>
						<td><%=formatFloat.format(dto.getClose())%></td>
						<td><%=formatInt.format(dto.getVolume())%></td>
						<td><%=formatInt.format(dto.getMarketCap())%></td>
					</tr>
					<%
						}
						} else {
					%>
					<tr>
						<td colspan="7">데이터가 존재하지 않습니다.</td>
					</tr>
					<%
						}
					%>

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
					href="list.jsp?page=<%=startPage - 1%>&start=<%=tempSDate%>&end=<%=tempEDate%>">Previous</a></li>
				<%
					}
				%>
				<%
					for (int i = startPage; i <= endPage; i++) {
				%>
				<li class="page-item <%if (cPage == i) {%>active<%}%>"><a
					class="page-link"
					href="list.jsp?page=<%=i%>&start=<%=tempSDate%>&end=<%=tempEDate%>"><%=i%></a></li>
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
					href="list.jsp?page=<%=endPage + 1%>&start=<%=tempSDate%>&end=<%=tempEDate%>">Next</a></li>
				<%
					}
				%>
			</ul>
		</nav>


	</div>
</div>
</div>
<!-- main end -->
<%@ include file="../inc/footer.jsp"%>

<script>
	$("#updateDept").click(function() {
		let syear = $("#syear option:selected").val();
		let smonth = $("#smonth option:selected").val();
		let sday = $("#sday option:selected").val();
		let eyear = $("#eyear option:selected").val();
		let emonth = $("#emonth option:selected").val();
		let eday = $("#eday option:selected").val();
		if (smonth.length == 1) {
			smonth = "0" + smonth;
		}
		if (sday.length == 1) {
			sday = "0" + sday;
		}
		if (emonth.length == 1) {
			emonth = "0" + emonth;
		}
		if (eday.length == 1) {
			eday = "0" + eday;
		}
		let startDate = syear + smonth + sday;
		let endDate = eyear + emonth + eday;

		f.action = "list.jsp?page=1&start=" + startDate + "&end=" + endDate;
		f.submit();
	})
</script>