<%@ page pageEncoding="utf-8"%>
<%@ include file="../inc/header.jsp"%>
<!-- breadcrumb start -->
<nav aria-label="breadcrumb">
	<ol class="breadcrumb">
		<li class="breadcrumb-item"><a href="/index.jsp">Home</a></li>
		<li class="breadcrumb-item active" aria-current="page">DEPT</li>
	</ol>
</nav>
<!-- breadcrumb end -->
<%
	int cPage = 0;
	String tempPage = request.getParameter("page");

	if (tempPage == null || tempPage.length() == 0) {
		cPage = 1;
	}
	try {
		cPage = Integer.parseInt(tempPage);
	} catch (NumberFormatException e) {
		cPage = 1;
	}
%>
<!-- main start -->
<div class="container">
	<div class="row">
		<div class="col-lg-12">
			<h3>사원등록</h3>
			<form name="f" method="post" action="save.jsp">
				<%--
				<div class="form-group row">
					<label for="no" class="col-sm-2 col-form-label">사원번호</label>
					<div class="col-sm-10">
						<input type="number" class="form-control" id="no" name="no">
					</div>
				</div>
				--%>
				<div class="form-group row">
					<label for="name" class="col-sm-2 col-form-label">이름</label>
					<div class="col-sm-10">
						<input type="text" class="form-control" id="name" name="name">
						<div id="nameMessage"></div>
					</div>
				</div>
				<div class="form-group row">
					<label for="email" class="col-sm-2 col-form-label">이메일</label>
					<div class="col-sm-10">
						<input type="email" class="form-control" id="email" name="email">
						<div id="emailMessage"></div>
					</div>
				</div>
				<div class="form-group row">
					<label for="password" class="col-sm-2 col-form-label">비밀번호</label>
					<div class="col-sm-10">
						<input type="password" class="form-control" id="password"
							name="password">
						<div id="passwordMessage"></div>
					</div>
				</div>
				<div class="form-group row">
					<label for="rePassword" class="col-sm-2 col-form-label">비밀번호
						확인</label>
					<div class="col-sm-10">
						<input type="password" class="form-control" id="rePassword"
							name="rePassword">
						<div id="rePasswordMessage"></div>
					</div>
				</div>
				<div class="form-group row">
					<label for="phone" class="col-sm-2 col-form-label">휴대폰번호</label>
					<div class="col-sm-10">
						<input type="tel" class="form-control" id="phone" name="phone">
						<div id="phoneMessage"></div>
					</div>
				</div>
				<%--이메일이 이미 존재할 때 아예 쿼리를 안보내도록 hidden으로 value를 보냄 --%>
				<input type="hidden" name="checkEmail" id="checkEmail" value="no" />
			</form>

			<div class="text-right">
				<a href="list.jsp?page=<%=cPage%>" class="btn btn-outline-secondary">목록</a>
				<button type="button" id="saveMember"
					class="btn btn-outline-success">저장</button>
			</div>

		</div>
	</div>
</div>
<!-- main end -->
<%@ include file="../inc/footer.jsp"%>

<script>
	$(function() {
		$("#name").focus();
		$("#saveMember")
				.click(
						function() {
							if ($("#name").val().length == 0) {
								$("#name").addClass("is-invalid");
								// 이름을 입력하세요 warning표시
								$("#nameMessage")
										.html(
												"<span class='text-danger'>이름을 입력하세요</span>");
								$("#name").focus();
								return;
							}
							// 정규표현식은 / /로 시작하고 끈난다.
							let regEmail = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;

							if (regEmail.test($("#email").val()) == false) {
								$("#email").addClass("is-invalid");
								$("#emailMessage")
										.html(
												"<span class='text-danger'>올바른 이메일 형식이 아닙니다.</span>");
								$("#email").focus();
								return;
							}

							if ($("#password").val().length == 0) {
								$("#password").addClass("is-invalid");
								$("#passwordMessage")
										.html(
												"<span class='text-danger'>비밀번호를 입력하세요</span>");
								$("#password").focus();
								return;
							}
							if ($("#rePassword").val().length == 0) {
								$("#rePassword").addClass("is-invalid");
								$("#rePasswordMessage")
										.html(
												"<span class='text-danger'>비밀번호 확인을 입력하세요</span>");
								$("#rePassword").focus();
								return;
							}

							if ($("#password").val() != $("#rePassword").val()) {
								$("#rePassword").addClass("is-invalid");
								$("#rePasswordMessage")
										.html(
												"<span class='text-danger'>비밀번호가 일치하지 않습니다.</span>");
								//비밀번호 일치하지 않으면 패스워드 내용 지우고 다시 입력
								$("#rePassword").val("");
								$("#rePassword").focus();
								return;
							}

							if ($("#phone").val().length == 0) {
								$("#phone").addClass("is-invalid");
								$("#phone")
										.html(
												"<span class='text-danger'>휴대폰 번호를 입력하세요</span>");
								$("#phone").focus();
								return;
							}
							// checkEmail이 no이면 submit이 안됨 => 쿼리 전송을 안하는 것이다.
							if ($("#checkEmail").val() == "no") {
								return;
							}
							//유효성 검사 마치고 form을 제출
							f.submit();
						});
		$("#name").keyup(function() {
			// keyboard로 입력하면 없애겠다.
			$("#name").removeClass("is-invalid");
			$("#nameMessage").html('');
		});
		$("#email")
				.keyup(
						function() {
							// keyboard로 입력하면 없애겠다.
							$("#email").removeClass("is-invalid");
							$("#emailMessage").html('');

							let regEmail = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;
							if (regEmail.test($("#email").val())) {
								$
										.ajax({
											type : 'GET',
											url : 'check_email_ajax.jsp?email='
													+ $("#email").val(),
											dataType : 'json',
											error : function() {
												alert('error');
											},
											success : function(json) {
												// json => {"result" : "ok or fail"}
												// 여기서 ok의 의미를 정의해두어야 한다.
												// 작성한 이메일이 DB에 없으면 => ok
												if (json.result == "ok") {
													$("#emailMessage")
															.html(
																	"<span class='text-success'>등록 가능한 이메일 입니다.</span>");
													$("#checkEmail").val("yes");
												} else {
													$("#email").addClass(
															"is-invalid");
													$("#emailMessage")
															.html(
																	"<span class='text-danger'>이미 등록된 이메일 입니다.</span>");
												}
											}
										});
							}
						});
		$("#password").keyup(function() {
			// keyboard로 입력하면 없애겠다.
			$("#password").removeClass("is-invalid");
			$("#passwordMessage").html('');
		});
		$("#rePassword").keyup(function() {
			// keyboard로 입력하면 없애겠다.
			$("#rePassword").removeClass("is-invalid");
			$("#rePassword").html('');
		});
		$("#phone").keyup(function() {
			// keyboard로 입력하면 없애겠다.
			$("#phone").removeClass("is-invalid");
			$("#phone").html('');
		});

	});
</script>

