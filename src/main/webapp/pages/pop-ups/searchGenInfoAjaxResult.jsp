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
		<label style="width: 10%; margin-right: 10px;">Code</label>
		<label style="width: 20%; margin-right: 10px;">Title</label>
		<label style="width: 67%; ">Text</label>
	</div>
	<div id="genInfoListing" name="genInfoListing" style="height:270px; overflow:auto;">
		<c:if test="${searchResultJSON eq '[]'}">
			<div id="rowGenInfoList" name="rowGenInfoList" class="tableRow">No records available</div>
		</c:if>
		
	</div>
</div>
<div align="right" style="margin-top:10px; display:${noOfPages gt 1 ? 'block' :'none'}">
	Page:
	<select id="genInfoPage" name="genInfoPage">
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
	objSearchGenInfo = JSON.parse('${searchResultJSON}'.replace(/\\/g, '\\\\'));
	//to show/generate the table listing
	showSearchGenInfoList(objSearchGenInfo);

	//prepare the table list record
	function prepareSearchGenInfo(obj){
		try{
			var rowList =  	'<label style="width: 10%; margin-right: 10px;">'+obj.geninInfoCd+'</label>'+
							'<label style="width: 20%; margin-right: 10px;">'+(obj.geninInfoTitle).truncate(18, "...")+'</label>'+
							'<label style="width: 67%; ">'+(changeSingleAndDoubleQuotes(nvl(obj.genInfo01,"")+nvl(obj.genInfo02,"")+nvl(obj.genInfo03,"")+nvl(obj.genInfo04,"")+nvl(obj.genInfo05,"")+nvl(obj.genInfo06,"")+nvl(obj.genInfo07,"")+nvl(obj.genInfo08,"")+nvl(obj.genInfo09,"")+nvl(obj.genInfo10,"")+nvl(obj.genInfo11,"")+nvl(obj.genInfo12,"")+nvl(obj.genInfo13,"")+nvl(obj.genInfo14,"")+nvl(obj.genInfo15,"")+nvl(obj.genInfo16,"")+nvl(obj.genInfo17,""))).truncate(65, "...") +'</label>';   
			return rowList;	
		}catch(e){
			showErrorMessage("prepareSearchGenInfo", e);
			//showMessageBox("Error prepareSearchGenInfo, "+e.message, imgMessage.ERROR);
		}	
	}

	//show the table list record
	function showSearchGenInfoList(objArray){
		try{
			var tableContainer = $("genInfoListing");
			for(var a=0; a<objArray.length; a++){
				var content = prepareSearchGenInfo(objArray[a]);
				var newDiv = new Element("div");
				objArray[a].divCtrId = a;
				newDiv.setAttribute("id", "rowGenInfoList"+a);
				newDiv.setAttribute("name", "rowGenInfoList");
				newDiv.addClassName("tableRow");
				newDiv.setStyle("padding: 5px 1px 1px;"); 
				newDiv.update(content);
				tableContainer.insert({bottom : newDiv});
			}
		}catch(e){
			showErrorMessage("showSearchGenInfoList", e);
			//showMessageBox("Error showSearchGenInfoList, "+e.message, imgMessage.ERROR);
		}	
	}	

	//when PAGE change
	$("genInfoPage").observe("change",function(){
		searchGenInfoModal($("genInfoPage").value,$("keyword").value);
	});

	//observe for table list
	$$("div[name=rowGenInfoList]").each(function(row){
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
				$$("div[name=rowGenInfoList]").each(function(li){
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