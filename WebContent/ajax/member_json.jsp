<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page contentType="application/json;charset=utf-8"%>
<%--
{ 
	"cafelist" : [ 
	{"name":"이한빈","clubid":"lhb1025"},
	{"name":"스티브잡스","clubid":"steve"}, 
	] 
}
--%>
<%
// json파일로 만들기
	JSONObject jsonObj = new JSONObject();
	JSONArray jsonArray = new JSONArray();
	
	JSONObject item1 = new JSONObject();
	item1.put("name", "이한빈");
	item1.put("clubid","lhb1025");
		
	JSONObject item2 = new JSONObject();
	item2.put("name", "스티브잡스");
	item2.put("clubid","steve");
	
	JSONObject item3 = new JSONObject();
	item3.put("name", "손정의");
	item3.put("clubid","sjh1011");
	
	jsonArray.add(item1);
	jsonArray.add(item2);
	jsonArray.add(item3);
	
	jsonObj.put("cafelist", jsonArray);
	out.print(jsonObj.toString());
%>
