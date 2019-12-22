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
	int sDate = 0;
	int eDate = 0;
	StringBuffer startDate = new StringBuffer();
	StringBuffer endDate = new StringBuffer();

	String tempPage = request.getParameter("page");
	String tempSDate = request.getParameter("start");
	String tempEDate = request.getParameter("end");
	String tempCoin = request.getParameter("coin");
	CrawlingDao dao = CrawlingDao.getInstance();

	// 항상 예외처리 중요시 하자
	// 쿼리에 page 값이 아예 없는 경우
	if (tempPage == null || tempPage.length() == 0) {
		cPage = 1;
	}
	if (tempSDate == null || tempSDate.length() == 0) {
		tempSDate = dao.getOldestDate(tempCoin);
	}
	if (tempEDate == null || tempEDate.length() == 0) {
		tempEDate = "20191220";
	}
	// coin에 대한 유효성 검사 필요하다.
	if (tempCoin == null || tempCoin.length() == 0) {
		tempCoin = "bitcoin";
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
		tempCoin = "bitcoin";
		tempSDate = dao.getOldestDate(tempCoin);
		tempEDate = "20191120";
		sDate = Integer.parseInt(tempSDate);
		eDate = Integer.parseInt(tempEDate);
	}
	if(tempSDate.compareTo(dao.getOldestDate(tempCoin)) < 0){
		tempSDate = dao.getOldestDate(tempCoin);
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

	// 총 데이터수 구하기
	totalRows = dao.getTotalRows(startDate.toString(), endDate.toString(), tempCoin);
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
	ArrayList<CrawlingDto> list = dao.select(start, len, startDate.toString(), endDate.toString(), tempCoin);

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
					<div class="text-left" style="margin-bottom: 10px">
						<label for="coin"><b>Coin</b></label> <select
							class="custom-select col-sm-2" id="coin" name="coin"
							style="margin-left: 10px">
							<option value="bitcoin" <%if (tempCoin.equals("bitcoin")) {%>
								selected <%}%>>Bitcoin</option>
							<option value="ethereum" <%if (tempCoin.equals("ethereum")) {%>
								selected <%}%>>Ethereum</option>
							<option value="xrp" <%if (tempCoin.equals("xrp")) {%> selected
								<%}%>>XRP</option>
							<option value="bitcoin-cash"
								<%if (tempCoin.equals("bitcoin-cash")) {%> selected <%}%>>Bitcoin
								Cash</option>
							<option value="litecoin" <%if (tempCoin.equals("litecoin")) {%>
								selected <%}%>>Litecoin</option>
							<option value="eos" <%if (tempCoin.equals("eos")) {%> selected
								<%}%>>EOS</option>
							<option value="cardano" <%if (tempCoin.equals("cardano")) {%>
								selected <%}%>>Cardano</option>
						</select>
						<button type="button" class="btn btn-outline-danger" id="savedb">Save
							DB</button>
					</div>
					<div style="margin-bottom: 10px;">
						<div class="col-sm-3"></div>
						<label class="col-sm-3" for="syear"><b>시작지점</b></label> <select
							class="custom-select col-sm-2" id="syear" name="startYear">
							<%
								for (int i = 2019; i >= Integer.parseInt(dao.getOldestDate(tempCoin).substring(0, 4)); i--) {
							%>
							<option value="<%=i%>" <%if (i == start_year) {%> selected <%}%>><%=i%></option>
							<%
								}
							%>
						</select> <select class="custom-select col-sm-2" id="smonth"
							name="startMonth">
							<%
								for (int i = 1; i <= 12; i++) {
							%><%-- date는 month에서 1달 더해줘야 올바른 날짜가 나온다. --%>
							<option value="<%=i%>" <%if (i == start_month) {%> selected
								<%}%>><%=i%></option>
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
								for (int i = 2019; i >= Integer.parseInt(dao.getOldestDate(tempCoin).substring(0, 4)); i--) {
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
							<option value="<%=i%>" <%if (i == end_month) {%> selected
								<%}%>><%=i%></option>
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
				<button type="button" id="search" class="btn btn-outline-success"
					style="margin-right: 20px">검색</button>
				<button type="button" id="graph" class="btn btn-outline-secondary">Graph</button>
			</div>
			<h3>
				<a href="list.jsp?coin=<%=tempCoin %>&page=1&start=<%=dao.getOldestDate(tempCoin) %>&end=20191220" style="text-decoration: none">Crawling</a>
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
					href="list.jsp?coin=<%=tempCoin %>&page=<%=startPage - 1%>&start=<%=tempSDate%>&end=<%=tempEDate%>">Previous</a></li>
				<%
					}
				%>
				<%
					for (int i = startPage; i <= endPage; i++) {
				%>
				<li class="page-item <%if (cPage == i) {%>active<%}%>"><a
					class="page-link"
					href="list.jsp?coin=<%=tempCoin %>&page=<%=i%>&start=<%=tempSDate%>&end=<%=tempEDate%>"><%=i%></a></li>
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
					href="list.jsp?coin=<%=tempCoin %>&page=<%=endPage + 1%>&start=<%=tempSDate%>&end=<%=tempEDate%>">Next</a></li>
				<%
					}
				%>
			</ul>
		</nav>

	</div>
</div>
<!-- main end -->
<%@ include file="../inc/footer.jsp"%>

<script>
	$("#search").click(function() {
		let coin = $("#coin option:selected").val();
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

		f.action = "list.jsp?coin="+ coin + "&page=1&start=" + startDate + "&end=" + endDate;
		f.submit();
	})
	$("#graph").click(function() {
		let coin = $("#coin option:selected").val();
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
		
		if(startDate == <%=tempSDate%> && endDate == <%=tempEDate%>){
			f.action = "graph.jsp?coin=" + coin + "&page=<%=cPage%>&start=" + startDate + "&end=" + endDate;
				} else {
					f.action = "graph.jsp?start=" + startDate + "&end="+ endDate;
				}
				f.submit();
			})
	$("#savedb").click(function() {
		let coin = $("#coin option:selected").val();
		f.action = "dbsave.jsp?coin=" + coin;
		f.submit();
	})
</script>