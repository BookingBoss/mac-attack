<cfsilent>
<!---

    Mach-II - A framework for object oriented MVC web applications in CFML
    Copyright (C) 2003-2010 GreatBizTools, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

	As a special exception, the copyright holders of this library give you
	permission to link this library with independent modules to produce an
	executable, regardless of the license terms of these independent
	modules, and to copy and distribute the resultant executable under
	the terms of your choice, provided that you also meet, for each linked
	independent module, the terms and conditions of the license of that
	module.  An independent module is a module which is not derived from
	or based on this library and communicates with Mach-II solely through
	the public interfaces* (see definition below). If you modify this library,
	but you may extend this exception to your version of the library,
	but you are not obligated to do so. If you do not wish to do so,
	delete this exception statement from your version.


	* An independent module is a module which not derived from or based on
	this library with the exception of independent module components that
	extend certain Mach-II public interfaces (see README for list of public
	interfaces).

$Id: snip_cachingInformation.cfm 2361 2010-09-06 07:26:24Z peterjfarrell $

Created version: 1.1.0
Updated version: 1.1.0

Notes:
--->
	<cfimport prefix="view" taglib="/MachII/customtags/view" />
	<cfset copyToScope("${event.cacheStrategies}") />
	<cfset variables.moduleOrder = StructKeyList(variables.cacheStrategies) />
	<cfif ListFindNoCase(variables.moduleOrder, "base")>
		<cfset variables.moduleOrder = ListDeleteAt(variables.moduleOrder, ListFindNoCase(variables.moduleOrder, "base")) />
		<cfset variables.moduleOrder = ListPrepend(variables.moduleOrder, "base") />
	</cfif>
	<cfset variables.moduleOrder = ListToArray(variables.moduleOrder) />
</cfsilent>

<cfoutput>

<cfif StructCount(variables.cacheStrategies)>
<cfloop from="1" to="#ArrayLen(variables.moduleOrder)#" index="i">
	<cfset module = variables.moduleOrder[i] />
	<cfset strategies = variables.cacheStrategies[module] />
