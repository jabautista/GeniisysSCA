<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="availmentsMainDiv">
	<div id="availmentsHeaderDiv" name="availmentsHeaderDiv" style="margin-top: 10px; width: 99.5%;" class="sectionDiv">
		<table style="margin: 10px;">
			<tr>
				<td class="rightAligned" width="80px">Item </td>
				<td class="leftAligned">
					<input type="text" id="txtItemTitle" name="txtItemTitle" readonly="readonly" style="width: 230px;" value=""/>
				</td>
				<td class="rightAligned" width="80px">Peril </td>
				<td class="leftAligned">
					<input type="text" id="txtPerilName" name="txtPerilName" readonly="readonly" style="width: 230px;" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned"><span id="lblGroupedItemTitle" name="lblGroupedItemTitle">Grouped Item </span></td>
				<td class="leftAligned">
					<input type="text" id="txtGroupedItemTitle" name="txtGroupedItemTitle" readonly="readonly" style="width: 230px;" value="${groupedItemTitle}"/>
				</td>
				<td class="rightAligned" width="50px"><span id="lblTsiAmount" name="lblTsiAmount">TSI Amount </span></td>
				<td class="leftAligned">
					<input type="text" id="txtTsiAmount" name="txtTsiAmount" class="money" readonly="readonly" style="width: 230px;" value=""/>
				</td>
			</tr>
		</table>		
	</div>
	<div id="availmentsBodyDiv" name="availmentsBodyDiv" class="sectionDiv" style="width: 99.5%;">
		<div id="availmentsListTableGridDiv" name="availmentsListTableGridDiv" style="margin: 10px; margin-bottom: 27px;">
<!-- 			<div id="availmentsListTableGrid" style="height: 180px;">tablegrid</div> -->
		</div>
		<div>
			<table style="margin-bottom: 20px; margin-left: 164px; margin-right: 10px" align="right">
				<tr>
					<td class="rightAligned">Totals </td>
					<td class="leftAligned">
						<input type="text" id="txtTotalReserveAmount" name="txtTotalReserveAmount" readonly="readonly" style="width: 93px;" class="money" value=""/>
					</td>
					<td class="leftAligned">
						<input type="text" id="txtTotalPaidAmount" name="txtTotalPaidAmount" readonly="readonly" style="width: 93px;" class="money" value=""/>
					</td>
					<td class="leftAligned">
						<input type="text" id="txtTotalNoOfUnits" name="txtTotalNoOfUnits" readonly="readonly" style="width: 93px; text-align: right;" value=""/>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div align="center">
		<input type="button" class="button" id="btnReturn" value="Return" style="width: 80px;margin-top: 10px; margin-bottom: 10px;">
	</div>
</div>
<script type="text/javascript">
	try{
		initializeAvailmentsOverlay();
 		initializeAvailmentsTableGrid();
	} catch (e){
		showErrorMessage("availments", e);
	}
	
	$("btnReturn").observe("click", function(){
		overlayGICLS024Availments.close();
		delete overlayGICLS024Availments;
	});
	
	function initializeAvailmentsOverlay(){
		try{
			$("txtItemTitle").value = unescapeHTML2(objCurrGICLItemPeril.dspItemTitle); // Nica 06.21.2012 - added unescapeHTML2
			$("txtPerilName").value = unescapeHTML2(objCurrGICLItemPeril.dspPerilName);
			if ('${showGroupedItemNo}' == "false"){
				$("lblGroupedItemTitle").hide();
				$("txtGroupedItemTitle").hide();
			}
			
			if (nvl(objCurrGICLItemPeril.noOfDays, 0) != 0) {
				$("lblTsiAmount").innerHTML = "Allowable TSI / No. of Days ";
				$("txtTsiAmount").value = formatCurrency(objCurrGICLItemPeril.baseAmt) + " / " + objCurrGICLItemPeril.noOfDays;
			} else {
				$("lblTsiAmount").value = "TSI Amount ";
				$("txtTsiAmount").value = formatCurrency(objCurrGICLItemPeril.allowTsiAmt);
			}
		} catch(e){
			showErrorMessage("initializeAvailmentsOverlay", e);
		}
	}
	
	function initializeAvailmentsTableGrid(){
		var targetDiv = "availmentsListTableGridDiv"; 
		try{
			new Ajax.Updater(targetDiv, contextPath+"/GICLClaimReserveController",{
				method : "POST",
				parameters:{
					action: "getAvailmentsTableGrid",
					claimId : objCLMGlobal.claimId,
					lineCd : objCLMGlobal.lineCd,
					sublineCd : objCLMGlobal.sublineCd,
					polIssCd : objCLMGlobal.polIssCd,
					issueYy : objCLMGlobal.issueYy,
					polSeqNo : objCLMGlobal.polSeqNo,
					renewNo : objCLMGlobal.renewNo,
					perilCd : objCurrGICLItemPeril.perilCd,
					noOfDays : objCurrGICLItemPeril.noOfDays
				},
				evalScripts: true,
				asynchronous: false,
				onCreate : function(){
					$(targetDiv).hide();
				},
				onComplete : function(){
					$(targetDiv).show();
				}
			});
		} catch (e){
			showErrorMessage("initializeAvailmentsTableGrid", e);
		}
	}
</script>