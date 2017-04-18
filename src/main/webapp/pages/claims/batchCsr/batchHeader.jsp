<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<input type="hidden" value="${isSpecial }" id="isSpecial" name="isSpecial" />
<div id="batchHeaderDiv" name="batchHeaderDiv" style="margin: 10px 0px;" align="center" changeTagAttr="true">
	<table>
		<tr>
			<td class="rightAligned" style="width: 100px;">Batch Number</td>
			<td class="leftAligned">
				<input type="text" id="batchNumber" name="batchNumber" style="float: left; width: 245px;" readonly="readonly" /> 
			</td>
			<td class="rightAligned" style="width: 100px;">Payee Class</td>
			<td class="leftAligned">
				<span id="payeeClassSpan" style="border: 1px solid gray; width: 250px; height: 21px; float: left;"> 
					<input type="text" id="payeeClass" name="payeeClass" style="border: none; float: left; width: 90%; background: transparent;" readonly="readonly" /> 
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="btnPayeeClass" name="btnPayeeClass" alt="Go" style="background: transparent;"/>
				</span>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 100px;">Particulars</td>
			<td class="leftAligned">
				<span class="required" id="particularsSpan" style="border: 1px solid gray; width: 250px; height: 21px; float: left;"> 
					<!-- <textarea id="particulars" name="particulars" style="width: 90%; resize:none;" class="required withIcon" onKeyDown="limitText(this,1000);" onKeyUp="limitText(this,1000);"> </textarea>  adjusted limitText from 2000 to 1000 - Halley 11.06.13 -->
					<!-- <input type="text" id="particulars" name="particulars" style="border: none; float: left; width: 90%; background: transparent;" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);"/> -->
					<!-- added by j.diago 04.14.2014 -->
					<textarea id="particulars" name="particulars" style="width: 90%; resize:none;" class="required withIcon" onKeyDown="limitText(this,1000);" onKeyUp="limitText(this,1000);" ignoreDelKey=""></textarea> <!-- added by steven 04.22.2014 ignoreDelKey="" -->
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" id="btnParticulars" name="btnParticulars" alt="Go" style="background: transparent;" />
				</span>
			</td>
			<td class="rightAligned" style="width: 100px;">Payee</td>
			<td class="leftAligned">
				<span id="payeeSpan" style="border: 1px solid gray; width: 250px; height: 21px; float: left;"> 
					<input type="text" id="payee" name="payee" style="border: none; float: left; width: 90%; background: transparent;" readonly="readonly" /> 
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="btnPayee" name="btnPayee" alt="Go" style="background: transparent;"/>
				</span>
			</td>
		</tr>
		<c:if test="${isSpecial eq 'Y'}">
			<td class="rightAligned" style="width: 100px;">Payee Remarks</td>
			<td class="leftAligned">
				<span id="particularsSpan" style="border: 1px solid gray; width: 250px; height: 21px; float: left;"> 
					<textarea id="payeeRemarks" name="payeeRemarks" style="border: none; float: left; width: 90%; background: transparent; height: 70%; resize:none;" onKeyDown="limitText(this,500);" onKeyUp="limitText(this,500);" ignoreDelKey=""> </textarea> <!-- changed from 2000 to 500 by robert 10.24.2013; added by steven 04.22.2014 ignoreDelKey=""-->
					<!-- <input type="text" id="payeeRemarks" name="payeeRemarks" style="border: none; float: left; width: 90%; background: transparent;" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);"/> --> 
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" id="btnPayeeRemarks" name="btnPayeeRemarks" alt="Go" style="background: transparent;" />
				</span>
			</td>
		</c:if>
	</table>
</div>