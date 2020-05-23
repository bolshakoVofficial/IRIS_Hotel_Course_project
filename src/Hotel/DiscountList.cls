Class Hotel.DiscountList Extends %Persistent
{

Index survID On (visitor, feedback) [ PrimaryKey ];

Property visitor As Hotel.Visitor;

Property feedback As Hotel.Feedback;

Property issue As %String;

Storage Default
{
<Data name="DiscountListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>visitor</Value>
</Value>
<Value name="3">
<Value>vote</Value>
</Value>
<Value name="4">
<Value>issue</Value>
</Value>
<Value name="5">
<Value>feedback</Value>
</Value>
</Data>
<DataLocation>^Hotel.DiscountListD</DataLocation>
<DefaultData>DiscountListDefaultData</DefaultData>
<IdLocation>^Hotel.DiscountListD</IdLocation>
<IndexLocation>^Hotel.DiscountListI</IndexLocation>
<StreamLocation>^Hotel.DiscountListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

ClassMethod saveDiscount(discount As Hotel.DiscountList) As %Status
{
    set obj = ##class(Hotel.DiscountList).%New()
    set obj.visitor = ##class(Hotel.Visitor).%OpenId(discount.visitor)
    set obj.feedback = ##class(Hotel.Feedback).%OpenId(discount.feedback)
    set obj.issue = discount.issue
    set result = obj.%Save()
    Return ##class(Hotel.Utils).getStatus(result)
}

ClassMethod getAllDiscounts() As %Library.DynamicArray
{
	set data = ##class(%Library.DynamicArray).%New()
	&sql(
	 	DECLARE MyCursor CURSOR FOR
	    SELECT id, visitor, feedback, issue
	    INTO :id, :visitor, :feedback, :issue
	    FROM Hotel.DiscountList
 	)
 	&sql(OPEN MyCursor)
 	
  FOR { 
    &sql(FETCH MyCursor)
    if (SQLCODE) quit

    set obj = {"survID": (id), "visitor": (visitor), "feedback": (feedback), "issue": (issue)}
    do data.%Push(obj)
 	}
 	&sql(CLOSE MyCursor)
 	
 	return data
}

}
