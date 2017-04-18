<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="enterCheckDateMainDiv" class="sectionDiv" align="center" style="height: 117px; width: 298px; margin: 5px 0 0 0;">
	<table style="margin: 17px 0 5px 0;">
		<tr>
			<td colspan="2"><label>Please enter the Check Date</label></td>
		</tr>
		<tr>
			<td colspan="2">
				<div id="divCheckDate" style="padding: 1px 2px 0 0; float: left; margin: 0 0 15px 30px; width: 104px;" class="withIconDiv">
					<input style="width: 81px; height: 13px;" class="withIcon" id="genCheckDate" name="genCheckDate" type="text" readOnly="readonly" tabindex="201"/>
					<img id="hrefCheckDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" onClick="scwShow($('genCheckDate'),this, null);"/>
				</div>
			</td>
		</tr>
		<tr>
			<td><input id="btnOkDate" name="btnOkDate" type="button" class="button" value="Ok" tabindex="202"></td>
			<td><input id="btnCancelDate" name="btnCancelDate" type="button" class="button" value="Cancel" tabindex="203"></td>
		</tr>
	</table>	
</div>

<script type="text/javascript">
	var latestDvDate = dateFormat(new Date(), "mm-dd-yyyy");
	var objArray = objGIACS054.tempTaggedRecords;
	var TGUrl = checkDetailsTG.url;
	var filterBy = checkDetailsTG.objFilter;
	var inTranIdItemNo = null;
			
	for (var a=0; a < objArray.length; a++){
		var dvDate = dateFormat(objArray[a].dvDate, "mm-dd-yyyy");
		var tranIdItemNo = objArray[a].gaccTranId + "--" + objArray[a].itemNo;
		if (a == 0){
			latestDvDate = dvDate;
			inTranIdItemNo = "'" + tranIdItemNo + "'";
		}else{
			if (compareDatesIgnoreTime(Date.parse(latestDvDate), Date.parse(dvDate)) == 1){
				latestDvDate = dvDate;
			}
			inTranIdItemNo = inTranIdItemNo + ",'" + tranIdItemNo + "'";
		}		
	}

	inTranIdItemNo = (inTranIdItemNo == null? null : "("+inTranIdItemNo+")");
	
	function generateCheckNo(){
		/*var checkSeqNo = $F("checkSeqNo");
		var rowCount = 0;
		
		for(var i = 0; i < objChkBatch.rows.length; i ++){
			if($("mtgInput"+checkDetailsTG._mtgId+"_2," + i).checked){
				if(nvl(objChkBatch.rows[i].checkNo, "") == ""){
					objChkBatch.rows[i].checkDate = $F("genCheckDate");
					objChkBatch.rows[i].checkPrefSuf = $F("chkPrefix");
					objChkBatch.rows[i].checkNo = checkSeqNo;
					objChkBatch.rows[i].checkNumber = $F("chkPrefix") + "-" + checkSeqNo; 
					checkDetailsTG.updateVisibleRowOnly(objChkBatch.rows[i], i);
					objChkBatch.maxCheckNo = checkSeqNo;
					checkSeqNo = parseInt(checkSeqNo) + 1;
					rowCount++;
				}
			}else{
				checkDetailsTG.deleteVisibleRowOnly(i);
			}
		}
		
		if(nvl($("mtgPagerMsg"+checkDetailsTG._mtgId).down("strong", 0), "") != ""){
			$("mtgPagerMsg"+checkDetailsTG._mtgId).down("strong", 0).innerHTML = rowCount;
		}*/ // replaced by codes below : shan 09.29.2014
		
		objChkBatch.sortable = false;
		checkDetailsTG.onRemoveRowFocus();
		var tempMaxChkNo = (objChkBatch.maxCheckNo == null ? 0 : objChkBatch.maxCheckNo);
		var chkSeqNo = (parseInt($F("checkSeqNo")) > parseInt(tempMaxChkNo) ? $F("checkSeqNo") : tempMaxChkNo);
				
		var url = checkDetailsTG.url.split("action=getCheckBatchList");
		var urlParam = url[1].split("&genCheckNo=Y");
		new Ajax.Request(url[0] + "action=generateCheckNo" + urlParam[0], {
			parameters: {
				checkSeqNo:	chkSeqNo,
				checkDate:  $F("genCheckDate"),
				checkPrefSuf:  $F("chkPrefix"),
				filterBy: prepareJsonAsParameter(filterBy),
				inTranIdItemNo: inTranIdItemNo
			},
			onCreate: showNotice("Generating Check Number, please wait..."),
			onComplete: function(response){
				hideNotice();
				var result = JSON.parse(response.responseText);
				objGIACS054.tempTaggedRecords = result.rows;
				objChkBatch.maxCheckNo = result.maxCheckNo;
				
				checkDetailsTG.url = TGUrl;	// to display tagged records in the same page
				checkDetailsTG._refreshList();
				checkDetailsTG.options.postPager();
				$("chkPrefix").readOnly = true;
				$("checkSeqNo").readOnly = true;
				disableButton("btnGenerate");
				var mtgId = checkDetailsTG._mtgId;
				$("mtgRefreshBtn"+mtgId).hide();
				$("mtgFilterBtn"+mtgId).hide();
			}
		});
	}
	
	function closeCheckDateOverlay(){
		checkDateOverlay.close();
		delete checkDateOverlay;
	}
	
	$("btnOkDate").observe("click", function(){
		if (compareDatesIgnoreTime(Date.parse($F("genCheckDate")), Date.parse(latestDvDate)) == 1){
			showMessageBox("Check date must not be earlier than the latest DV date.", "E");
			return false;
		}
		var url = TGUrl.split("&checking=N");
		TGUrl = url[0] + "&checking=" + url[1]; // removed value of one param to display tagged records when going to other page : shan 10.20.2014
		TGUrl = TGUrl +"&genCheckNo=Y&checkSeqNo="+$F("checkSeqNo")+"&checkDate="+$F("genCheckDate")+ "&checkPrefSuf="+$F("chkPrefix")
					+ "&inTranIdItemNo="+inTranIdItemNo;
		generateCheckNo();
		closeCheckDateOverlay();
	});
	
	$("btnCancelDate").observe("click", function(){
		closeCheckDateOverlay();
	});
	
	$("genCheckDate").value = dateFormat(new Date(), "mm-dd-yyyy");
	$("genCheckDate").focus();
</script>