<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="reprintPolicyListingMainDiv">
	<div id="reprintPolicyListinTable">
	</div>
</div>
<div id="reprintPolicyListingMainDiv" style="margin-top: 10px; margin-bottom: 10px; float: left; width: 99%;">
	<div id="reprintPolicyListingDiv">
		<div id="reprintPolicyListinTableDiv" style="">
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
		tbgReprintPolicyListing.keys.removeFocus(tbgReprintPolicyListing.keys._nCurrentFocus, true);
		tbgReprintPolicyListing.keys.releaseKeys();
		overlayReprintPolicyListing.close();
	});	
	var objGIPIPolbasic = JSON.parse('${polbasicListing}');//.replace(/\\/g, '\\\\'));
	if (objGIPIPolbasic.length == 0){
		showMessageBox("Query caused no record to be retrieved. Re-enter.", imgMessage.INFO);
	}	
	
	//added the other parameters based on reprintPolicyDetails.jsp $("searchForPolicy").observe("click", function()
	//reymon 11112013
	// bonok :: 4.4.2016 :: UCPB SR-22004 :: added encodeURIComponent to url to handle '+'
	var policyTableModel = {
			url: contextPath+"/GIPIPolbasicController?action=getPolicyTableGridListing&refresh=1&lineCd="+encodeURIComponent($F("txtLineCd"))
							+"&sublineCd="+encodeURIComponent($F("txtSublineCd"))+"&issCd="+encodeURIComponent($F("txtIssCd"))+"&issueYy="+$F("txtIssueYy")+"&polSeqNo="+$F("txtPolSeqNo")
							+"&renewNo="+$F("txtRenewNo")+"&endtLineCd="+encodeURIComponent($F("txtCLineCd"))+"&endtSublineCd="+encodeURIComponent($F("txtCSublineCd"))+"&endtIssCd="+encodeURIComponent($F("txtCEndtIssCd"))
							+"&endtYy="+$F("txtEndtYy")+"&endtSeqNo="+$F("txtEndtSeqNo")+"&assdName="+$F("assdName"),
			options: {
				width: '845px',
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
				},				
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {
					var mtgId = tbgReprintPolicyListing._mtgId;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){						
						objCurrentPolicy = tbgReprintPolicyListing.geniisysRows[y];
					}
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					objCurrentPolicy = null;
				},
				onRowDoubleClick: function(y){							
					objCurrentPolicy = tbgReprintPolicyListing.geniisysRows[y];					
					loadSelectedPolicy(objCurrentPolicy);				
					overlayReprintPolicyListing.close();
					tbgReprintPolicyListing.keys.removeFocus(tbgReprintPolicyListing.keys._nCurrentFocus, true);
					tbgReprintPolicyListing.keys.releaseKeys();
					
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
					width: '160px',
					filterOption: true					
				},
				{
					id : "endtNo",
					title: "Endt No.",
					width: '180px',
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
					width: '190px',
					filterOption: true
				},
				{
					id : "dspPremSeqNo",
					title: "Prem. Seq. No.",
					width: '120px',
					filterOption: true
				}
				],
			rows: objGIPIPolbasic.rows
		};

	tbgReprintPolicyListing = new MyTableGrid(policyTableModel);
	tbgReprintPolicyListing.pager = objGIPIPolbasic;
	tbgReprintPolicyListing.render('policyTable');
	
 	$("btnOk").observe("click", function(){
 		if(objCurrentPolicy == null){
 			showMessageBox("No record selected.","I");
 		}else{
 			loadSelectedPolicy(objCurrentPolicy);
 			tbgReprintPolicyListing.keys.removeFocus(tbgReprintPolicyListing.keys._nCurrentFocus, true);
 			tbgReprintPolicyListing.keys.releaseKeys();
 			overlayReprintPolicyListing.close();
 		}
		
	});

 	function loadSelectedPolicy(pol) {
		try {
			$("txtLineCd").value 	= pol.lineCd;
			$("txtSublineCd").value = unescapeHTML2(pol.sublineCd); //lara 12/06/2013
			$("txtIssCd").value 	= pol.issCd;
			$("txtIssueYy").value 	= formatNumberDigits(pol.issueYy, 2);//.toPaddedString(2);
			$("txtPolSeqNo").value 	= formatNumberDigits(pol.polSeqNo, 7);//.toPaddedString(6);
			$("txtRenewNo").value 	= formatNumberDigits(pol.renewNo, 2);
			if (nvl(pol.endtSeqNo, "0") != "0"){
				$("txtCLineCd").value 		= pol.lineCd;
				$("txtCSublineCd").value 	= pol.sublineCd;
				$("txtCEndtIssCd").value 	= pol.endtIssCd;
				$("txtEndtYy").value 		= formatNumberDigits(pol.endtYy, 2);
				$("txtEndtSeqNo").value 	= formatNumberDigits(pol.endtSeqNo, 6);

				$("abbreviated").show();
				$("lblAbbreviated").show();
			} else {
				$("abbreviated").hide();
				$("lblAbbreviated").hide();
			}
			
			$("assdName").value 	= unescapeHTML2(pol.assdName);
			$("parNo").value 		= pol.parNo;
			$("txtPremSeqNo").value = pol.dspPremSeqNo; //(pol.premSeqNo != null) ? (pol.issCd + "-" + pol.premSeqNo.toPaddedString(8)) : "" ;
			$("policyId").value		= pol.policyId;
			$("parId").value		= pol.parId; // andrew - 06.01.2012
			$("policyLineCd").value = nvl(pol.menuLineCd, pol.lineCd); //pol.lineCd; //jeffdojello 05.30.2013
			$("issCd").value 		= pol.issCd;
			$("sublineCd").value 	= pol.sublineCd;
			$("cocType").value 		= pol.cocType;
			$("endtTax").value 		= pol.endtTax;
			$("renewNo").value 		= pol.renewNo;
			$("packPolFlag").value 	= pol.packPolFlag; // added by: nica 04.18.2011 necessary for package printing
			$("polFlag").value 		= pol.polFlag;
			$$("input[name='capsField']").each(function(field){
				field.readOnly = true;
			});
			$$("input[name='intField']").each(function(field){
				field.readOnly = true;
			});
			disableSearch("searchForPolicy");
			
			new Ajax.Request(contextPath + "/GIPIPolbasicController?action=getOtherPolicyDetails&policyId="+pol.policyId+"&parId="+pol.parId+"&packPolFlag="+pol.packPolFlag+"&lineCd="+pol.lineCd, {
				method : "POST",
				asynchronous : false,
				evalScripts : true,
				onComplete : function(response){
					if (checkErrorOnResponse(response)) {
						
						var a = response.responseText.split(",");
						$("compulsoryDeath").value 	= a[0];
						$("itmperilCount").value 	= a[1];
						$("vWarcla2").value     	= a[6]; //Dren 02.02.2016 SR-5266
						if (a[2]=="Y"){
							showMessageBox("Total Amount Due is 0, bill will not be printed.", imgMessage.INFO);
							$("docType").childElements().each(function (o) {
								if (o.value == "BILL"){
									o.hide();
								}
							});
						}
						
/* 						if ($F(txtLineCd) == "SU"){
							$("docType").childElements().each(function (o) {
								if (o.value == "WARRANTIES AND CLAUSES"){
									o.hide(); alert("hideee");
								}
							});							
						} */
						
						$("endtTax2").value = a[3];
						
						//marco - 11.19.2012 - for Print Premium Details option
						var printPremDetails = a[4];
						if(printPremDetails == "Y"){
							$("printPremium").show();
							$("lblPrintPremium").show();
						}

						$("withMc").value 	= a[5];
						
						


						
						//alert("txtLineCd: "+$F(txtLineCd));
					}
				}
			});
			
			//var lineCd = objGIPIPolbasic[i].lineCd == "PA" ? "AC" : objGIPIPolbasic[i].lineCd; replaced by: nica 04.19.2011 - to handle all lines
			//var lineCd = nvl(pol.menulineCd, pol.lineCd); replaced by jeffdojello 11.12.13
			var lineCd = nvl(pol.menuLineCd, pol.lineCd); //jeffdojello 11.12.13
			new Ajax.Request(contextPath + "/GIPIPolbasicController?action=getReportsListingForPolicy&lineCd="+lineCd, {
				method : "POST",
				asynchronous : false,
				evalScripts : true,
				onComplete : function(response){
					if (checkErrorOnResponse(response)) {
						var objReports = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
						for (var i=0; i<objReports.length; i++){
							var newDiv 		= new Element("div");
							var reportId	= objReports[i].reportId;
							var reportTitle	= objReports[i].reportTitle;
							newDiv.setAttribute("id", "row"+reportId);
							newDiv.setAttribute("name", "report");
							newDiv.addClassName("tableRow");
							newDiv.setAttribute("reportId", reportId);
							newDiv.setAttribute("reportTitle", reportTitle);
							newDiv.setStyle("display: none;");
							$("reportsDiv").insert({bottom: newDiv});
						}
					}
				}
			});

			$("vWarcla3").value = $F("vWarcla2"); //Dren 02.02.2016 SR-5266	
			manageDocTypes();
			hideOverlay();
			
			return false;				
		} catch(e) {
			showErrorMessage("loadSelectedPolicy", e);
		}
	}		
</script>