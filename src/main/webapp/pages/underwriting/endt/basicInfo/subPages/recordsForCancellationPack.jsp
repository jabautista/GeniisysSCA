<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c"  uri="/WEB-INF/tld/c.tld" %>

<%
	request.setAttribute("contextPath", request.getContextPath());
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<br />
<div id="recordsForCancellationDiv" name="recordsForCancellationDiv" style="width: 100%;">   
    <div id="searchResultParItem" align="center" style="margin: 10px;">
        <div style="width: 100%; " id="cancelTable" name="cancelTable">
            <div class="tableHeader">
                <label style="width: 83%; text-align: left;">Endorsement No.</label>                
                <label style="width: 15%; text-align: left;"></label>
            </div>
            <div id="cancelTableContainer" class="tableContainer">
            	<input type="hidden" id="policyId" name="policyId" value="" />          	
                <c:forEach var="recordMap" items="${recordMaps}" varStatus="ctr">
                	<div id="row${recordMap['policyId']}" name="row" class="tableRow" policyId="${recordMap['policyId']}" style="padding-left:1px;" />
                		<label style="width: 83%; text-align: left; margin-right: 10px;"><c:out value="${recordMap['endorsement']}"></c:out></label>                
                		<%-- <label style="width: 15%; text-align: right; align: right"><c:out value="${recordMap['policyId']}"></c:out></label> --%>
                	</div>
                </c:forEach>
                <br />
                <div align="right">
                	<input type="button" class="button" style="width : 100px;" id="btnOk" 		name="btnOk"	value="Ok" />
                	<input type="button" class="button" style="width : 100px;" id="btnCncl" 	name="btnCncl" 	value="Cancel" />                	
                </div>                            
            </div>                    
        </div>       
    </div>
</div>

<script type="text/javascript">
	//$("b540CancelType").value = objUW.GIPIS031.gipiWPolbas.cancelType;
	$$("div[name='row']").each(
		function(row){
			row.observe("mouseover", 
				function(){
					row.addClassName("lightblue");
			});

			row.observe("mouseout",
				function(){
					row.removeClassName("lightblue");
			});
			
			row.observe("click",
				function(){					
					row.toggleClassName("selectedRow");
					if(row.hasClassName("selectedRow")){							
						$$("div[name='row']").each(
							function(r){									
								if(row.getAttribute("id") != r.getAttribute("id")){
									r.removeClassName("selectedRow");
								}									
							});	
						$("parCancelPolId").value = row.getAttribute("policyId");
					} else{
						$("parCancelPolId").value = "";						
					}										
			});		
		});

	$("btnOk").observe("click", function(){
		if($F("parCancelPolId") == "" | $F("parCancelPolId").empty()){
			showMessageBox("Please select a record to cancel", imgMessage.ERROR);
			return false;
		}
		
		new Ajax.Request(contextPath + "/GIPIPackParInformationController?action=processPackEndtCancellation", {
			method : "GET",
			parameters : {
				parId : $F("globalPackParId"),
				policyId : $F("parCancelPolId"),
				lineCd : $F("b540LineCd"),
				sublineCd : $F("b540SublineCd"),
				issCd : $F("b540IssCd"),
				issueYy : $F("b540IssueYY"),
				polSeqNo : $F("b540PolSeqNo"),
				renewNo : $F("b540RenewNo"),
				packPolFlag : $F("b540PackPolFlag"),
				//cancelType : $F("b540CancelType"),				
				effDate : $F("b540EffDate")
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : showNotice("Cancelling, please wait..."),
			onComplete : 
				function(response){
					if (checkErrorOnResponse(response)){
						hideNotice("Done!");
						//var result = response.responseText.toQueryParams();
						var result = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
						if(nvl(result.msgAlert,null) == null){
							$("b540ProrateFlag").value = result.prorateFlag;
							$("b540ProvPremPct").value = nvl(result.provPremPct,null) != null ? result.provPremPct : "0";
							$("b540ProvPremTag").value = result.provPremTag;
							$("shortRatePercent").value = nvl(result.shortRtPercent,null) != null ? result.shortRtPercent : "0";
							$("compSw").value = result.compSw;
							$("b540PremAmt").value = result.premAmt;
							$("b540TsiAmt").value = result.tsiAmt;
							$("endtEffDate").value = result.effDate != null ? result.effDate.substr(0, 10) : $F("b540EffDate").substr(0, 10); 			
							$("endtExpDate").value = result.endtExpiryDate != null ? result.endtExpiryDate.substr(0, 10) : $F("b540EndtExpiryDate").substr(0, 10);
							$("doe").value = result.expiryDate != null ? result.expiryDate.substr(0, 10) : $F("b540ExpiryDate").substr(0, 10);
							$("b540AnnPremAmt").value = result.annPremAmt;
							$("b540AnnTsiAmt").value = result.annTsiAmt;
							$("parStatus").value = result.parStatus;
							//$("varOldEndtExpiryDate").value = result.varOldEndtExpiryDate != null ? result.varOldEndtExpiryDate : $F("b540EffDate");
							//$("varOldDateExp").value = result.varOldDateExp != null ? result.varOldDateExp : $F("b540EffDate");
							$("varOldEndtExpiryDate").value = result.endtExpiryDate;
							$("varOldDateExp").value = result.endtExpiryDate;
							$("varOldDateEff").value = result.effDate;
							$("varOldExpiryDate").value = result.expiryDate;
							$("varOldInceptDate").value = $F("b540InceptDate");
							$("varOldEffDate").value = result.effDate;
							$("b540CancelledEndtId").value = $F("parCancelPolId"); //robert 9.21.2012
							$("clickCancelled").value = "Y"; //added by robert GENQA 4844 09.02.15
							$("clickEndtCancellation").value = "Y"; //added by robert GENQA 4844 09.02.15
							$("endtCancellation").checked = "Y";  //added by robert GENQA 4844 09.02.15
							//showMessageBox("Endorsement successfully cancelled.", imgMessage.INFO);
							
							objUW.saveEndorsementBasicInfo("Y");
							hideOverlay();
							
						}else{
							showMessageBox(result.msgAlert, imgMessage.ERROR);
						}						
						hideOverlay();						
					}											
				}
		});
	});

	$("btnCncl").observe("click", function(){		
		$("parCancelPolId").value = "";
		showWaitingMessageBox("No Endorsement chosen to be cancelled.", imgMessage.INFO, function(){
			hideOverlay();
			return false;
		});
	});
</script>