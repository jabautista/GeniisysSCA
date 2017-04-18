<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedClientId" name="selectedClientId" value="0" readonly="readonly" />
<div class="tableContainer" style="font-size: 12px;">
	<div class="tableHeader">
		<label style="width: 200px; margin-left: 15px;">Assured Name</label>
		<label style="width: 100px;">Birthday</label>
		<label style="width: 400px;">Address</label>
	</div>
	<div>
		<c:forEach var="assured" items="${searchResult}">
			<div id="row${assured.assdNo}" name="row" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
				<label style="width: 200px; margin-left: 10px;" id="${assured.assdNo}name" name="assdName" title="${assured.assdName}">${assured.assdName}</label>
				<label style="width: 100px;" id="${assured.assdNo}birthDate">
					<fmt:formatDate value="${assured.birthdate}" pattern="dd/MM/yyyy" />
					<c:if test="${empty assured.birthdate}">
						-
					</c:if>
				</label>
				<label style="width: 400px;" id="${assured.assdNo}address" name="address" title="${assured.mailAddress1} ${assured.mailAddress2} ${assured.mailAddress3}">${assured.mailAddress1} ${assured.mailAddress2} ${assured.mailAddress3}</label>
				<input id="${assured.assdNo}address1" name="${assured.assdNo}address1" type="hidden" value="${assured.mailAddress1}"/>
				<input id="${assured.assdNo}address2" name="${assured.assdNo}address2" type="hidden" value="${assured.mailAddress2}"/>
				<input id="${assured.assdNo}address3" name="${assured.assdNo}address3" type="hidden" value="${assured.mailAddress3}"/>
				<input id="${assured.assdNo}industryNm" name="${assured.assdNo}industryNm" type="hidden" value="${assured.industryNm}"/>
				<input id="${assured.assdNo}industryCd" name="${assured.assdNo}industryCd" type="hidden" value="${assured.industryCd}"/>
			</div>
		</c:forEach>
	</div>
</div>
<!-- <div class="pager" id="pager">  comment by Niknok and added style-->
	<c:if test="${noOfPages>1}">
		<div style="position:absolute; bottom:55px; right:20px;">
		Page:
			<select directory="" onChange="goToPageSearchClientModal2(this);">
				<c:forEach var="i" begin="1" end="${noOfPages}" varStatus="status">
					<option value="${i}"
						<c:if test="${pageNo==i}">
							selected="selected"
						</c:if>
					>${i}</option>
				</c:forEach>
			</select> of ${noOfPages}
		</div>
	</c:if>
<!-- </div>  -->
<script type="text/JavaScript">
	//comment out by Nok
	//position page div correctly
	//var product = 288 - (parseInt($$("div[name='row']").size())*28);
	//$("pager").setStyle("margin-top: "+product+"px;");

	$$("div[name='row']").each(
		function (row)	{
			row.observe("mouseover", function ()	{
				row.addClassName("lightblue");
			});
			
			row.observe("mouseout", function ()	{
				row.removeClassName("lightblue");
			});
		
			row.observe("click", function ()	{
				row.toggleClassName("selectedRow");
				if (row.hasClassName("selectedRow"))	{
					$("selectedClientId").value = row.getAttribute("id").substring(3);
					$$("div[name='row']").each(function (r)	{
						if (row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}
					});
				}	else	{
					//$("lineCd").value = ""; <-- temporarily commented 04.09.2011
					$("selectedClientId").value = "0";	
				}
			});
			
			row.observe("dblclick", function ()	{
				row.addClassName("selectedRow");
				var selectedId = row.getAttribute("id").substring(3);
				$("selectedClientId").value = row.getAttribute("id").substring(3);
				$$("div[name='row']").each(function (r)	{
					if (row.getAttribute("id") != r.getAttribute("id"))	{
						r.removeClassName("selectedRow");
					}
				});
				
				if (selectedId != "0")	{
					useAssured();
					Modalbox.hide();
					if (assuredListingFromPAR == 1) {						
						//fireNextFunc();
						fireNextFunc2();
					}else if(assuredListingFromPAR == 2){// added by irwin for packParCreation. 04.12.2011
						getPackAssuredValues();
					}
				}
			});
		}
	);

	$$("label[name='address']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(50, "..."));
	});

	$$("label[name='assdName']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(25, "..."));
	});
</script>