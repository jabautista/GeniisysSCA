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
		<label style="width: 20%; margin-right: 5px;">Acct. Issue Cd</label>
		<label style="width: 20%; margin-right: 5px;">Branch Cd</label>
		<label style="width: 36%; margin-right: 5px;">Reference No.</label>
		<label style="width: 20%; ">Mod 10</label>
	</div>
	<div id="bankRefNoListing" name="bankRefNoListing" style="height:270px; overflow:auto;">
		<c:if test="${searchResultJSON eq '[]'}">
			<div id="rowBankRefNoList" name="rowBankRefNoList" class="tableRow">No records available</div>
		</c:if>
		
	</div>
</div>
<div align="right" style="margin-top:10px; display:${noOfPages gt 1 ? 'block' :'none'}">
	Page:
	<select id="bankRefNoPage" name="bankRefNoPage">
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
	objSearchBankRefNo = JSON.parse('${searchResultJSON}'.replace(/\\/g, '\\\\'));

	//to show/generate the table listing
	showSearchBankRefNoList(objSearchBankRefNo);

	//prepare the table list record
	function prepareSearchBankRefNo(obj){
		try{
			var rowList =  	'<label style="width: 20%; margin-right: 5px;">'+obj.acctIssCd+'</label>'+
							'<label style="width: 20%; margin-right: 5px;">'+obj.branchCd+'</label>'+
							'<label style="width: 36%; margin-right: 5px;">'+obj.refNo+'</label>'+
							'<label style="width: 20%; ">'+obj.modNo+'</label>';   
			return rowList;	
		}catch(e){
			showErrorMessage("prepareSearchBankRefNo", e);
			//showMessageBox("Error prepareSearchBankRefNo, "+e.message, imgMessage.ERROR);
		}	
	}

	//show the table list record
	function showSearchBankRefNoList(objArray){
		try{
			var tableContainer = $("bankRefNoListing");
			for(var a=0; a<objArray.length; a++){
				var content = prepareSearchBankRefNo(objArray[a]);
				var newDiv = new Element("div");
				objArray[a].divCtrId = a;
				newDiv.setAttribute("id", "rowBankRefNoList"+a);
				newDiv.setAttribute("name", "rowBankRefNoList");
				newDiv.addClassName("tableRow");
				newDiv.setStyle("padding: 5px 1px 1px;"); 
				newDiv.update(content);
				tableContainer.insert({bottom : newDiv});
			}
		}catch(e){
			showErrorMessage("showSearchBankRefNoList", e);
			//showMessageBox("Error showSearchBankRefNoList, "+e.message, imgMessage.ERROR);
		}	
	}	

	//when PAGE change
	$("bankRefNoPage").observe("change",function(){
		searchBankRefNoModal($("bankRefNoPage").value,$("keyword").value);
	});

	//observe for table list
	$$("div[name=rowBankRefNoList]").each(function(row){
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
				$$("div[name=rowBankRefNoList]").each(function(li){
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