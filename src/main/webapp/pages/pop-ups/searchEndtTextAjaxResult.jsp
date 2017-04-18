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
		<label style="width: 8%; margin-right: 5px;">Code</label>
		<label style="width: 45%; margin-right: 5px;">Title</label>
		<label style="width: 45%; ">Text</label>
	</div>
	<div id="endtTextListing" name="endtTextListing" style="height:270px; overflow:auto;">
		<c:if test="${searchResultJSON eq '[]'}">
			<div id="rowEndtTextList" name="rowEndtTextList" class="tableRow">No records available</div>
		</c:if>
		
	</div>
</div>
<div align="right" style="margin-top:10px; display:${noOfPages gt 1 ? 'block' :'none'}">
	Page:
	<select id="endtTextPage" name="endtTextPage">
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
	objSearchEndtText = JSON.parse('${searchResultJSON}');

	//to show/generate the table listing
	showSearchEndtTextList(objSearchEndtText);

	//prepare the table list record
	function prepareSearchEndtText(obj){
		try{
			var rowList =  	'<label style="width: 8%; margin-right: 5px;">'+obj.endtCd+'</label>'+
							'<label style="width: 45%; margin-right: 5px;">'+(obj.endtTitle).truncate(50, "...")+'</label>'+
							'<label style="width: 45%; ">'+(unescapeHTML2(obj.endtText)).truncate(50, "...") +'</label>';   
			return rowList;	
		}catch(e){
			showErrorMessage("prepareSearchEndtText", e);
			
		}	
	}

	//show the table list record
	function showSearchEndtTextList(objArray){
		try{
			var tableContainer = $("endtTextListing");
			for(var a=0; a<objArray.length; a++){
				var content = prepareSearchEndtText(objArray[a]);
				var newDiv = new Element("div");
				objArray[a].divCtrId = a;
				newDiv.setAttribute("id", "rowEndtTextList"+a);
				newDiv.setAttribute("name", "rowEndtTextList");
				newDiv.addClassName("tableRow");
				newDiv.setStyle("padding: 5px 1px 1px;"); 
				newDiv.update(content);
				tableContainer.insert({bottom : newDiv});
			}
		}catch(e){
			showErrorMessage("showSearchEndtTextList", e);
			
		}	
	}	

	//when PAGE change
	$("endtTextPage").observe("change",function(){
		searchEndtTextModal($("endtTextPage").value,$("keyword").value);
	});

	//observe for table list
	$$("div[name=rowEndtTextList]").each(function(row){
		row.observe("mouseover",function(){
			row.addClassName("lightblue");
		});
		row.observe("mouseout",function(){
			row.removeClassName("lightblue");
		});
		row.observe("click",function(){
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow")+" = "+row.getAttribute("id")){
				$("selectedClientId").value = row.getAttribute("id");
				$$("div[name=rowEndtTextList]").each(function(li){
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