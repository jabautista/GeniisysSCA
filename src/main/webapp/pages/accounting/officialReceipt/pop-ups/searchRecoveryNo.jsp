<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="contentsDiv">
	<div align="left">
		<table>
			<tr>
				<td class="rightAligned">Keyword </td>
				<td class="leftAligned"><input name="keyword" id="keyword" style="margin-bottom: 0; width: 200px;" type="text" value="${keyword }" /></td>
				<td><input id="searchRecoveryNo" class="button" type="button" style="width: 60px;" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 330px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<input type="button" id="btnRecoveryNoOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" id="btnRecoveryNoCancel" class="button" value="Cancel" style="width: 60px;" />
	</div>
</div>
<script type="text/javascript">
	searchRecoveryNoModal(1,$("keyword").value);

	//when CANCEL button click
	$("btnRecoveryNoCancel").observe("click", function (){
		Modalbox.hide();
	});

	//when SEARCH icon click
	$("searchRecoveryNo").observe("click", function(){
		searchRecoveryNoModal(1,$("keyword").value);
	});

	//when press ENTER on keyword field
	$("keyword").observe("keypress",function(event){
		if (event.keyCode == 13){
			searchRecoveryNoModal(1,$("keyword").value);
		}
	});

	//when OK button click
	$("btnRecoveryNoOk").observe("click",function(){
		var hasSelected = false;
		$$("div[name=rowRecoveryNoList]").each(function(row){
			if (row.hasClassName("selectedRow") && row.innerHTML != "No records available"){
				hasSelected = true;
				var id = getSelectedRowId("rowRecoveryNoList");
				for(var a=0; a<objSearchRecoveryNo.length; a++){
					if (objSearchRecoveryNo[a].divCtrId == id){
						for (var b=0; b<objAC.objLossRecAC010.length; b++){
							if (objSearchRecoveryNo[a].lineCd == objAC.objLossRecAC010[b].lineCd
									&& objSearchRecoveryNo[a].issCd == objAC.objLossRecAC010[b].issCd
									&& objSearchRecoveryNo[a].recYear == objAC.objLossRecAC010[b].recYear
									&& objSearchRecoveryNo[a].recSeqNo == objAC.objLossRecAC010[b].recSeqNo
									//&& getSelectedRowId("rowDirectTransLossRecoveries") != b
									&& objAC.objLossRecAC010[b].recordStatus != -1
									&& objSearchRecoveryNo[a].payorClassCd == objAC.objLossRecAC010[b].payorClassCd){ //marco - 12.19.2014 - added payorClassCd condition
								showMessageBox("Recovery Number should be unique.", imgMessage.ERROR);
								return false;
							}	
						}	
						$("txtLineCdLossRec").value					= changeSingleAndDoubleQuotes((objSearchRecoveryNo[a].lineCd == null ? "" :nvl(objSearchRecoveryNo[a].lineCd,"")));
						$("txtIssCdLossRec").value 					= changeSingleAndDoubleQuotes((objSearchRecoveryNo[a].issCd == null ? "" :nvl(objSearchRecoveryNo[a].issCd,"")));
						$("txtRecYearLossRec").value 				= (objSearchRecoveryNo[a].recYear == null ? "" :nvl(objSearchRecoveryNo[a].recYear,""));
						$("txtRecSeqNoLossRec").value				= (objSearchRecoveryNo[a].recSeqNo == null ? "" :nvl(objSearchRecoveryNo[a].recSeqNo,""));
						objAC.hidObjGIACS010.hidClaimId			= (objSearchRecoveryNo[a].claimId == null ? "" :nvl(objSearchRecoveryNo[a].claimId,""));
						$("txtDspClaimNoLossRec").value				= changeSingleAndDoubleQuotes((objSearchRecoveryNo[a].dspClaimNo == null ? "" :nvl(objSearchRecoveryNo[a].dspClaimNo,"")));
						$("txtDspPolicyNoLossRec").value			= changeSingleAndDoubleQuotes((objSearchRecoveryNo[a].dspPolicyNo == null ? "" :nvl(objSearchRecoveryNo[a].dspPolicyNo,"")));
						$("txtDspLossDateLossRec").value			= changeSingleAndDoubleQuotes((objSearchRecoveryNo[a].dspLossDate == null ? "" :nvl(dateFormat(objSearchRecoveryNo[a].dspLossDate.replace(/-/g,"/"),"mm-dd-yyyy"),"")));
						$("txtDspAssuredNameLossRec").value			= changeSingleAndDoubleQuotes((objSearchRecoveryNo[a].dspAssuredName == null ? "" :nvl(objSearchRecoveryNo[a].dspAssuredName,"")));
						objAC.hidObjGIACS010.hidRecoveryId		= (objSearchRecoveryNo[a].recoveryId == null ? "" :nvl(objSearchRecoveryNo[a].recoveryId,""));
						objAC.hidObjGIACS010.hidRecTypeCd		= (objSearchRecoveryNo[a].recTypeCd == null ? "" :nvl(objSearchRecoveryNo[a].recTypeCd,""));
						$("txtRecoveryTypeDescLossRec").value		= changeSingleAndDoubleQuotes((objSearchRecoveryNo[a].recTypeDesc == null ? "" :nvl(objSearchRecoveryNo[a].recTypeDesc,"")));
						$("readOnlyPayorClassCdLossRec").value = unescapeHTML2(objSearchRecoveryNo[a].payorClassDesc == null ? "" :nvl(objSearchRecoveryNo[a].payorClassDesc,""));
						updatePayeeLossRecLOV();
						$("selPayorClassCdLossRec").value 			= changeSingleAndDoubleQuotes((objSearchRecoveryNo[a].payorClassCd == null ? "" :nvl(objSearchRecoveryNo[a].payorClassCd,"")));
						objAC.hidObjGIACS010.hidPayorCd			= (objSearchRecoveryNo[a].payorCd == null ? "" :nvl(objSearchRecoveryNo[a].payorCd,""));
						$("txtPayorNameLossRec").value 				= changeSingleAndDoubleQuotes((objSearchRecoveryNo[a].payorName == null ? "" :nvl(objSearchRecoveryNo[a].payorName,"")));
						$("txtCollectionAmtLossRec").readOnly 		= false;
						$("foreignCurrAmtLossRec").readOnly 		= false;
						$("currencyCdLossRec").readOnly 			= false;
						$("convertRateLossRec").readOnly 			= false;
						if ($F("txtCollectionAmtLossRec") != ""){
							getCurrencyLossRec();
						}	
					}	
				}	
				Modalbox.hide();
			}
		});
		if (!hasSelected){
			Modalbox.hide();
		}
	});
	
</script>