<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="certPolicyListingMainDiv">
	<div id="certPolicyListinTable">
	</div>
</div>
<div id="certPolicyListingMainDiv" style="margin-top: 10px; margin-bottom: 10px; float: left; width: 99%;">
	<div id="certPolicyListingDiv">
		<div id="certPolicyListinTableDiv" style="">
			<div id="policyTable" style="height: 330px"></div>
		</div>
	</div>
</div>
<div id="buttonsDiv" style="float: left; width: 100%;">
	<table align="center">
		<tr>
			<td>
				<input type="button" class="button" style="width: 90px;" id="btnOk" name="btnOk" value="Ok" />
				<input type="button" class="button" style="width: 90px;" id=btnCancelPolicyListing name="btnCancelPolicyListing" value="Cancel" />
			</td>
		</tr>
	</table>
</div>	
<script>
	objCurrentPolicy = null;
	$("btnCancelPolicyListing").observe("click", function(){
		tbgCertPolicyListing.releaseKeys();
		overlayReprintPolicyListing.close();
	});
	
	var objCertPolicyList = JSON.parse('${certPolicyListing}');
	
	if (objCertPolicyList.length == 0){
		showMessageBox("Query caused no record to be retrieved. Re-enter.", imgMessage.INFO);
	}	
	
	var certPolicyTableModel = {
			//added parameters, from sublineCd to assdName | cherrie | 03.19.2014
			url: contextPath+"/GIPIPolbasicController?action=getCertPolicyTableGridListing&refresh=1&lineCd="+$F("txtLineCd")+
					"&sublineCd="+$F("txtSublineCd")+"&issCd="+$F("txtIssCd")+"&issueYy="+$F("txtIssueYy")+"&polSeqNo="+$F("txtPolSeqNo")+
					"&renewNo="+$F("txtRenewNo")+"&endtLineCd="+$F("txtCLineCd")+"&endtSublineCd="+$F("txtCSublineCd")+
					"&endtIssCd="+$F("txtCEndtIssCd")+"&endtYy="+$F("txtEndtYy")+"&endtSeqNo="+$F("txtEndtSeqNo")+"&assdName="+$F("assdName"),
			options: {
				width: '845px',
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
				},				
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {
					var mtgId = tbgCertPolicyListing._mtgId;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){						
						objCurrentPolicy = tbgCertPolicyListing.geniisysRows[y];
					}
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					objCurrentPolicy = null;
				},
				onRowDoubleClick: function(y){							
					objCurrentPolicy = tbgCertPolicyListing.geniisysRows[y];
					loadSelectedCertPolicy(objCurrentPolicy);
					tbgCertPolicyListing.releaseKeys();
					overlayReprintPolicyListing.close();
				},
				prePager: function (){

				}
			},							
			columnModel: [
				{
				    id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},         
				{
					id : "policyNo",
					title: "Policy No.",
					width: '170px',
					filterOption: true					
				},
				{
					id : "endtNo",
					title: "Endt No.",
					width: '160px',
					filterOption: true					
				},				
				{
					id : "parNo",
					title: "Par No.",
					width: '150px',
					filterOption: true			
				},
				{
					id : "assdName",
					title: "Assured Name",
					width: '350px',
					filterOption: true
				}
				],
			rows: objCertPolicyList.rows
		};

	tbgCertPolicyListing = new MyTableGrid(certPolicyTableModel);
	tbgCertPolicyListing.pager = objCertPolicyList;
	tbgCertPolicyListing.render('policyTable');
	
 	$("btnOk").observe("click", function(){
 		if(objCurrentPolicy == null){
 			showMessageBox("No record selected.","I");
 		}else{
 			loadSelectedCertPolicy(objCurrentPolicy);
 			tbgCertPolicyListing.releaseKeys();
 			overlayReprintPolicyListing.close();
 		}
 		
	});

 	function loadSelectedCertPolicy(pol) {
		try {
			$("txtLineCd").value 	= unescapeHTML2(pol.lineCd);
			$("txtSublineCd").value = unescapeHTML2(pol.sublineCd); 
			$("txtIssCd").value 	= unescapeHTML2(pol.issCd);
			$("txtIssueYy").value 	= formatNumberDigits(pol.issueYy, 2);
			$("txtPolSeqNo").value 	= formatNumberDigits(pol.polSeqNo, 7);
			$("txtRenewNo").value 	= formatNumberDigits(pol.renewNo, 2);
			if (nvl(pol.endtSeqNo, "0") != "0"){
				$("txtCLineCd").value 		= unescapeHTML2(pol.lineCd);
				$("txtCSublineCd").value 	= unescapeHTML2(pol.sublineCd);
				$("txtCEndtIssCd").value 	= unescapeHTML2(pol.endtIssCd);
				$("txtEndtYy").value 		= formatNumberDigits(pol.endtYy, 2);
				$("txtEndtSeqNo").value 	= formatNumberDigits(pol.endtSeqNo, 7);
			}
			$("assdName").value 	= unescapeHTML2(pol.assdName);
			$("parNo").value 		= unescapeHTML2(pol.parNo);
			$("policyId").value		= pol.policyId;
			$("lineCd").value 		= unescapeHTML2(pol.lineCd);
			$("menulineCd").value 	= unescapeHTML2(pol.menulineCd);
			
			$$("input[name='capsField']").each(function(field){
				field.readOnly = true;
			});
			$$("input[name='intField']").each(function(field){
				field.readOnly = true;
			});
			$("searchForPolicy").stopObserving();
			
			return false;				
		} catch(e) {
			showErrorMessage("loadSelectedPolicy", e);
		}
	}		
</script>