<%@ page pageEncoding="utf-8"%>
<%@ include file="../inc/header.jsp"%>
<%
	
%>
<div class="row">
	<div class="col-lg-12">
		<form action="">
			<label for="coin">
				<select class="custom-select" id="coin" name="coin">
					<option value="">--코인선택--</option>
					<option value="bitcoin" selected>Bitcoin</option>
					<option value="ethereum">Ethereum</option>
					<option value="xrp">XRP</option>
					<option value="eos">EOS</option>
				</select>
			</label>
		</form>
		<button type="button" class="btn btn-outline-danger">Danger</button>
	</div>
</div>

<%@ include file="../inc/footer.jsp"%>