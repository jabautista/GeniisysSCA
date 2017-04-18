<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div class="tableContainer">
	<div id="adviceNoTableHeader" class="tableHeader" >
		<label style="width: 30%; margin-right: 10px;">Advice Sequence Number</label>
		<label style="width: 67%; "></label>
	</div>
	<div id="adviceNumberDcpListing" name="adviceNumberDcpListing">
		<c:if test="${searchResultJSON eq '[]'}">
			<div id="rowAdviceNumberDcpList" name="rowAdviceNumberDcpList" class="tableRow">No records available</div>
		</c:if>
	</div>
</div>
<div align="right" style="margin-top:5px; display:${noOfPages gt 1 ? 'block' :'none'}">
	Page:
	<select id="adviceNumberPage" name="adviceNumberPage">
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
	objSearchAdviceNumber = JSON.parse('${searchResultJSON}'.replace(/\\/g, '\\\\'));
	$("temp").value='${searchResultJSON}';
	// generate table
	function prepareAdviceNumberSearchResult(obj){
		try{
			var adviceSequence =	'<label style="width: 30%; margin-right: 10px;">'+obj.adviceSequenceNumber+'</label>'+
									'<label style="width: 67%; ">'+obj.adviceNo+'</label>'; 
			adviceSequence = adviceSequence + '<input type="hidden" id="claimId" 	name="claimId" 	value="'+ obj.claimId  +'"/>';
			adviceSequence = adviceSequence + '<input type="hidden" id="adviceId" 	name="adviceId" value="'+ obj.adviceId +'"/>';
			adviceSequence = adviceSequence + '<input type="hidden" id="lineCd" 	name="lineCd" 	value="'+ obj.lineCode +'"/>';
			adviceSequence = adviceSequence + '<input type="hidden" id="adviceNo" 	name="adviceNo" value="'+ obj.adviceNo +'"/>';
			//adviceSequence = adviceSequence + '<input type="hidden" id="claimLossId" name="claimLossId" value="'+ obj.claimLossId +'"/>';
			adviceSequence = adviceSequence + '<input type="hidden" id="currencyCode" name="currencyCode" value="'+ obj.currencyCode +'"/>';
			adviceSequence = adviceSequence + '<input type="hidden" id="convertRate" name="convertRate" value="'+ formatCurrency(obj.convertRate) +'"/>';
			adviceSequence = adviceSequence + '<input type="hidden" id="cpiBranchCd" name="cpiBranchCd" value="'+ obj.cpiBranchCode +'"/>';
			adviceSequence = adviceSequence + '<input type="hidden" id="cpiRecNo" name="cpiRecNo" value="'+ obj.cpiRecNo +'"/>';
			adviceSequence = adviceSequence + '<input type="hidden" id="currencyDescription" name="currencyDescription" value="'+ obj.currencyDescription +'"/>';
			return adviceSequence;
		}catch(e){
			showErrorMessage("prepareAdviceNumberSearchResult", e);
			//showMessageBox("Error preparing Advice Number List, " + e.message, imgMessage.ERROR);
		}
	}

	function showSearchResultAdviceNumberListing(objArray){
		try{
			var tableContainer = $("adviceNumberDcpListing");
			var newDiv;
			for(var a=0; a<objArray.length; a++){
				var content = prepareAdviceNumberSearchResult(objArray[a]);
				newDiv = new Element("div");
				newDiv.setAttribute("id", 	"adviceSequenceRow" + objArray[a].adviceNo);				
				newDiv.setAttribute("name",	"adviceSequenceRow");
				newDiv.addClassName("tableRow");
				newDiv.update(content);
				
				tableContainer.insert({bottom : newDiv});
			}
		}catch(e){
			showErrorMessage("showSearchResultAdviceNumberListing", e);
		}
	}

	$("adviceNumberPage").observe("change", function(){
		searchAdviceNumberModal($("adviceNumberPage").value,$("keyword").value);
	});

	showSearchResultAdviceNumberListing(objSearchAdviceNumber);

	$$("div[name='adviceSequenceRow']").each(function(row){
		row.observe("mouseover",function(){
			row.addClassName("lightblue");
		});
		row.observe("mouseout",function(){
			row.removeClassName("lightblue");
		});
		row.observe("click",function(){
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow")){
				$( "selectedAdvice" ).value = row.getAttribute("id");
				$$("div[name='adviceSequenceRow']").each(function(li){  //rowAdviceNumberDcpList
					if (row.getAttribute("id") != li.getAttribute("id")){
						li.removeClassName("selectedRow");
					}
				});
			}else{
				$("selectedAdvice").value = "";
			}
		});
	});
</script>