<%-- pageDirective.jsp --%>

<%-- text/html에서 test라고 쓰지말자. 
해당 파일이 다운 받아짐 --%>

<%-- import하고 싶을 때/ ctrl+space로 간편하게--%>
<%-- 콤마로 이어서 import를 할 수 있지만 가독성이 안좋아서
따로 써주는 것이 좋다. --%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@ page pageEncoding="utf-8"%>
<%-- session: 로그인 때 필요
로그인이 필요없는 페이지에서는 false로 해두자 --%>
<%@ page session="true"%>
<%-- 출력 버퍼를 바꿔준다. --%>
<%@ page buffer="10kb" %>
<%-- autoFlush default: true --%>
<%@ page autoFlush="true" %>
<%-- 원래는 multiThreadModel(true/디폴트값)
singleThread로 바뀌면 한 서비스가 끝날때까지 다른 서비스 접근 불가 --%>
<%@ page isThreadSafe="false" %>
<%@ page info="jsp 페이지 입니다." %>
<%@ page errorPage="/error/error.jsp" %>
<%-- false가 디폴트(EL을 무시하지 않겠다.)--%>
<%@ page isELIgnored="true" %>

<%
	Calendar c = Calendar.getInstance();
	SimpleDateFormat s = new SimpleDateFormat();
	
	session.setAttribute("aa","aa");
	//int a = Integer.parseInt("asd");
	String id = request.getParameter("id");
	out.println(id);
%>
<%-- (EL, 특수한 표현법) html코드에서만 사용가능 --%>
${param.id }

