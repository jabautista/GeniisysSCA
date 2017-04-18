<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="contentsDiv"><!-- rename this in the future(to be edited -form) -->
	<div align="left">
		<table>
			<tr>
				<td class="rightAligned">Find </td>
				<td class="leftAligned"><input name="keyword" id="keyword" style="margin-bottom: 0; width: 200px;" type="text" value="" /></td>
				<td><input class="button" type="button" style="width: 60px;" onclick="searchGcopInvDetails(1);" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 360px; background-color: #ffffff; overflow: scroll;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<!-- put "id" for each button (refer to common.js "openSearchClientModal()" function for js function -->
		<input type="button" class="button" id="btnGcopInvModalOk"     value="Ok" 	  style="width: 60px;" />
		<input type="button" class="button" id="btnGcopInvModalCancel" value="Cancel" style="width: 60px;"/>
	</div>
</div>
<script type="text/javascript">
	searchGcopInvDetails(1);

	$("keyword").observe("keydown", function(e) {
		if (e.keyCode == 13) {
			searchGcopInvDetails(1);
		}
	});
	
	$("btnGcopInvModalOk").observe("click", function () {
		if ($$("div[name='gcopInvRow']").size() > 0) {
			//These parts are executed on GIACS020 module (directTransCommPayts.jsp)
			$$("div[name='gcopInvRow']").each(function(row) {
				$("txtIssCd").value = row.down("input", 0).value;
				$("txtPremSeqNo").value = row.down("input", 1).value;
				$("txtIntmNo").value = row.down("input", 2).value;
				$("txtDspIntmName").value = row.down("input", 3).value;
				$("isIntmNoValidated").value = "N";
				$("txtCommAmt").value = row.down("input", 4).value;
				$("txtInputVATAmt").value = row.down("input", 5).value;
				
				$("txtWtaxAmt").value = row.down("input", 6).value;
				$("txtDrvCommAmt").value = row.down("input", 7).value;
				$("txtBillGaccTranId").value = row.down("input", 8).value;
				
				row.remove();
				if ($$("div[name='gcopInvRow']").size() == 0) {
					$("gcopInvModalTag").value = "N";
				}
				objACGlobal.validateIntmNo(false); // added by irwin	// added param : shan 10.17.2014
				$("txtDspIntmName").focus();
				$("txtCommAmt").focus();
				fireEvent($("txtCommAmt"), 'change');
				$("btnSaveRecord").click();
			});
			$("gcopInvModalTag").value = "N";
			//Modalbox.hide();
			GcopInvDetailsOverlay.close(); //added by steven 09.12.2014
		} else {
			showMessageBox("Please select record/s first.", imgMessage.ERROR);
			return false;
		}
	});
	
	$("btnGcopInvModalCancel").observe("click", function() {
		$$("div[name='gcopInvRow']").each(function(row) {
			row.remove();
		});
		//Modalbox.hide();
		GcopInvDetailsOverlay.close(); //added by steven 09.12.2014
	});
</script>