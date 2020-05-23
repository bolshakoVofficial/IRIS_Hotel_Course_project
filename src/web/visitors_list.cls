Class web.visitorsList Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
    do ..header()
    do ..body()
    do ..footer()
    Quit $$$OK
}

ClassMethod header() As %Status
{
    &HTML<
    <html>
        <head>
            <script type="text/javascript" src="webix/webix.min.js" ></script>
            <link rel="stylesheet" type="text/css" href="webix/webix.min.css">
            <link rel="stylesheet" href="https://cdn.materialdesignicons.com/2.7.94/css/materialdesignicons.css?v=7.2.0" type="text/css" charset="utf-8">
        </head>
    >

  Quit $$$OK
}

ClassMethod body() As %Status
{
    &JS<
        <script type="text/javascript">

        var submitVisitor = (rawData) => {
            let data = JSON.parse(rawData);
            let message;
            if (data.result) {
                message = { type:"success", text: "Visitor is saved", expire:-1};
                $$('tab2_content').clear();
            }
            else
                message = { type:"error", text: data.message, expire:-1};
            webix.message(message);
        }

        var visitor_list_template = {
            id:"tab1_content",
            view:"datatable",
            columns:[

                { id:"visitorID", header:"VisitorID", adjust:"true" },

                { id:"name", header:"Name", adjust:"true" },

                { id:"floor", header:"Floor", adjust:"true" },

                { id:"room", header:"Room", adjust:"true" },

                { id:"status", header:"Status", adjust:"true" },

                { 
                    id:"", 
                    template:"<input class='delbtn' type='button' value='Delete record'>",	
                    css:"padding_les",
                    width:100 
                }
  
            ],
            url:"/hotel/listVisitors"
        };


        var visitor_form_template = {
            id:"tab2_content",
            view:"form",
            width: "400",
            elements:[
                {view: "text", name: "name", label: "Name"},
                {view: "text", name: "floor", label: "Floor"},
                {view: "text", name: "room", label: "Room"},
                {view: "text", name: "status", label: "Status"},
                { view:"button",  value:"Save", id:"btn", 
                    click:function(){
                            var values = this.getFormView().getValues();
                            webix.ajax().post("/hotel/saveVisitor", values, submitVisitor);
                            var url = $$(`tab1_content`).data.url
                            $$(`tab1_content`).clearAll();
                            $$(`tab1_content`).load(url);
                        }
                }
            ]
        };
        var menu_data = [
	        {id: "tab1", icon: "mdi mdi-table", value:"Visitors list"},
	        {id: "tab2", icon: "mdi mdi-pencil", value:"Visitor registration"},
        ];
        var ui_template = {
            height: '100%',
            rows: [
                    { 
                        view: "toolbar", 
                        padding:3, 
                        elements: [
                            { 
                                view: "button",
                                type: "icon", 
                                icon: "mdi mdi-menu",
                                width: 37, align: "left", css: "app_button", click: function(){
                                    $$("$sidebar1").toggle();
                                }
                            },
                            { 
                                view: "label", 
                                label: "VisitorList Controller"
                            },
                        ]
                    },
                    { 
                        cols:[
                                {
                                    view: "sidebar",
                                    data: menu_data,
                                    on:{
                                        onAfterSelect: function(id){
                                            $$(`${id}_content`).show();
                                        }
                                    }
                                },
                                { 
                                    id:"t1_content",
                                    cells:[
                                            visitor_form_template,
                                            visitor_list_template
                                    ]   
                                }
                        ]
                    }
            ]
        };


        webix.ready(function(){
            webix.ui(ui_template);
            $$("tab1_content").on_click.delbtn=function(e, id, trg){
               
                var val = $$("tab1_content").getItem(id).visitorID;
                webix.message("Delete visitor: "+ val);
                webix.ajax().post("/hotel/deleteVisitor", {"id":val});
                var url = $$(`tab1_content`).data.url
                $$(`tab1_content`).clearAll();
                $$(`tab1_content`).load(url);
                //block default onclick event
                return false;
            };
        });
        </script>
    >
    Quit $$$OK
}

ClassMethod footer() As %Status
{
  &HTML<
    </body></html>
  >
  Quit $$$OK
}

}
