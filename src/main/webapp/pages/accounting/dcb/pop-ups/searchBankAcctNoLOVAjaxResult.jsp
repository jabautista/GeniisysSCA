<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedRow" value="" readonly="readonly" />
<div id="modalBankAcctNoDivTableContainer" class="tableContainer" style="font-size: 12px; width: 1100px; overflow: auto">
	<div class="tableHeader" style="overflow: auto">
		<label style="width: 80px; text-align: center">Bank Cd</label>
		<label style="width: 300px; margin-left: 15px; text-align: center">Bank Name</label>
		<label style="width: 180px; margin-left: 15px; text-align: center">Bank Acct. Type</label>
		<label style="width: 180px; margin-left: 15px; text-align: center">Bank Acct. Cd.</label>
		<label style="width: 180px; margin-left: 15px; text-align: center">Bank Acct. No.</label>
		<label style="width: 100px; margin-left: 15px; text-align: center">Branch Cd.</label>
	</div>
	<div style="overflow: auto">
		<c:forEach var="bankAcct" items="${searchResult}" varStatus="ctr">
			<div id="modalRow${ctr.index}" name="modalRow" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
				<label style="width:  80px; text-align: center" id="modalLblBankCd${ctr.index }">${bankAcct.bankCd }</label>
				<label style="width: 300px; margin-left: 15px;" id="modalLblBankName${ctr.index }" name="modalLblBankName">${bankAcct.bankName }</label>
				<label style="width: 180px; margin-left: 15px; text-align: center;" id="modalLblBankAcctType${ctr.index }">${bankAcct.bankAcctType }</label>
				<label style="width: 180px; margin-left: 15px; text-align: center;" id="modalLblBankAcctCd${ctr.index }">${bankAcct.bankAcctCd }</label>
				<label style="width: 180px; margin-left: 15px; text-align: center;" id="modalLblBankAcctNo${ctr.index }">${bankAcct.bankAcctNo }</label>
				<label style="width:  90px; margin-left: 15px; text-align: center;" id="modalLblBranchCd${ctr.index }">${bankAcct.branchCd }</label>
				<input type="hidden" id="modalRowBankCd${ctr.index }" 			name="modalRowBankCd${ctr.index}" 		value="${bankAcct.bankCd }"/>
				<input type="hidden" id="modalRowBankName${ctr.index }" 		name="modalRowBankName${ctr.index}" 	value="${bankAcct.bankName }"/>
				<input type="hidden" id="modalRowBankAcctType${ctr.index }" 	name="modalRowBankAcctType${ctr.index}" value="${bankAcct.bankAcctType }"/>
				<input type="hidden" id="modalRowBankAcctCd${ctr.index }" 		name="modalRowBankAcctCd${ctr.index}" 	value="${bankAcct.bankAcctCd }"/>
				<input type="hidden" id="modalRowBankAcctNo${ctr.index }" 		name="modalRowBankAcctNo${ctr.index}" 	value="${bankAcct.bankAcctNo }"/>
				<input type="hidden" id="modalRowBranchCd${ctr.index }" 		name="modalRowBranchCd${ctr.index}" 	value="${bankAcct.branchCd }"/>
			</div>
		</c:forEach>
	</div>
</div>
<div class="pager" id="pager" style="overflow: auto">
	<c:if test="${noOfPages>1}">
		<div align="right" style="overflow: auto">
		Page:
			<select id="bankAcctNoInvPage" name="bankAcctNoInvPage">
				<c:forEach var="i" begin="1" end="${noOfPages}" varStatus="status">
					<option value="${i}"
						<c:if test="${pageNo==i}">
							selected="selected"
						</c:if>
					>${i}</option>
				</c:forEach>
			</select> of ${noOfPages}
		</div>
	</c:if>
</div>
<script type="text/JavaScript">
	//position page div correctly
	var product = 288 - (parseInt($$("div[name='modalRow']").size())*28);
	$("pager").setStyle("margin-top: "+product+"px;");

	

	$$("label[name='modalLblBankName']").each(
		function(label) {
			if ((label.innerHTML).length > 40)    {
	            label.update((label.innerHTML).truncate(30, "..."));
	        }

			Effect.Appear("modalBankAcctNoDivTableContainer", {
		    	duration: 0.3
		    });
		}
	);

	$$("div[name='modalRow']").each(
		function (row)	{
			row.observe("mouseover", function ()	{
				row.addClassName("lightblue");
			});
			
			row.observe("mouseout", function ()	{
				row.removeClassName("lightblue");
			});
		
			row.observe("click", function ()	{
				row.toggleClassName("selectedRow");
				if (row.hasClassName("selectedRow"))	{
					$("selectedRow").value = row.id;
					$$("div[name='modalRow']").each(function (r)	{
						if (row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}
					});
				} else {
					$("selectedRow").value = "";
				}
			});
		}
	);

	if ($("bankAcctNoInvPage") != null) {
		$("bankAcctNoInvPage").observe("change", function() {
			page = $("bankAcctNoInvPage").options[$("bankAcctNoInvPage").selectedIndex].value;
			if (!page.blank()) {
				searchBankAcctNoLOV($("bankAcctNoInvPage").options[$("bankAcctNoInvPage").selectedIndex].value);
			}
		});
	}
</script>