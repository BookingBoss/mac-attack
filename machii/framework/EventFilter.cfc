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

Author: Ben Edwards (ben@ben-edwards.com)
$Id: EventFilter.cfc 2204 2010-04-27 07:36:11Z peterfarrell $

Created version: 1.0.0
Updated version: 1.8.0
--->
<cfcomponent
	displayname="EventFilter"
	extends="MachII.framework.BaseComponent"
	output="false"
	hint="Base EventFilter component.">

	<!---
	PROPERTIES
	--->

	<!---
	INITIALIZATION / CONFIGURATION
	--->
	<cffunction name="init" access="public" returntype="EventFilter" output="false"
		hint="Used by the framework for initialization. Do not override.">
		<cfargument name="appManager" type="MachII.framework.AppManager" required="true"
			hint="The AppManager of the context in which this listener belongs to." />
		<cfargument name="parameters" type="struct" required="false" default="#StructNew()#"
			hint="The event-filter configure time parameters." />

		<cfset super.init(arguments.appManager, arguments.parameters) />

		<cfreturn this />
	</cffunction>

	<!---
	PUBLIC FUNCTIONS
	--->
	<cffunction name="filterEvent" access="public" returntype="boolean" output="false"
		hint="Override (be sure to keep the same arguments and returntype) to provide event filtering logic.">
		<cfargument name="event" type="MachII.framework.Event" required="true"
			hint="The current Event." />
		<cfargument name="eventContext" type="MachII.framework.EventContext" required="true"
			hint="The current EventContext." />
		<cfargument name="paramArgs" type="struct" required="false" default="#StructNew()#"
			hint="A struct of available runtime parameters." />

		<cfreturn true />
	</cffunction>

</cfcomponent>