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
	<div id="initInfoListing" name="initInfoListing" style="height:270px; overflow:auto;">
		<c:if test="${searchResultJSON eq '[]'}">
			<div id="rowInitInfoList" name="rowInitInfoList" class="tableRow">No records available</div>
		</c:if>
		
	</div>
</div>
<div align="right" style="margin-top:10px; display:${noOfPages gt 1 ? 'block' :'none'}">
	Page:
	<select id="initInfoPage" name="initInfoPage">
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
	objSearchInitInfo = JSON.parse('${searchResultJSON}');

	//to show/generate the table listing
	showSearchInitInfoList(objSearchInitInfo);

	//prepare the table list record
	function prepareSearchInitInfo(obj){
		try{
			var rowList =  	'<label style="width: 10%; margin-right: 10px;">'+obj.geninInfoCd+'</label>'+
							'<label style="width: 20%; margin-right: 10px;">'+(obj.geninInfoTitle).truncate(18, "...")+'</label>'+
							'<label style="width: 67%; ">'+(changeSingleAndDoubleQuotes(nvl(obj.initialInfo01,"")+nvl(obj.initialInfo02,"")+nvl(obj.initialInfo03,"")+nvl(obj.initialInfo04,"")+nvl(obj.initialInfo05,"")+nvl(obj.initialInfo06,"")+nvl(obj.initialInfo07,"")+nvl(obj.initialInfo08,"")+nvl(obj.initialInfo09,"")+nvl(obj.initialInfo10,"")+nvl(obj.initialInfo11,"")+nvl(obj.initialInfo12,"")+nvl(obj.initialInfo13,"")+nvl(obj.initialInfo14,"")+nvl(obj.initialInfo15,"")+nvl(obj.initialInfo16,"")+nvl(obj.initialInfo17,""))).truncate(65, "...") +'</label>';   
			return rowList;	
		}catch(e){
			showErrorMessage("prepareSearchInitInfo", e);
			//showMessageBox("Error prepareSearchInitInfo, "+e.message, imgMessage.ERROR);
		}	
	}

	//show the table list record
	function showSearchInitInfoList(objArray){
		try{
			var tableContainer = $("initInfoListing");
			for(var a=0; a<objArray.length; a++){
				var content = prepareSearchInitInfo(objArray[a]);
				var newDiv = new Element("div");
				objArray[a].divCtrId = a;
				newDiv.setAttribute("id", "rowInitInfoList"+a);
				newDiv.setAttribute("name", "rowInitInfoList");
				newDiv.addClassName("tableRow");
				newDiv.setStyle("padding: 5px 1px 1px;"); 
				newDiv.update(content);
				tableContainer.insert({bottom : newDiv});
			}
		}catch(e){
			showErrorMessage("showSearchInitInfoList", e);
			//showMessageBox("Error showSearchInitInfoList, "+e.message, imgMessage.ERROR);
		}	
	}	

	//when PAGE change
	$("initInfoPage").observe("change",function(){
		searchInitInfoModal($("initInfoPage").value,$("keyword").value);
	});

	//observe for table list
	$$("div[name=rowInitInfoList]").each(function(row){
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
				$$("div[name=rowInitInfoList]").each(function(li){
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