<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div id="pdcPremCollUpdateMainDiv" style="float: left;">
	<!-- benjo 11.08.2016 SR-5802 -->
	<div id="pdcPremCollnUpdateOptionsDiv" style="width: 100%; margin-top: 15px; margin-left: 16px; float: left;">
		<div id="payorDiv" style="display: none;">
			<input type="checkbox" id="chkPayor" name="chkPayor" style="float: left; margin-bottom: 10px;" />
			<label style="margin-left: 5px; margin-bottom: 10px;">Payor</label>
			<div style="float: left; margin-left: 25px; margin-bottom: 10px;">
				<input title="Assured" type="radio" id="assdRB" name="updateSpecificFlag" value="A" style="float: left; margin-top: 0px;" checked="true" disabled="disabled"><label for="assdRB">A</label>
				<input title="Intermediary" type="radio" id="intmRB" name="updateSpecificFlag" value="I" style="float: left; margin-top: 0px; margin-left: 15px;" disabled="disabled"><label for="intmRB">I</label>
			</div><br><br>
		</div>
		<input type="checkbox" id="chkAddress" name="chkAddress" style="float: left; margin-bottom: 10px;" />
		<label style="margin-left: 5px; margin-bottom: 10px;">Address</label><br><br>
		<input type="checkbox" id="chkIntermediaryNo" name="chkIntermediaryNo" style="float: left; margin-bottom: 10px;" />
		<label style="margin-left: 5px; margin-bottom: 10px;">Intermediary</label><br><br>
		<input type="checkbox" id="chkParticulars" name="chkParticulars" style="float: left; margin-bottom: 10px;" />
		<label style="margin-left: 5px; margin-bottom: 15px;">Particulars</label>
	</div>
	<!-- end SR-5802 -->
	<div style="margin-bottom: 10px; width: 95%; float: left;">
		<input type="button"   id="btnUpdateOk" name="btnUpdateOk" value="OK" class="button" style="width: 80px; margin-left: 17px;"/>
		<input type="button"   id="btnUpdateCancel" name="btnUpdateCancel" value="Cancel" class="button" style="width: 80px;" />
	</div>
</div>
<script type="text/javascript">	
	/* benjo 11.08.2016 SR-5802 */
	if (nvl('${apdcSw}', "N") == "Y"){
		$("payorDiv").style.display = 'block';
	}
	
	$("chkPayor").observe("change", function() {
		if ($("chkPayor").checked) {
			$$("input[name='updateSpecificFlag']").each(function(r){
				r.disabled = false;
			});
		}else{
			$$("input[name='updateSpecificFlag']").each(function(r){
				r.disabled = true;
			});
		}
	});
	/* end SR-5802 */
	
	$("btnUpdateOk").observe("click", function (){
		update.specific = new Object();
		update.specific.address = $("chkAddress").checked;
		update.specific.intermediary = $("chkIntermediaryNo").checked;
		update.specific.particulars = $("chkParticulars").checked;
		/* benjo 11.08.2016 SR-5802 */
		update.specific.payor = $("chkPayor").checked;
		if ($("chkPayor").checked) {
			$$("input[name='updateSpecificFlag']").each(function(r){
				if (r.checked) {
					update.specific.flag = r.value;
				}
			});
		}else{
			update.specific.flag = "A";
		}
		update.func(1);
		/* end SR-5802 */
		hideOverlay();
	});

	$("btnUpdateCancel").observe("click", hideOverlay);
</script>