<cfif StructCount(variables.strategies) GT 0>
	<h2 style="margin:1em 0 3px 0;">#UCase(Left(module, 1))##Right(module, Len(module) -1)# Module</h2>
	<table>
	<tr>
		<th style="width:35%;"><h3>Name / Configuration</h3></th>
		<th style="width:50%;"><h3>Stats</h3></th>
		<th style="width:15%;"><h3>Options</h3></th>
	</tr>
	<cfset count = 0 />
	<cfloop collection="#strategies#" item="strategyName">
		<cfset count = count + 1>
		<cfset strategy = cacheStrategies[module][strategyName] />
		<cfset configData = strategy.getConfigurationData() />
		<cfset cacheStats = strategy.getCacheStats() />
		<cfset customStats = cacheStats.getExtraStats() />
		<tr <cfif count MOD 2>class="shade"</cfif>>
			<cfset strategyType = strategy.getStrategyType() />
			<td>
				<h4>#strategyName#</h4>
				<p class="small">
					<cfif listGetAt(strategyType, 1, ".") eq "MachII">
						<a href="#getProperty("udfs").getCFCDocUrl(strategyType)#" target="_blank">
							<img src="#BuildEndpointUrl("dashboard.serveAsset", "file=/img/icons/link_go.png")#" width="16" height="16" alt="Link" />
							#strategy.getStrategyTypeName()# (#strategyType#)
						</a>
					<cfelse>
						#strategy.getStrategyTypeName()# (#strategyType#)
					</cfif>
				</p>
				
				<cfif StructCount(configData)>
					<hr />
					<table class="small">
					<cfloop collection="#variables.configData#" item="propName">
						<cfif NOT listFindNoCase("type,scopeKey", propName)>
							<tr>
								<td style="width:35%;"><h4>#propName#</h4></td>
								<td style="width:65%;">
								<cfset propValue = variables.configData[propName] />
								<cfif IsSimpleValue(propValue)>
									<p>#propValue#</p>
								<cfelse>
									<p><em>[complex value]</em></p>
								</cfif>
								</td>							
							</tr>
						</cfif>
					</cfloop>
					</table>
				</cfif>
				<hr />
				<table class="small">
					<tr>
						<td style="width:35%;"><h4>Hit Radio</h4></td>
						<td style="width:65%;"><p>#getProperty("udfs").decimalRound(cacheStats.getCacheHitRatio() * 100, 2)#%</p></td>
					</tr>
					<tr>
						<td><h4>Hits</h4></td>
						<td><p>#cacheStats.getCacheHits()#</p></td>
					</tr>
					<tr>
						<td><h4>Misses</h4></td>
						<td><p>#cacheStats.getCacheMisses()#</p></td>
					</tr>
					<tr>
						<td><h4>Active Elements</h4></td>
						<td><p>#cacheStats.getActiveElements()#</p></td>
					</tr>
					<tr>
						<td><h4>Total Elements</h4></td>
						<td><p>#cacheStats.getTotalElements()#</p></td>
					</tr>
					<tr>
						<td><h4>Evictions</h4></td>
						<td><p>#cacheStats.getEvictions()#</p></td>
					</tr>
				</table>

				<cfif StructCount(customStats)>
					<hr />
					<table class="small">
						<cfloop collection="#customStats#" item="customStatName">
							<tr>
								<td style="width:35%;"><h4>#customStatName#</h4></td>
								<td style="width:65%;"><p>#customStats[customStatName]#</p></td>
							</tr>
						</cfloop>
					</table>
				</cfif>
			</td>
			<td>
				<cfif count MOD 2>
					<cfset backgroundColor ="F5F5F5" />
				<cfelse>
					<cfset backgroundColor ="FFFFFF" />
				</cfif>
				<cfif getProperty("chartProvider") EQ "cfchart">
					<div style="width:450px;height:300px;">
					<cfchart format="png" 
						backgroundColor="###backgroundColor#"
						chartWidth="450"
						chartHeight="300"
						show3D="true" 
						tipstyle="none" 
						fontsize="10" 
						title="Stats Active for #getProperty("udfs").datetimeDifferenceString(cacheStats.getStatsActiveSince())#">
						<cfchartseries type="bar" 
							colorList="green,red,blue,yellow,aqua"
							paintstyle="light">
							<cfchartdata item="Hits" value="#cacheStats.getCacheHits()#" />
							<cfchartdata item="Misses" value="#cacheStats.getCacheMisses()#" />
							<cfchartdata item="Active Elements" value="#cacheStats.getActiveElements()#" />
							<cfchartdata item="Total Elements" value="#cacheStats.getTotalElements()#" />
							<cfchartdata item="Evictions" value="#cacheStats.getEvictions()#" />
						</cfchartseries>
					</cfchart>
					</div>	
				<cfelseif getProperty("chartProvider") EQ "googlecharts">
					<cfset variables.stats = cacheStats.getAllStats() />
					<cfset StructDelete(variables.stats, "statsActiveSince") />
					<cfset variables.highest = StructSort(variables.stats, "numeric", "desc") />
					<cfset variables.highest = variables.stats[variables.highest[1]] />
					<cfif variables.highest LT 100>
						<cfset variables.rangeMax = 100 />
					<cfelseif variables.highest LT 1000>
						<cfset variables.rangeMax = 1000 />
					<cfelseif variables.highest LT 5000>
						<cfset variables.rangeMax = 5000 />
					<cfelseif variables.highest LT 10000>
						<cfset variables.rangeMax = 10000 />
					<cfelseif variables.highest LT 100000>
						<cfset variables.rangeMax = 100000 />
					<cfelseif variables.highest LT 1000000>
						<cfset variables.rangeMax = 1000000 />
					<cfelse>
						<cfset variables.rangeMax = variables.highest + 10000 />
					</cfif>
					<p class="center"><view:img src="http://chart.apis.google.com/chart?cht=bvg&chbh=a&chd=t:#cacheStats.getCacheHits()#,#cacheStats.getCacheMisses()#,#cacheStats.getActiveElements()#,#cacheStats.getTotalElements()#,#cacheStats.getEvictions()#&chds=0,#variables.rangeMax#&chs=450x300&chco=00B700|FF0000|0000FF|FFFF00|00FFFF&chtt=Stats Active for #getProperty("udfs").datetimeDifferenceString(cacheStats.getStatsActiveSince())#&chl=Hits|Misses|Active Elements|Total Elements|Evictions&chxt=y&chxr=0,0,#variables.rangeMax#&chf=bg,s,#backgroundColor#"
						width="450"
						height="300" /></p>
				<cfelse>
					<h4 class="center">Charting Not Enabled</h4>
				</cfif>
			</td>
			<td>
				<ul class="none">
				<cfif strategy.isCacheEnabled()>
					<li class="green">
						<a href="#BuildUrl("caching.enableDisableCacheStrategy", "moduleName=#module#|strategyName=#strategyName#|mode=disable")#" title="Click to Disable">
							<img src="#BuildEndpointUrl("dashboard.serveAsset", "file=/img/icons/accept.png")#" width="16" height="16" alt="Enabled" />
							&nbsp;Enabled
						</a>
					</li>
				<cfelse>
					<li class="red">
						<a href="#BuildUrl("caching.enableDisableCacheStrategy", "moduleName=#module#|strategyName=#strategyName#|mode=enable")#" title="Click to Enable">
							<img src="#BuildEndpointUrl("dashboard.serveAsset", "file=/img/icons/stop.png")#" width="16" height="16" alt="Disable" />
							&nbsp;Disabled
						</a>
					</li>
				</cfif>
					<li>
						<a href="#BuildUrl("caching.reapCacheStrategy", "moduleName=#module#|strategyName=#strategyName#")#">
							<img src="#BuildEndpointUrl("dashboard.serveAsset", "file=/img/icons/database_refresh.png")#" width="16" height="16" alt="Reap" />
							&nbsp;Reap
						</a>
					</li>
					<li>
						<a href="#BuildUrl("caching.flushCacheStrategy", "moduleName=#module#|strategyName=#strategyName#")#">
							<img src="#BuildEndpointUrl("dashboard.serveAsset", "file=/img/icons/database_delete.png")#" width="16" height="16" alt="Flush" />
							&nbsp;Flush
						</a>
					</li>
				</ul>
			</td>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfloop>
<cfelse>
<h4>There are no cache strategies defined for this application.</h4>
</cfif>
</cfoutput>