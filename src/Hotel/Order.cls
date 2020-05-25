Class Hotel.Order Extends %Persistent
{

Index orderID On (date, visitor, service) [ PrimaryKey ];

Property visitorID As Hotel.Visitor;

Property visitor As %String;

Property date As %Date;

Property serviceID As Hotel.Service;

Property service As %String;

Property sum As %Integer;

Storage Default
{
<Data name="OrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>data</Value>
</Value>
<Value name="3">
<Value>visitor</Value>
</Value>
<Value name="4">
<Value>summ</Value>
</Value>
<Value name="5">
<Value>sum</Value>
</Value>
<Value name="6">
<Value>service</Value>
</Value>
<Value name="7">
<Value>date</Value>
</Value>
<Value name="8">
<Value>visitorID</Value>
</Value>
<Value name="9">
<Value>serviceID</Value>
</Value>
</Data>
<DataLocation>^Hotel.OrderD</DataLocation>
<DefaultData>OrderDefaultData</DefaultData>
<IdLocation>^Hotel.OrderD</IdLocation>
<IndexLocation>^Hotel.OrderI</IndexLocation>
<StreamLocation>^Hotel.OrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

ClassMethod saveOrder(order As Hotel.Order) As %Status
{
    set obj = ##class(Hotel.Order).%New()
    set obj.visitorID = ##class(Hotel.Visitor).%OpenId(order.visitor)
    set obj.visitor = obj.visitorID.name
    set obj.date = order.date
    set obj.serviceID = ##class(Hotel.Service).%OpenId(order.service)
    set obj.service = obj.serviceID.name
    set obj.sum = order.sum
    set result = obj.%Save()
    Return ##class(Hotel.Utils).getStatus(result)
}

ClassMethod getAllOrders() As %Library.DynamicArray
{
	set data = ##class(%Library.DynamicArray).%New()
	&sql(
	 	DECLARE MyCursor CURSOR FOR
	    SELECT "id", "visitor", "date", "service", "sum"
	    INTO :id, :visitor, :date, :service, :sum
	    FROM Hotel.Order
 	)
 	&sql(OPEN MyCursor)
 	
  FOR { 
    &sql(FETCH MyCursor)
    if (SQLCODE) quit
    set obj = {"orderID": (id), "visitor": (visitor), "date": ($ZDATE(date)), "service": (service), "sum": (sum)}
    do data.%Push(obj)
 	}
 	&sql(CLOSE MyCursor)
 	
 	return data
}

}
