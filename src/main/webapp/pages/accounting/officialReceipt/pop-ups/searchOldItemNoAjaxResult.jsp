<!-- 
Remarks: For deletion
Date : 06-21-2012
Developer: Emsy
Replacement : showGIACPremDepOldItemNoLOV function in accounting-lov.js
-->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedRow" value="" readonly="readonly" />
<div class="tableContainer" style="width: 2150px; font-size: 12px; overflow: auto;">
	<div class="tableHeader" style="width: 2150px; overflow: auto;">
		<label style="width: 100px; margin-left: 15px; text-align: right">Old Item No.</label>
		<label style="width: 100px; text-align: right">Old Tran Type</label>
		<label style="width: 150px; text-align: center">Amount</label>
		<label style="width: 100px; text-align: center">Tran Year</label>
		<label style="width: 100px; text-align: center">Tran Month</label>
		<label style="width: 100px; text-align: right">Tran Seq No</label>
		<label style="width: 200px; text-align: center">Particulars</label>
		<label style="width: 100px; text-align: center">Tran Class</label>
		<label style="width: 100px; text-align: center">Tran Class No</label>
		<label style="width:  80px; text-align: center">Branch Cd</label>
		<label style="width: 100px; text-align: center">Intm No</label>
		<label style="width: 100px; text-align: center">Line Cd</label>
		<label style="width: 100px; text-align: center">Subline Cd</label>
		<label style="width: 100px; text-align: center">Iss</label>
		<label style="width: 100px; text-align: center">Issue Yy</label>
		<label style="width: 100px; text-align: center">Pol Seq No</label>
		<label style="width: 100px; text-align: center">Renew No</label>
		<label style="width: 100px; text-align: center">Iss Cd</label>
		<label style="width: 100px; text-align: center">Prem Seq No</label>
		<label style="width: 100px; text-align: center">Comm Rec</label>
	</div>
	<div style="width: 2150px; overflow: auto;">
		<c:forEach var="oim" items="${searchResult}" varStatus="ctr">
			<div id="modalRow${ctr.index}" name="modalRow" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
				<label style="width: 100px; margin-left: 10px; text-align: right" id="modalLblOldItemNo${ctr.index}" name="modalLblOldItemNo" title="${oim.oldItemNo}">${oim.oldItemNo}</label>
				<label style="width: 100px; text-align: right"  id="modalLblOldTranType${ctr.index }">${oim.oldTranType }</label>
				<label style="width: 150px; text-align: right"  id="modalLblDspCollectionAmt${ctr.index }">${oim.dspCollectionAmt}</label>
				<label style="width: 100px; text-align: center" id="modalLblDspTranYear${ctr.index }">${oim.dspTranYear}</label>
				<label style="width: 100px; text-align: center" id="modalLblDspTranMonth${ctr.index }">${oim.dspTranMonth }</label>
				<label style="width: 100px; text-align: right"  id="modalLblDspTranSeqNo${ctr.index }">${oim.dspTranSeqNo }</label>
				<label style="width: 200px; text-align: center" id="modalLblDspParticulars${ctr.index }">${oim.dspParticulars }<c:if test="${empty oim.dspParticulars}">---</c:if></label>
				<label style="width: 100px; text-align: center" id="modalLblDspTranClass${ctr.index }">${oim.dspTranClass }</label>
				<label style="width: 100px; text-align: center" id="modalLblDspTranClassNo${ctr.index }">${oim.dspTranClassNo }</label>
				<label style="width:  80px; text-align: center" id="modalLblBranchCd${ctr.index }">${oim.branchCd }</label>
				<label style="width: 100px; text-align: center" id="modalLblIntmNo${ctr.index }">${oim.intmNo}<c:if test="${empty oim.intmNo}">---</c:if></label>
				<label style="width: 100px; text-align: center" id="modalLblLineCd${ctr.index }">${oim.lineCd}<c:if test="${empty oim.lineCd}">---</c:if></label>
				<label style="width: 100px; text-align: center" id="modalLblSublineCd${ctr.index }">${oim.sublineCd}<c:if test="${empty oim.sublineCd}">---</c:if></label>
				<label style="width: 100px; text-align: center" id="modalLblIssCd${ctr.index }">${oim.issCd}<c:if test="${empty oim.issCd}">---</c:if></label>
				<label style="width: 100px; text-align: center" id="modalLblIssueYy${ctr.index }">${oim.issueYy}<c:if test="${empty oim.issueYy}">---</c:if></label>
				<label style="width: 100px; text-align: center" id="modalLblPolSeqNo${ctr.index }">${oim.polSeqNo}<c:if test="${empty oim.polSeqNo}">---</c:if></label>
				<label style="width: 100px; text-align: center" id="modalLblRenewNo${ctr.index }">${oim.renewNo}<c:if test="${empty oim.renewNo}">---</c:if></label>
				<label style="width: 100px; text-align: center" id="modalLblB140IssCd${ctr.index }">${oim.b140IssCd}<c:if test="${empty oim.b140IssCd}">---</c:if></label>
				<label style="width: 100px; text-align: center" id="modalLblB140PremSeqNo${ctr.index }">${oim.b140PremSeqNo}<c:if test="${empty oim.b140PremSeqNo}">---</c:if></label>
				<label style="width: 100px; text-align: center" id="modalLblCommRecNo${ctr.index }">${oim.commRecNo}<c:if test="${empty oim.commRecNo}">---</c:if></label>
				<input type="hidden" id="modalRowOldItemNo${ctr.index }" 		name="modalRowOldItemNo" 	value="${oim.oldItemNo}"/>
				<input type="hidden" id="modalRowOldTranType${ctr.index }" 		name="modalRowOldTranType" 	value="${oim.oldTranType}"/>
				<input type="hidden" id="modalRowDspCollectionAmt${ctr.index }"	name="modalRow" 	value="${oim.dspCollectionAmt}"/>
				<input type="hidden" id="modalRowDspTranYear${ctr.index }" 		name="modalRow" 	value="${oim.dspTranYear}"/>
				<input type="hidden" id="modalRowDspTranMonth${ctr.index }" 	name="modalRow" 	value="${oim.dspTranMonth}"/>
				<input type="hidden" id="modalRowDspTranSeqNo${ctr.index }" 	name="modalRow" 	value="${oim.dspTranSeqNo}"/>
				<input type="hidden" id="modalRowDspParticulars${ctr.index }" 	name="modalRow" 	value="${oim.dspParticulars}"/>
				<!-- <input type="hidden" id="modalRowDspTranClass${ctr.index }" 	name="modalRow" 	value="${oim.dspTranClass}"/> -->
				<input type="hidden" id="modalRowDspTranClassNo${ctr.index }" 	name="modalRow" 	value="${oim.dspTranClassNo}"/>
				<input type="hidden" id="modalRowAssdNo${ctr.index }" 			name="modalRow" 	value="${oim.assdNo}"/>
				<input type="hidden" id="modalRowDepFlag${ctr.index }" 			name="modalRow" 	value="${oim.depFlag}"/>
				<input type="hidden" id="modalRowRiCd${ctr.index }" 			name="modalRow" 	value="${oim.riCd}"/>
				<!-- <input type="hidden" id="modalRowBranchCd${ctr.index }" 		name="modalRow" 	value="${oim.branchCd}"/>-->
				<input type="hidden" id="modalRowIntmNo${ctr.index }" 			name="modalRow" 	value="${oim.intmNo}"/>
				<input type="hidden" id="modalRowLineCd${ctr.index }" 			name="modalRow" 	value="${oim.lineCd}"/>
				<input type="hidden" id="modalRowSublineCd${ctr.index }" 		name="modalRow" 	value="${oim.sublineCd}"/>
				<input type="hidden" id="modalRowIssCd${ctr.index }" 			name="modalRow" 	value="${oim.issCd}"/>
				<input type="hidden" id="modalRowIssueYy${ctr.index }" 			name="modalRow" 	value="${oim.issueYy}"/>
				<input type="hidden" id="modalRowPolSeqNo${ctr.index }" 		name="modalRow" 	value="${oim.polSeqNo}"/>
				<input type="hidden" id="modalRowRenewNo${ctr.index }" 			name="modalRow" 	value="${oim.renewNo}"/>
				<input type="hidden" id="modalRowB140IssCd${ctr.index }" 		name="modalRow" 	value="${oim.b140IssCd}"/>
				<input type="hidden" id="modalRowB140PremSeqNo${ctr.index }" 	name="modalRow" 	value="${oim.b140PremSeqNo}"/>
				<input type="hidden" id="modalRowCommRecNo${ctr.index }" 		name="modalRow" 	value="${oim.commRecNo}"/>
			</div>
		</c:forEach>
	</div>
</div>
<div class="pager" style="width: 2150px" id="pager">
	<c:if test="${noOfPages>1}">
		<div align="right">
		Page:
			<select id="oimPage" name="oimPage">
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

	if ($("oimPage") != null) {
		$("oimPage").observe("change", function() {
			//onChange="searchCommPaytsBillNoDetails(this);"
			page = $("oimPage").options[$("oimPage").selectedIndex].value;
			if (!page.blank()) {
				showOldItemNoAjaxResult($("oimPage").options[$("oimPage").selectedIndex].value);
			}
		});
	}
</script>