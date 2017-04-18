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
		<label style="width: 30%; margin-right: 10px;">GL Account Code</label>
		<label style="width: 67%; ">GL Account Name</label>
	</div>
	<div id="acctCodeInputVatListing" name="acctCodeInputVatListing" style="height:270px; overflow:auto;">
		<c:if test="${searchResultJSON eq '[]'}">
			<div id="rowAcctCodeInputVatList" name="rowAcctCodeInputVatList" class="tableRow">No records available</div>
		</c:if>
		
	</div>
</div>
<div align="right" style="margin-top:10px; display:${noOfPages gt 1 ? 'block' :'none'}">
	Page:
	<select id="acctCodeInputVatPage" name="acctCodeInputVatPage">
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
	objSearchAcctCode = JSON.parse('${searchResultJSON}'.replace(/\\/g, '\\\\'));

	//to show/generate the table listing
	showSearchAcctCodeInputVatList(objSearchAcctCode);

	//prepare the table list record
	function prepareSearchAcctCodeInputVat(obj){
		try{
			var inputVat =  '<label style="width: 30%; margin-right: 10px;">'+obj.glAcctCategory+' '+obj.glControlAcct+' '+obj.glSubAcct1+' '+obj.glSubAcct2+' '+obj.glSubAcct3+' '+obj.glSubAcct4+' '+obj.glSubAcct5+' '+obj.glSubAcct6+' '+obj.glSubAcct7+'</label>'+
							'<label style="width: 67%; ">'+(obj.glAcctName == "" || obj.glAcctName == null ? "---" :obj.glAcctName.truncate(65, "...")) +'</label>';   
			return inputVat;	
		}catch(e){
			showErrorMessage("prepareSearchAcctCodeInputVat", e);
			//showMessageBox("Error preparing Account Code List, "+e.message, imgMessage.ERROR);
		}	
	}

	//show the table list record
	function showSearchAcctCodeInputVatList(objArray){
		try{
			var tableContainer = $("acctCodeInputVatListing");
			for(var a=0; a<objArray.length; a++){
				var content = prepareSearchAcctCodeInputVat(objArray[a]);
				var newDiv = new Element("div");
				newDiv.setAttribute("id", "rowAcctCodeInputVatList"+objArray[a].glAcctId);
				newDiv.setAttribute("name", "rowAcctCodeInputVatList");
				newDiv.addClassName("tableRow");
				newDiv.setStyle("padding: 5px 1px 1px;"); 
				newDiv.update(content);
				tableContainer.insert({bottom : newDiv});
			}
		}catch(e){
			showErrorMessage("showSearchAcctCodeInputVatList", e);
			//showMessageBox("Error generating Account Code List, "+e.message, imgMessage.ERROR);
		}	
	}	

	//when PAGE change
	$("acctCodeInputVatPage").observe("change",function(){
		searchAcctCodeInputVatModal($("acctCodeInputVatPage").value,$("keyword").value);
	});

	//observe for table list
	$$("div[name=rowAcctCodeInputVatList]").each(function(row){
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
				$$("div[name=rowAcctCodeInputVatList]").each(function(li){
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