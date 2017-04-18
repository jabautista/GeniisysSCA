<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>    
<div id="clmRecoveryDetailsMainDiv" style="width: 827px; margin-top: 5px;">
	<div id="clmRecoveryDetailsDiv" class="sectionDiv">
		<div id="clmRecoveryGrid1" style="height: 56px; width: 760px; margin: auto; margin-top: 3px; margin-bottom: 25px;"></div>
		<table border="0" align="center" style="margin-top: 5px; margin-bottom: 5px;">
			<tr>
				<td class="leftAligned" style="width: 110px;">Recoverable Amt.</td>
				<td class="rightAligned">
					<input style="width: 266px;" type="text" id="txtRecRecoverableAmt" name="txtRecRecoverableAmt" readonly="readonly" class="money">
				</td>
				<td>&nbsp;&nbsp;</td>
				<td class="leftAligned" style="width: 110px;">Third Party Item</td>
				<td class="rightAligned" rowspan="2">
					<div style="float:left; border: 1px solid gray; height: 45px; width: 288px;">
						<textarea readonly="readonly" onKeyDown="limitText(this,200);" onKeyUp="limitText(this,200);" id="txtThirdPartyItemDesc" name="txtThirdPartyItemDesc" style="float: left; width: 262px; border: none; height: 38px;"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editThirdPartyItemDesc" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="leftAligned" style="width: 110px;">Recovered Amt.</td>
				<td class="rightAligned">
					<input style="width: 266px;" type="text" id="txtRecRecoveredAmt" name="txtRecRecoveredAmt" readonly="readonly" class="money">
				</td>
				<td>&nbsp;&nbsp;</td>
				<td class="leftAligned" style="width: 110px;">Description</td>
			</tr>
			<tr>
				<td class="leftAligned" style="width: 110px; font-weight: bolder;" colspan="2">IN PROGRESS</td>
				<td>&nbsp;&nbsp;</td>
				<td class="leftAligned" style="width: 110px;">Plate No.</td>
				<td class="rightAligned">
					<input style="width: 282px;" type="text" id="txtRecPlateNo" name="txtRecPlateNo" readonly="readonly">
				</td>
			</tr>
		</table>
	</div>
	<div id="clmRecoveryDetailsDiv2" class="sectionDiv">
		
	</div>
	<div class="buttonDiv" id="clmRecoveryDetailsButtonDiv" style="float: left; width: 100%;">
		<table align="center" border="0" style="margin-top: 10px;">
			<tr>
				<td><input type="button" class="button" id="btnClmRecoveryDetailsExit" name="btnClmRecoveryDetailsExit" value="Return" style="width: 90px;" /></td>
			</tr>
		</table>
	</div>	
