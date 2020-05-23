Class Hotel.Feedback Extends %Persistent
{

Property descr As %String;

Property date As %Date;

Storage Default
{
<Data name="FeedbackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>descr</Value>
</Value>
<Value name="3">
<Value>date</Value>
</Value>
</Data>
<DataLocation>^Hotel.FeedbackD</DataLocation>
<DefaultData>FeedbackDefaultData</DefaultData>
<IdLocation>^Hotel.FeedbackD</IdLocation>
<IndexLocation>^Hotel.FeedbackI</IndexLocation>
<StreamLocation>^Hotel.FeedbackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

ClassMethod saveFeedback(feedback As Hotel.Feedback) As %Status
{
    set obj = ##class(Hotel.DiscountList).%New()
    set obj.description = discount.description
    set obj.date = discount.date
    set result = obj.%Save()
    Return ##class(Hotel.Utils).getStatus(result)
}

ClassMethod getAllFeedbacks() As %Library.DynamicArray
{
	set data = ##class(%Library.DynamicArray).%New()
	&sql(
	 	DECLARE MyCursor CURSOR FOR
	    SELECT id, descr, date
	    INTO :id, :descr, :date
	    FROM Hotel.Feedback
 	)
 	&sql(OPEN MyCursor)
 	
  FOR { 
    &sql(FETCH MyCursor)
    if (SQLCODE) quit

    set obj = {"id": (id), "descr": (visitor), "date": ($ZDATE(date))}
    do data.%Push(obj)
 	}
 	&sql(CLOSE MyCursor)
 	
 	return data
}

}
