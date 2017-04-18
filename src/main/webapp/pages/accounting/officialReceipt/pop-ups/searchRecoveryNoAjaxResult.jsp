<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<input type="hidden" id="selectedClientId" value="0" readonly="readonly" />
<div class="tableContainer" style="font-size: 12px;">
	<div class="tableHeader">
		<label style="width: 16%; margin-right: 3px;">Recovery No.</label>
		<label style="width: 14%; margin-right: 3px;">Loss Date</label>
		<label style="width: 17%; margin-right: 3px;">Assured</label>
		<label style="width: 17%; margin-right: 3px;">Recovery Type</label>
		<label style="width: 17%; margin-right: 3px;">Payor Class</label>
		<label style="width: 17%; ">Payor</label>
	</div>
	<div id="recoveryNoListing" name="recoveryNoListing" style="height:270px; overflow:auto;">
		<c:if test="${searchResultJSON eq '[]'}">
			<div id="rowRecoveryNoList" name="rowRecoveryNoList" class="tableRow">No records available</div>
		</c:if>
		
	</div>
</div>
<div align="right" style="margin-top:10px; display:${noOfPages gt 1 ? 'block' :'none'}">
	Page:
	<select id="recoveryNoPage" name="recoveryNoPage">
		<c:forEach var="i" begin="1" end="${noOfPages}" varStatus="status">
			<option value="${i}"
				<c:if test="${pageNo==i}">
					selected="selected"
				</c:if>
			>${i}</option>
		</c:forEach>
	</select> of ${noOfPages}
</div>
<script type="text/javascript">
	objSearchRecoveryNo = JSON.parse('${searchResultJSON}'.replace(/\\/g, '\\\\'));

	//to show/generate the table listing
	showSearchRecoveryNoList(objSearchRecoveryNo);

	//prepare the table list record
	function prepareSearchRecoveryNo(obj){
		try{
			var lossRec = '<label style="width: 16%; margin-right: 3px;">'+(obj.lineCd == "" || obj.lineCd == null ? "---" :obj.lineCd)+"-"+(obj.issCd == "" || obj.issCd == null ? "---" :obj.issCd)+"-"+(obj.recYear == "" || obj.recYear == null ? "---" :obj.recYear)+"-"+(obj.recSeqNo == "" || obj.recSeqNo == null ? "---" :formatNumberDigits(obj.recSeqNo,3))+'</label>'+
						  '<label style="width: 14%; margin-right: 3px;">'+(obj.dspLossDate == "" || obj.dspLossDate == null ? "---" :dateFormat(obj.dspLossDate.replace(/-/g,"/"),"mm-dd-yyyy").truncate(13, "..."))+'</label>'+ // added replace to fix "invalid date" exception (emman 03.15.2011)
						  '<label style="width: 17%; margin-right: 3px;">'+(obj.dspAssuredName == "" || obj.dspAssuredName == null ? "---" :changeSingleAndDoubleQuotes(obj.dspAssuredName).truncate(18, "..."))+'</label>'+
						  '<label style="width: 17%; margin-right: 3px;">'+(obj.recTypeDesc == "" || obj.recTypeDesc == null ? "---" :changeSingleAndDoubleQuotes(obj.recTypeDesc).truncate(18, "..."))+'</label>'+
						  '<label style="width: 17%; margin-right: 3px;">'+(obj.payorClassDesc == "" || obj.payorClassDesc == null ? "---" :changeSingleAndDoubleQuotes(obj.payorClassDesc).truncate(18, "..."))+'</label>'+
						  '<label style="width: 17%; ">'+(obj.payorName == "" || obj.payorName == null ? "---" :changeSingleAndDoubleQuotes(obj.payorName).truncate(18, "..."))+'</label>';
			return lossRec;	 
		}catch(e){
			showErrorMessage("prepareSearchRecoveryNo", e);
			//showMessageBox("Error preparing Recovery No. List, "+e.message, imgMessage.ERROR);
		}	
	}
	
	//show the table list record
	function showSearchRecoveryNoList(objArray){
		try{
			var tableContainer = $("recoveryNoListing");
			for(var a=0; a<objArray.length; a++){
				var content = prepareSearchRecoveryNo(objArray[a]);
				var newDiv = new Element("div");
				objArray[a].divCtrId = a;
				newDiv.setAttribute("id", "rowRecoveryNoList"+a);
				newDiv.setAttribute("name", "rowRecoveryNoList");
				newDiv.addClassName("tableRow"); 
				newDiv.setStyle("padding: 5px 1px 1px;"); 
				newDiv.update(content);
				tableContainer.insert({bottom : newDiv});
			}
		}catch(e){
			showErrorMessage("showSearchRecoveryNoList", e);
			//showMessageBox("Error generating Recovery No. List, "+e.message, imgMessage.ERROR);
		}	
	}	

	//when PAGE change
	$("recoveryNoPage").observe("change",function(){
		searchRecoveryNoModal($("recoveryNoPage").value,$("keyword").value);
	});

	//observe for table list
	$$("div[name=rowRecoveryNoList]").each(function(row){
		row.observe("mouseover",function(){
			row.addClassName("lightblue");
		});
		row.observe("mouseout",function(){
			row.removeClassName("lightblue");
		});
		row.observe("click",function(){
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow")){
				$("selectedClientId").value = row.getAttribute("id");
				$$("div[name=rowRecoveryNoList]").each(function(li){
					if (row.getAttribute("id") != li.getAttribute("id")){
						li.removeClassName("selectedRow");
					}	
				});
			}else{
				null;
			}		
		});
	});
	
</script>