</div>
<script type="text/javascript">
try{
	//Initialize
	initializeAll();
	
	var recoveryGrid = JSON.parse('${recoveryTG}'.replace(/\\/g, '\\\\'));
	var recoveryRows = recoveryGrid.rows || [];
	var recoveryXX = null;
	var recoveryYY = null;
	var currRecovery = null;
	
	var recoveryTM = {
			url: contextPath+"/GICLClmRecoveryController?action=showClmRecoveryDetails"+
					"&claimId=" + ((recoveryGrid.rows.length > 0) ? recoveryGrid.rows[0].claimId : "")+
					"&refresh=1",
			options:{
				hideColumnChildTitle: true,
				title: '',
				newRowPosition: 'bottom',
				onCellFocus: function(element, value, x, y, id){ 
					recoveryXX = Number(x);
					recoveryYY = Number(y);  
				}, 
				onRemoveRowFocus: function ( x, y, element) {
					recoveryXX = null;
					recoveryYY = null;  
				} 	
			},
			columnModel: [
				{
				    id: 'recordStatus',
				    title : '',
		            width: '0',
		            visible: false,
		            editor: "checkbox"
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false
				},	
				{
				    id: 'lineCd issCd recYear recSeqNo',
				    title: 'Recovery Number',
				    width : '410px',
				    children : [
					            {
					                id : 'lineCd',
					                title: 'Line Code',
					                width: 65,
					                filterOption: true
					            },
					            {
					                id : 'issCd', 
					                title: 'Issue Code',
					                width: 95,
					                filterOption: true
					            }, 
					            {
					                id : 'recYear',
					                title: 'Recovery Year',
					                type: "number",
					                align: "right",
					                width: 65,
					                filterOption: true,
						            filterOptionType: 'number' 
					            },
					            {
					                id : 'recSeqNo',
					                title: 'Recovery Sequence Number',
					                type: "number",
					                align: "right",
					                width: 105,
					                filterOption: true,
						            filterOptionType: 'number',
					                renderer: function (value){
										return nvl(value,'') == '' ? '' :formatNumberDigits(value,3);
									}
					            }
								]
				},
				{
				    id: 'lawyerCd dspLawyerName',
				    title: 'Lawyer',
				    width : '400px',
				    children : [
					            {
					                id : 'lawyerCd',
					                title: 'Lawyer Code',
					                width: 80,
					                filterOption: true
					            },
					            {
					                id : 'dspLawyerName', 
					                title: 'Lawyer Name',
					                width: 320,
					                filterOption: true
					            } 
								]
				},
				{
					id: 'recoverableAmt',
					width: '0',
					visible: false
				},
				{
					id: 'recoveredAmt',
					width: '0',
					visible: false
				},
				{
					id: 'tpItemDesc',
					width: '0',
					visible: false
				},
				{
					id: 'plateNo',
					width: '0',
					visible: false
				},
				{
					id: 'claimId',
					width: '0',
					visible: false
				},
				{
					id: 'recoveryId',
					width: '0',
					visible: false
				}
			], 
			rows: recoveryRows,
			id: 10
	};
	
	function showRecoverySubDetails(claimId, recoveryId){
		try{
			new Ajax.Request(contextPath+"/GICLClmRecoveryController",{
				parameters: {
					action: "showRecoverySubDetails",
					claimId: claimId,
					recoveryId: recoveryId
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						$("clmRecoveryDetailsDiv2").update(response.responseText);
					}
				}	
			});
		}catch(e){
			showErrorMessage("showRecoverySubDetails", e);	
		}	
	}	

	function populateRecovery(obj){
		try{
			currRecovery = obj;
			$("txtRecRecoverableAmt").value 	= nvl(obj,null) != null ? nvl(obj.recoverableAmt,null) != null ? formatCurrency(obj.recoverableAmt) :null :null;
			$("txtRecRecoveredAmt").value 		= nvl(obj,null) != null ? nvl(obj.recoveredAmt,null) != null ? formatCurrency(obj.recoveredAmt) :null :null;
			$("txtThirdPartyItemDesc").value 	= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.tpItemDesc,null)) :null;
			$("txtRecPlateNo").value 			= nvl(obj,null) != null ? unescapeHTML2(nvl(obj.plateNo,null)) :null;
			recoveryTG.keys.releaseKeys();
			if (nvl(obj,null) != null) showRecoverySubDetails(obj.claimId, obj.recoveryId);
		}catch(e){
			showErrorMessage("populateRecovery", e);	
		}
	}
	
	recoveryTG = new MyTableGrid(recoveryTM);
	recoveryTG.pager = recoveryGrid; 
	recoveryTG._mtgId = 10;
	recoveryTG.afterRender = function(){
		if (recoveryTG.rows.length > 0){
			recoveryYY = Number(0);
			recoveryTG.selectRow('0');
			populateRecovery(recoveryTG.getRow(recoveryYY));
		}	
	};
	recoveryTG.render('clmRecoveryGrid1');
	
	//Observe Return BUTTON
	$("btnClmRecoveryDetailsExit").observe("click", function(){
		Windows.close("clm_recovery_details_view");
	});	
	
	//Observe Third Party Item Description BUTTON
	$("editThirdPartyItemDesc").observe("click", function () {
		showEditor("txtThirdPartyItemDesc", 200, 'true');
	});

	hideNotice("");
}catch(e){
	showErrorMessage("Recovery Details Page", e);	
}	
</script>