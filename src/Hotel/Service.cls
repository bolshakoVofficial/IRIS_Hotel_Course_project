Class Hotel.Service Extends %Persistent
{

Index serviceID On (name, price) [ PrimaryKey ];

Property name As %String;

Property price As %Integer;

Storage Default
{
<Data name="ServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>name</Value>
</Value>
<Value name="3">
<Value>price</Value>
</Value>
</Data>
<DataLocation>^Hotel.ServiceD</DataLocation>
<DefaultData>ServiceDefaultData</DefaultData>
<IdLocation>^Hotel.ServiceD</IdLocation>
<IndexLocation>^Hotel.ServiceI</IndexLocation>
<StreamLocation>^Hotel.ServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

ClassMethod saveService(service As Hotel.Service) As %Status
{
    set obj = ##class(Hotel.Service).%New()
    set obj.name = service.name
    set obj.price = service.price
    set result = obj.%Save()
    Return ##class(Hotel.Utils).getStatus(result)
}

ClassMethod getAllServices() As %Library.DynamicArray
{
	set data = ##class(%Library.DynamicArray).%New()
	&sql(
	 	DECLARE MyCursor CURSOR FOR
	    SELECT id, name, price
	    INTO :id, :name, :price
	    FROM Hotel.Service
 	)
 	&sql(OPEN MyCursor)
 	
  FOR { 
    &sql(FETCH MyCursor)
    if (SQLCODE) quit

    set obj = {"serviceID": (id), "name": (name),  "price": (price), "id":(id), "value": (name_"/"_id)}
    do data.%Push(obj)
 	}
 	&sql(CLOSE MyCursor)
 	
 	return data
}

}
