<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="beanie.dto.CrawlingDto"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beanie.dao.CrawlingDao"%>
<%@ page pageEncoding="utf-8"%>
<%@ include file="../inc/header.jsp"%>
<%
	String tempPage = request.getParameter("page");
	String tempStart = request.getParameter("start");
	String tempEnd = request.getParameter("end");
	String tempCoin = request.getParameter("coin");

	if (tempPage == null || tempPage.length() == 0) {
		tempPage = "1";
	}
	if (tempCoin == null || tempCoin.length() == 0) {
		response.sendRedirect("list.jsp?page=" + tempPage);
		return;
	}
	if (tempStart == null || tempStart.length() == 0) {
		response.sendRedirect("list.jsp?coin=" + tempCoin + "&page=" + tempPage);
		return;
	}
	if (tempEnd == null || tempEnd.length() == 0) {
		response.sendRedirect("list.jsp?coin=" + tempCoin + "&page=" + tempPage);
		return;
	}
	
	
	int cPage = 0;
	int totalRows = 0;

	CrawlingDao dao = CrawlingDao.getInstance();

	StringBuffer startDate = new StringBuffer();
	StringBuffer endDate = new StringBuffer();
	startDate.append(tempStart.substring(0, 4));
	startDate.append("-");
	startDate.append(tempStart.substring(4, 6));
	startDate.append("-");
	startDate.append(tempStart.substring(6));

	endDate.append(tempEnd.substring(0, 4));
	endDate.append("-");
	endDate.append(tempEnd.substring(4, 6));
	endDate.append("-");
	endDate.append(tempEnd.substring(6));

	totalRows = dao.getTotalRows(startDate.toString(), tempEnd.toString(), tempCoin);
	ArrayList<CrawlingDto> list = new ArrayList<CrawlingDto>();
	list = dao.select(0, totalRows, startDate.toString(), endDate.toString(), tempCoin);
%>
<!-- breadcrumb start -->
<nav aria-label="breadcrumb">
	<ol class="breadcrumb">
		<li class="breadcrumb-item"><a href="/index.jsp">Home</a></li>
		<li class="breadcrumb-item active" aria-current="page">DEPT</li>
	</ol>
</nav>
<!-- breadcrumb end -->


<script type="text/javascript"
	src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
	google.charts.load('current', {
		packages : [ 'corechart', 'line' ]
	});
	google.charts.setOnLoadCallback(drawTrendlines);

	function drawTrendlines() {
		var data = new google.visualization.DataTable();
		data.addColumn('datetime', 'date');
		data.addColumn('number', '<%=tempCoin%>');
<%for (CrawlingDto dto : list) {
				int year = Integer.parseInt(dto.getDate().substring(0, 4));
				int month = Integer.parseInt(dto.getDate().substring(5, 7));
				int day = Integer.parseInt(dto.getDate().substring(8));%>
	data.addRows([ [ new Date(<%=year%>,<%=month - 1%>,<%=day%>)
	,
<%=dto.getClose()%>
	] ]);
<%}%>
	var options = {
			hAxis : {
				title : 'Date',
				format : 'yyyy-MM'
			},
			vAxis : {
				title : 'ClosePrice'
			},
			colors : [ '#AB0D06' ],
			height: 500,
			trendlines : {
				0 : {
					type : 'exponential',
					color : '#333',
					opacity : 1
				}
			}
		};

		var chart = new google.visualization.LineChart(document
				.getElementById('chart_div'));
		chart.draw(data, options);
	}

</script>
<div class="col-lg-12">
	<h5>
		<%=startDate.toString()%>
		~
		<%=endDate.toString()%>
	</h5>
	<div id="chart_div" style="width: 100%; min-height:500px"></div>

	<div class="text-right" style="margin-right: 100px">
		<button type="button" id="prevPage" class="btn btn-outline-secondary">테이블보기</button>
	</div>
</div>



<%@ include file="../inc/footer.jsp"%>

<script>
	$("#prevPage").click(function() {
		location.href = "list.jsp?page=<%=tempPage%>&start=<%=tempStart%>&end=<%=tempEnd%>";
	})
	$(window).resize(function(){
		drawTrendlines();
	});
</script>