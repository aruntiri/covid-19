Class AnalyzeThis.Generated.covid03162020 Extends %Library.Persistent [ Not Abstract, DdlAllowed, Not LegacyInstanceContext, ProcedureBlock ]
{

Parameter DEFAULTGLOBAL = "^AnalyzeThis.G.covid03162020";

Property Confirmed As %Integer [ SqlColumnNumber = 5 ];

Property CountryRegion As %String(MAXLEN = "") [ SqlColumnNumber = 3 ];

Property Deaths As %Integer [ SqlColumnNumber = 6 ];

Property LastUpdate As %Date [ SqlColumnNumber = 4 ];

Property Latitude As %String(MAXLEN = "") [ SqlColumnNumber = 8 ];

Property Longitude As %String(MAXLEN = "") [ SqlColumnNumber = 9 ];

Property ProvinceState As %String(MAXLEN = "") [ SqlColumnNumber = 2 ];

Property Recovered As %Integer [ SqlColumnNumber = 7 ];

Property FIPS As %Integer;

Property City As %String(MAXLEN = "");

Method LastUpdateSet(pVal) As %Status
{
 Try { Set pVal=+$zdth(pVal,3) }
 Catch ex {  }
 Set i%LastUpdate=pVal
 Quit $$$OK
}

ClassMethod Import(pSelectMode As %Library.Integer = {$zu(115,5)}, pFileName As %Library.String(MAXLEN=""), pDelimiter As %String = ",", pQuote As %String = """", pHeaders As %Integer = 0, ByRef pRecordCount As %Integer) As %Library.Integer [ SqlProc ]
{
	set tStatementId = $SYSTEM.Util.CreateGUID(), tCounter = 0, pRecordCount = 0
	set tPreparedStatement = ##class(%SQL.DynamicStatement).Prepare(tStatementId,..#ROWTYPE,pDelimiter,pQuote,,,0,"CSV")
	if $Isobject(tPreparedStatement) {
		set tImporter = tPreparedStatement.%New(tPreparedStatement,,pFileName,pDelimiter,pQuote)
		if $Isobject(tImporter) {
			do ..%DeleteExtent(,.tDeleted,.tInstances,1)
				// burn the column headers
			for tPtr = 1:1:pHeaders { do tImporter.%Next() }
			while tImporter.%Next() {
				set tMe = ..%New()
				if 'pSelectMode {
					set tMe.FIPS = tImporter.%GetData(1)
					set tMe.City = tImporter.%GetData(2)
					set tMe.ProvinceState = tImporter.%GetData(3)
					set tMe.CountryRegion = tImporter.%GetData(4)
					set tMe.LastUpdate = tImporter.%GetData(5)
					set tMe.Latitude = tImporter.%GetData(6)
					set tMe.Longitude = tImporter.%GetData(7)
					set tMe.Confirmed = tImporter.%GetData(8)
					set tMe.Deaths = tImporter.%GetData(9)
					set tMe.Recovered = tImporter.%GetData(10)
					
				}
				elseif pSelectMode = 1 {
					set tMe.ProvinceState = $s('$system.CLS.IsMthd("ProvinceStateOdbcToLogical"):tImporter.%GetData(1),1:tMe.ProvinceStateOdbcToLogical(tImporter.%GetData(1)))
					set tMe.CountryRegion = $s('$system.CLS.IsMthd("CountryRegionOdbcToLogical"):tImporter.%GetData(2),1:tMe.CountryRegionOdbcToLogical(tImporter.%GetData(2)))
					set tMe.LastUpdate = $s('$system.CLS.IsMthd("LastUpdateOdbcToLogical"):tImporter.%GetData(3),1:tMe.LastUpdateOdbcToLogical(tImporter.%GetData(3)))
					set tMe.Confirmed = $s('$system.CLS.IsMthd("ConfirmedOdbcToLogical"):tImporter.%GetData(4),1:tMe.ConfirmedOdbcToLogical(tImporter.%GetData(4)))
					set tMe.Deaths = $s('$system.CLS.IsMthd("DeathsOdbcToLogical"):tImporter.%GetData(5),1:tMe.DeathsOdbcToLogical(tImporter.%GetData(5)))
					set tMe.Recovered = $s('$system.CLS.IsMthd("RecoveredOdbcToLogical"):tImporter.%GetData(6),1:tMe.RecoveredOdbcToLogical(tImporter.%GetData(6)))
					set tMe.Latitude = $s('$system.CLS.IsMthd("LatitudeOdbcToLogical"):tImporter.%GetData(7),1:tMe.LatitudeOdbcToLogical(tImporter.%GetData(7)))
					set tMe.Longitude = $s('$system.CLS.IsMthd("LongitudeOdbcToLogical"):tImporter.%GetData(8),1:tMe.LongitudeOdbcToLogical(tImporter.%GetData(8)))
				}
				elseif pSelectMode = 2 {
					set tMe.ProvinceState = $s('$system.CLS.IsMthd("ProvinceStateDisplayToLogical"):tImporter.%GetData(1),1:tMe.ProvinceStateDisplayToLogical(tImporter.%GetData(1)))
					set tMe.CountryRegion = $s('$system.CLS.IsMthd("CountryRegionDisplayToLogical"):tImporter.%GetData(2),1:tMe.CountryRegionDisplayToLogical(tImporter.%GetData(2)))
					set tMe.LastUpdate = $s('$system.CLS.IsMthd("LastUpdateDisplayToLogical"):tImporter.%GetData(3),1:tMe.LastUpdateDisplayToLogical(tImporter.%GetData(3)))
					set tMe.Confirmed = $s('$system.CLS.IsMthd("ConfirmedDisplayToLogical"):tImporter.%GetData(4),1:tMe.ConfirmedDisplayToLogical(tImporter.%GetData(4)))
					set tMe.Deaths = $s('$system.CLS.IsMthd("DeathsDisplayToLogical"):tImporter.%GetData(5),1:tMe.DeathsDisplayToLogical(tImporter.%GetData(5)))
					set tMe.Recovered = $s('$system.CLS.IsMthd("RecoveredDisplayToLogical"):tImporter.%GetData(6),1:tMe.RecoveredDisplayToLogical(tImporter.%GetData(6)))
					set tMe.Latitude = $s('$system.CLS.IsMthd("LatitudeDisplayToLogical"):tImporter.%GetData(7),1:tMe.LatitudeDisplayToLogical(tImporter.%GetData(7)))
					set tMe.Longitude = $s('$system.CLS.IsMthd("LongitudeDisplayToLogical"):tImporter.%GetData(8),1:tMe.LongitudeDisplayToLogical(tImporter.%GetData(8)))
				}
				set tStatus = tMe.%Save()
				if $$$ISOK(tStatus) { set tCounter = tCounter + 1 }
			}
		}
	}
	set %sqlcontext.%SQLCODE = 0
	set %sqlcontext.%ROWCOUNT = tCounter
	set pRecordCount = tCounter
	quit tCounter
}

Parameter ROWTYPE = "FIPS INTEGER, CITY VARCHAR(100), ProvinceState VARCHAR(100),CountryRegion VARCHAR(100),LastUpdate DATE,Confirmed INTEGER,Deaths INTEGER,Recovered INTEGER,Latitude VARCHAR(50),Longitude VARCHAR(50)";

Storage Default
{
<Data name="covid03162020DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Confirmed</Value>
</Value>
<Value name="3">
<Value>CountryRegion</Value>
</Value>
<Value name="4">
<Value>Deaths</Value>
</Value>
<Value name="5">
<Value>LastUpdate</Value>
</Value>
<Value name="6">
<Value>Latitude</Value>
</Value>
<Value name="7">
<Value>Longitude</Value>
</Value>
<Value name="8">
<Value>ProvinceState</Value>
</Value>
<Value name="9">
<Value>Recovered</Value>
</Value>
<Value name="10">
<Value>FIPS</Value>
</Value>
<Value name="11">
<Value>City</Value>
</Value>
</Data>
<DataLocation>^AnalyzeThis.G.covid03162020D</DataLocation>
<DefaultData>covid03162020DefaultData</DefaultData>
<IdLocation>^AnalyzeThis.G.covid03162020D</IdLocation>
<IndexLocation>^AnalyzeThis.G.covid03162020I</IndexLocation>
<StreamLocation>^AnalyzeThis.G.covid03162020S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
