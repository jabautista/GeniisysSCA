<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>    
<div id="clmPolicyNoListingGrid" style="height: 306px; width: 525px; margin-top: 10px; margin-bottom: 25px;"></div>
<div class="buttonDiv" id="clmPolicyNoListingButtonDiv" style="float: left; width: 100%;">
	<table align="center" border="0" style="margin-top: 10px;">
		<tr>
			<td><input type="button" class="button" id="btnClmPolicyNoListOk" name="btnClmPolicyNoListOk" value="Ok" style="width: 90px;" /></td>
			<td><input type="button" class="button" id="btnClmPolicyNoListExit" name="btnClmPolicyNoListExit" value="Cancel" style="width: 90px;" /></td>
		</tr>
	</table>
</div>	
<script type="text/javascript">
try{
	//Initialize
	initializeAll();
	
	var polNosGrid = JSON.parse('${perPolicyTG}'.replace(/\\/g, '\\\\'));
	var polNos = polNosGrid.rows || [];
	var currXX = null;
	var currYY = null;

	if (polNos.length == 0){
		showMessageBox("Record does not exist.", "I");
		var obj = new Object();
		obj.lineCode = $F("txtNbtLineCd");
		obj.sublineCd = $F("txtNbtSublineCd"); 
		obj.policyIssueCode = $F("txtNbtPolIssCd"); 
		obj.issueYy = $F("txtNbtIssueYy"); 
		obj.policySequenceNo = $F("txtNbtPolSeqNo"); 
		obj.renewNo = $F("txtNbtRenewNo");  
		obj.assuredName = escapeHTML2($F("txtNbtAssuredName")); 
		populateClmPerPolicy(obj);
		Windows.close("clm_policy_no_listing_view");
	/* }else if (polNos.length == 1){
		populateClmPerPolicy(polNos[0]);
		Windows.close("clm_policy_no_listing_view"); */
	}else{
		var policyNosTM = {
				url: contextPath+"/GICLClaimsController?action=showClmPolicyNoLOV"+
						"&lineCd=" + $F("txtNbtLineCd")+
						"&sublineCd=" + $F("txtNbtSublineCd")+
						"&polIssCd=" + $F("txtNbtPolIssCd")+
						"&issueYy=" + $F("txtNbtIssueYy")+
						"&polSeqNo=" + $F("txtNbtPolSeqNo")+
						"&renewNo=" + $F("txtNbtRenewNo")+
						"&module=GICLS250"+
						"&refresh=1",
				options:{
					hideColumnChildTitle: true,
					title: '',
					newRowPosition: 'bottom',
					onCellFocus: function(element, value, x, y, id){ 
						currXX = Number(x);
						currYY = Number(y);
					},
					onRowDoubleClick: function(y){
						currYY = Number(y);  
						fireEvent($("btnClmPolicyNoListOk"),"click");				                	
					},
					onRemoveRowFocus: function ( x, y, element) {
						currXX = null;
						currYY = null; 
					},
					toolbar:{
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
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
					    id: 'lineCode sublineCd policyIssueCode issueYy policySequenceNo renewNo',
					    title: 'Policy Number',
					    width : '310px',
					    children : [
						            {
						                id : 'lineCode',
						                title: 'Line Code',
						                width: 40/* ,
						                filterOption: true */
						            },
						            {
						                id : 'sublineCd', 
						                title: 'Subline Code',
						                width: 70/* ,
						                filterOption: true */
						            },
						            {
						                id : 'policyIssueCode',
						                title: 'Issue Code',
						                width: 40,
						                filterOption: true
						            },
						            {
						                id : 'issueYy',
						                title: 'Issue Year',
						                type: "number",
						                align: "right",
						                width: 40,
						                filterOption: true,
							            filterOptionType: 'number',
						                renderer: function (value){
											return nvl(value,'') == '' ? '' :formatNumberDigits(value,2);
										}
						            },
						            {
						                id : 'policySequenceNo',
						                title: 'Policy Sequence Number',
						                type: "number",
						                align: "right",
						                width: 80,
						                filterOption: true,
							            filterOptionType: 'number',
						                renderer: function (value){
											return nvl(value,'') == '' ? '' :formatNumberDigits(value,7);
										}
						            },
						            {
						                id : 'renewNo',
						                title: 'Renew Number',
						                type: "number",
						                align: "right",
						                width: 40,
						                filterOption: true,
							            filterOptionType: 'number', 		
						                renderer: function (value){
											return nvl(value,'') == '' ? '' :formatNumberDigits(value,2);
										}
						            }
									]
					},
					{
						id: 'assuredName',
						title: 'Assured',
						width: 195,
						visible: true,
						filterOption: true
					}  
				], 
				rows: polNos,
				id: 2
		};
	
		policyNosTG = new MyTableGrid(policyNosTM);
		policyNosTG.pager = polNosGrid; 
		policyNosTG._mtgId = 2;
		policyNosTG.render('clmPolicyNoListingGrid');
		policyNosTG.afterRender = function(){
			if(policyNosTG.geniisysRows.length == 1){
				//policyNosTG.selectRow('0');
				objPolicy = new Object();
				objPolicy = policyNosTG.getRow(0);
				var obj = policyNosTG.getRow(0);
				enableToolbarButton("btnToolbarExecuteQuery");
				$("txtNbtLineCd").value = obj.lineCode;
				$("txtNbtSublineCd").value = obj.sublineCd;
				$("txtNbtPolIssCd").value = obj.policyIssueCode;
				$("txtNbtIssueYy").value = formatNumberDigits(obj.issueYy,2);
				$("txtNbtPolSeqNo").value = formatNumberDigits( obj.policySequenceNo,7);
				$("txtNbtRenewNo").value = formatNumberDigits(obj.renewNo ,2);
				$("txtNbtAssuredName").value =  unescapeHTML2(obj.assuredName);
				policyNosTG.keys.releaseKeys();
				Windows.close("clm_policy_no_listing_view");
			}
		};
		
		//Observe Cancel BUTTON
		$("btnClmPolicyNoListExit").observe("click", function(){
			policyNosTG.keys.releaseKeys();
			Windows.close("clm_policy_no_listing_view");
		});	
		
		//Observe Ok BUTTON
		$("btnClmPolicyNoListOk").observe("click", function(){
			if (currYY == null){
				showMessageBox("No record selected.", "I");
			}else{
				objPolicy = new Object();
				objPolicy = policyNosTG.getRow(currYY);
				var obj = policyNosTG.getRow(currYY);
				enableToolbarButton("btnToolbarExecuteQuery");
				$("txtNbtLineCd").value = obj.lineCode;
				$("txtNbtSublineCd").value = obj.sublineCd;
				$("txtNbtPolIssCd").value = obj.policyIssueCode;
				$("txtNbtIssueYy").value = formatNumberDigits(obj.issueYy,2);
				$("txtNbtPolSeqNo").value = formatNumberDigits( obj.policySequenceNo,7);
				$("txtNbtRenewNo").value = formatNumberDigits(obj.renewNo ,2);
				$("txtNbtAssuredName").value =  unescapeHTML2(obj.assuredName);
				/* if (nvl(obj,null) != null){
					populateClmPerPolicy(obj);
				} */
				// retrieving of records will occur when btnToolbarExecuteQuery is pressed
				// pol cruz
				// 03.22.2013
			}	
			policyNosTG.keys.releaseKeys();
			Windows.close("clm_policy_no_listing_view");
		});	
	}
}catch(e){
	showErrorMessage("Policy listing page", e);	
}	
</script>	